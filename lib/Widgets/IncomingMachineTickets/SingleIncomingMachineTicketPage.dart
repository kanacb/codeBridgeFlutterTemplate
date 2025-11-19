import 'package:aims/Widgets/DocumentsStorage/DocumentStorage.dart';
import 'package:aims/Widgets/DocumentsStorage/DocumentStorageProvider.dart';
import 'package:aims/Widgets/IncomingMachineTickets/IncomingMachineTicket.dart';
import 'package:aims/Widgets/JobStationTickets/JobStationTicket.dart';
import 'package:aims/Widgets/JobStationTickets/JobStationTicketPopUp.dart';
import 'package:aims/Widgets/JobStationTickets/JobStationTicketProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../App/MenuBottomBar/Profile/Profile.dart';
import '../../Utils/Methods.dart';
import '../../Utils/Services/Response.dart';

class SingleIncomingMachineTicketPage extends StatefulWidget {
  final IncomingMachineTicket ticket;
  final dynamic machine;
  final Profile profile;

  const SingleIncomingMachineTicketPage({
    super.key,
    required this.ticket,
    required this.machine,
    required this.profile,
  });

  @override
  State<SingleIncomingMachineTicketPage> createState() => _SingleIncomingMachineTicketPageState();
}

class _SingleIncomingMachineTicketPageState extends State<SingleIncomingMachineTicketPage> {
  late final IncomingMachineTicket _ticket;
  late final dynamic _machine;
  late final Profile _profile;
  late final List<DocumentStorage> _documentStorages;
  bool _isLoading = true;

  List<String> _machineImageURLs = [];
  String? _timeDifference;
  List<JobStationTicket> _jobStationTickets = [];
  List<JobStationData> _selectedJobStations = []; // job stations in incoming machine ticket

  @override
  void initState() {
    super.initState();
    _loadTicketData();
  }

  Future<void> _loadTicketData() async {
    _ticket = widget.ticket;
    _machine = widget.machine;
    _profile = widget.profile;
    await _loadDocumentStorages(_ticket);

    try {
      // Set image URLs from the ticket
      if (_ticket.machineImage != null) {
        _machineImageURLs = _documentStorages
            .where((doc) => _ticket.machineImage!.contains(doc.id))
            .map((doc) => doc.url ?? "")
            .where((url) => url.isNotEmpty)
            .toList();
      }

      // Calculate time difference
      if (_ticket.endTime != null && _ticket.startTime != null) {
        final diff = _ticket.endTime!.difference(_ticket.startTime!);
        _timeDifference = _formatTimeDifference(diff.inSeconds);
      } else {
        _timeDifference = 'In-Progress';
      }

      // Load job stations data
      _selectedJobStations = await _loadJobStations();

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Failed to load ticket data: $error', isError: true);
    }
  }

  Future<List<JobStationData>> _loadJobStations() async {
    Response response = await JobStationTicketProvider().fetchByIncomingTicketAndSave(_ticket.id!);
    _jobStationTickets = response.data;

    // Map tickets by jobStationId as key for quick lookup
    final ticketMap = {
      for (var t in _jobStationTickets) t.jobStationId: t,
    };

    final stations = _ticket.selectedJobStations ?? [];

    return stations.map((station) {
      final ticket = ticketMap[station.name]; // Match by name/id

      String timeDifference;
      final start = ticket?.startTime;
      final end = ticket?.endTime;

      if (start == null) {
        timeDifference = 'not started';
      } else if (end == null) {
        timeDifference = 'in-progress';
      } else {
        final diff = end.difference(start);
        timeDifference = _formatTimeDifference(diff.inSeconds);
      }

      return JobStationData(
        jobStationName: ticket?.jobStationId ?? "Unknown Station",
        technicianName: ticket?.technicianId?.name ?? "Unassigned",
        status: ticket?.status ?? "not started",
        timeDifference: timeDifference,
      );
    }).toList();
  }

  Future<void> _loadDocumentStorages(IncomingMachineTicket ticket) async {
    Response response = await DocumentStorageProvider().fetchByTableIdAndSave(ticket.id!);
    if (response.error == null) _documentStorages = response.data;
  }

  String _formatTimeDifference(int seconds) {
    if (seconds <= 0) return '0 seconds';

    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    List<String> parts = [];
    if (hours > 0) parts.add('${hours} hour${hours > 1 ? 's' : ''}');
    if (minutes > 0) parts.add('${minutes} minute${minutes > 1 ? 's' : ''}');
    if (remainingSeconds > 0) parts.add('${remainingSeconds} second${remainingSeconds > 1 ? 's' : ''}');

    return parts.join(' ');
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Open': return Colors.orange;
      case 'In Progress':
      case 'In-Progress': return Colors.blue;
      case 'Aborted': return Colors.red;
      case 'Closed':
      case 'Resolved': return Colors.green;
      case 'Not Started': return Colors.grey;
      default: return Colors.grey;
    }
  }

  void _showImageGallery(List<String> images, int initialIndex, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageGalleryPage(
          images: images,
          initialIndex: initialIndex,
          title: title,
        ),
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _copyPageLink() {
    final link = 'app://incomingMachineTickets/${widget.ticket.id}';
    Clipboard.setData(ClipboardData(text: link));
    _showSnackBar('Page link copied to clipboard!');
  }

  bool hasAccess(String position) {
    const List<String> positions = [
      "Admin", "Super", "Technician", "Supervisor"
    ];

    return positions.contains(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Incoming Machine Ticket'),
        backgroundColor: Colors.white,
        elevation: 1,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_horiz),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: _copyPageLink,
                child: const Row(
                  children: [
                    Icon(Icons.copy, size: 20),
                    SizedBox(width: 8),
                    Text('Copy link'),
                  ],
                ),
              ),
              const PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.help_outline, size: 20),
                    SizedBox(width: 8),
                    Text('Help'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildMainInfoCard(),
            const SizedBox(height: 16),
            _buildSelectedJobStationsSection(),
            const SizedBox(height: 16),
            _buildChecklistResponseSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Grid layout similar to React version
            _buildInfoGrid(),
            const SizedBox(height: 24),
            _buildMachineImagesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoGrid() {
    return Column(
      children: [
        // Row 1
        Row(
          children: [
            Expanded(child: _buildInfoField('Machine Serial No', _machine.serialNumber ?? '-')),
            const SizedBox(width: 16),
            Expanded(child: _buildInfoField('Model No', _machine.modelNo ?? '-')),
          ],
        ),
        const SizedBox(height: 16),
        // Row 2
        Row(
          children: [
            Expanded(child: _buildInfoField('Machine Type', _machine.vendingMachineType?.name ?? '-')),
            const SizedBox(width: 16),
            Expanded(child: _buildInfoField('Incoming Machine Checker', _ticket.incomingMachineChecker?.name ?? 'N/A')),
          ],
        ),
        const SizedBox(height: 16),
        // Row 3
        Row(
          children: [
            Expanded(child: _buildInfoField('Assigned Supervisor', _ticket.assignedSupervisor?.name ?? 'N/A')),
            const SizedBox(width: 16),
            Expanded(child: _buildInfoField('Start Time', _ticket.startTime != null ? Methods.formatDateTime(_ticket.startTime) : 'In-Progress')),
          ],
        ),
        const SizedBox(height: 16),
        // Row 4
        Row(
          children: [
            Expanded(child: _buildInfoField('End Time', _ticket.endTime != null ? Methods.formatDateTime(_ticket.endTime) : 'In-Progress')),
            const SizedBox(width: 16),
            Expanded(child: _buildInfoField('Time Difference', _timeDifference ?? 'Calculating...')),
          ],
        ),
        const SizedBox(height: 16),
        // Row 5
        Row(
          children: [
            Expanded(child: _buildStatusField('Status', _ticket.status)),
            const SizedBox(width: 16),
            Expanded(child: _buildInfoField('Comments/Remarks', _ticket.comments ?? '-')),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusField(String label, String? status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(status),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            status ?? 'Unknown',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMachineImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Machine Images',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        if (_machineImageURLs.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _machineImageURLs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showImageGallery(_machineImageURLs, index, 'Machine Images'),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                      image: DecorationImage(
                        image: NetworkImage(_machineImageURLs[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        else
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Center(
              child: Text(
                'No images available',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSelectedJobStationsSection() {
    final hasStations = _selectedJobStations.isNotEmpty;
    final selectedProfilePosition = _profile.position?.name ?? "";

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: hasStations && hasAccess(selectedProfilePosition) ? () => _showBottomSheet() : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Selected Job Stations',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (hasStations && hasAccess(selectedProfilePosition))
                    const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 16),

              if (hasStations)
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedJobStations.length,
                    itemBuilder: (context, index) {
                      final jobStation = _selectedJobStations[index];
                      return Container(
                        width: 220,
                        margin: const EdgeInsets.only(right: 12),
                        child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      jobStation.jobStationName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.person, size: 14, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            jobStation.technicianName,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(jobStation.status),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        jobStation.status,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 8),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: Colors.grey[200]!),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          jobStation.timeDifference != null
                                              ? jobStation.timeDifference!
                                              : 'not started',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                const Text(
                  'No job stations assigned',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistResponseSection() {
    final checklist = _ticket.vendingControllerChecklistResponse;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Incoming Machine Checklist Response',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            if (checklist != null && checklist.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: checklist.map<Widget>((item) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "${item.checkListId?.name}: ${item.responseValue}",
                    style: const TextStyle(fontSize: 12),
                  ),
                )).toList(),
              )
            else
              const Text(
                'No checklist data available',
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      enableDrag: true,
      builder: (BuildContext _) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: JobStationTicketPopUp(
            tickets: _jobStationTickets,
            incomingMachine: _machine,
            profile: _profile,
          ),
        );
      },
    );
  }
}

class JobStationData {
  final String jobStationName;
  final String technicianName;
  final String status;
  final String? timeDifference; // in seconds

  JobStationData({
    required this.jobStationName,
    required this.technicianName,
    required this.status,
    this.timeDifference,
  });
}

class ImageGalleryPage extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String title;

  const ImageGalleryPage({
    Key? key,
    required this.images,
    required this.initialIndex,
    required this.title,
  }) : super(key: key);

  @override
  State<ImageGalleryPage> createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${widget.title} (${_currentIndex + 1}/${widget.images.length})'),
      ),
      body: PhotoViewGallery.builder(
        pageController: _pageController,
        itemCount: widget.images.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.images[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}