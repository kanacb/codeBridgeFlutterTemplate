import 'package:aims/Widgets/DocumentsStorage/DocumentStorage.dart';
import 'package:aims/Widgets/DocumentsStorage/DocumentStorageProvider.dart';
import 'package:aims/Widgets/IncomingMachineTickets/IncomingMachineTicket.dart';
import 'package:aims/Widgets/IncomingMachineTickets/IncomingMachineTicketProvider.dart';
import 'package:aims/Widgets/IrmsParts/IrmsParts.dart';
import 'package:aims/Widgets/IrmsParts/IrmsPartsProvider.dart';
import 'package:aims/Widgets/PartRequestDetails/PartRequestDetails.dart';
import 'package:aims/Widgets/PartRequestDetails/PartRequestDetailsProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../App/MenuBottomBar/Profile/Profile.dart';
import '../../Utils/Methods.dart';
import '../../Utils/Services/Response.dart';
import 'JobStationTicket.dart';
import 'PartRequestDetailsCreateDialog.dart';

class SingleJobStationTicketPage extends StatefulWidget {
  final JobStationTicket ticket;
  final dynamic machine;
  final Profile profile;

  const SingleJobStationTicketPage({
    super.key,
    required this.ticket,
    required this.machine,
    required this.profile,
  });

  @override
  State<SingleJobStationTicketPage> createState() => _SingleJobStationTicketPageState();
}

class _SingleJobStationTicketPageState extends State<SingleJobStationTicketPage> {
  late final JobStationTicket _jobStationTicket;
  IncomingMachineTicket? _incomingMachineTicket;
  late final dynamic _machine;
  late final Profile _profile;
  List<PartRequestDetails> _partRequestDetails = [];
  Map<String, IrmsParts> _irmsPartsMap = {};
  List<DocumentStorage> _documentStorages = [];
  bool _isLoading = false;

  List<String> _beforeRepairImageURLs = [];
  List<String> _afterRepairImageURLs = [];
  String? _timeDifference;

  @override
  void initState() {
    super.initState();
    _init();
  }
  
  Future<void> _init() async {
    setState(() {
      _isLoading = true;
    });

    _jobStationTicket = widget.ticket;
    _machine = widget.machine;
    _profile = widget.profile;

    await Future.wait([
      _loadPartRequestDetails(),
      _loadDocumentStorages(_jobStationTicket),
      _loadTicketData(),
    ]);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadPartRequestDetails() async {
    setState(() {
      _isLoading = true;
    });

    Response response = await PartRequestDetailsProvider().fetchByJobIdAndSave(_jobStationTicket.id!);
    if (response.error == null) {
      _partRequestDetails = response.data;

      // Fetch IrmsParts for each part request
      for (var partRequest in _partRequestDetails) {
        if (partRequest.partName != null && !_irmsPartsMap.containsKey(partRequest.partName)) {
          final irmsResponse = await IrmsPartsProvider().fetchOneAndSave(partRequest.partName!);
          if (irmsResponse.error == null) {
            _irmsPartsMap[partRequest.partName!] = irmsResponse.data;
          }
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadTicketData() async {
    setState(() {
      _isLoading = true;
    });

    Response response = await IncomingMachineTicketProvider().fetchOneAndSave(_jobStationTicket.ticketId!);
    if (response.error == null) _incomingMachineTicket = response.data;

    try {
      // Set image URLs from the ticket
      if (_jobStationTicket.uploadOfPictureBeforeRepair != null) {
        _beforeRepairImageURLs = _documentStorages
            .where((doc) => _jobStationTicket.uploadOfPictureBeforeRepair!.contains(doc.id))
            .map((doc) => doc.url ?? "")
            .where((url) => url.isNotEmpty)
            .toList();
      }
      if (_jobStationTicket.uploadOfPictureAfterRepair != null) {
        _afterRepairImageURLs = _documentStorages
            .where((doc) => _jobStationTicket.uploadOfPictureAfterRepair!.contains(doc.id))
            .map((doc) => doc.url ?? "")
            .where((url) => url.isNotEmpty) // filter out null/empty urls
            .toList();
      }

      // Calculate time difference
      if (_jobStationTicket.endTime != null && _jobStationTicket.startTime != null) {
        final diff = _jobStationTicket.endTime!.difference(_jobStationTicket.startTime!);
        _timeDifference = _formatTimeDifference(diff.inSeconds);
      } else {
        _timeDifference = 'In-Progress';
      }

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

  Future<void> _loadDocumentStorages(JobStationTicket ticket) async {
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
      case 'Open':
        return Colors.orange;
      case 'In-Progress':
        return Colors.blue;
      case 'Aborted':
        return Colors.red;
      case 'Closed':
      case 'Resolved':
        return Colors.green;
      case 'Not Started':
        return Colors.grey;
      default:
        return Colors.grey;
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
    final link = 'app://jobStationTickets/${widget.ticket.id}';
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
        title: const Text('Job Station Ticket'),
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
            _buildChecklistResponseSection(),
            const SizedBox(height: 16),
            _buildPartsRequestSection(), // Add this line
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
            _buildInfoGrid(),
            const SizedBox(height: 24),
            _buildImageSection('Pictures Before Repair', _beforeRepairImageURLs),
            _buildImageSection('Pictures After Repair', _afterRepairImageURLs),
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
            Expanded(child: _buildInfoField('Job Station', _jobStationTicket.jobStationId ?? 'N/A')),
          ],
        ),
        const SizedBox(height: 16),
        // Row 2
        Row(
          children: [
            Expanded(child: _buildInfoField('Machine Type', _machine.vendingMachineType?.name ?? '-')),
            const SizedBox(width: 16),
            Expanded(child: _buildInfoField('Supervisor', _jobStationTicket.supervisorId?.name ?? 'N/A')),
          ],
        ),
        const SizedBox(height: 16),
        // Row 3
        Row(
          children: [
            Expanded(child: _buildInfoField('Model No', _machine.modelNo ?? '-')),
            const SizedBox(width: 16),
            Expanded(child: _buildInfoField('Technician', _jobStationTicket.technicianId?.name ?? 'N/A')),
          ],
        ),
        const SizedBox(height: 16),
        // Row 4
        Row(
          children: [
            Expanded(child: _buildInfoField('Start Time', _jobStationTicket.startTime != null ? Methods.formatDateTime(_jobStationTicket.startTime) : 'In-Progress')),
            const SizedBox(width: 16),
            Expanded(child: _buildInfoField('Incoming Remarks', _jobStationTicket.incomingRemarks ?? '-')),
          ],
        ),
        const SizedBox(height: 16),
        // Row 5
        Row(
          children: [
            Expanded(child: _buildInfoField('End Time', _jobStationTicket.endTime != null ? Methods.formatDateTime(_jobStationTicket.endTime) : 'In-Progress')),
            const SizedBox(width: 16),
            Expanded(child: _buildInfoField('Closing Remarks', _jobStationTicket.jobCarriedOut ?? '-')),
          ],
        ),
        const SizedBox(height: 16),
        // Row 6
        Row(
          children: [
            Expanded(child: _buildInfoField('Time Difference', _timeDifference ?? 'Calculating...')),
            const SizedBox(width: 16),
            Expanded(child: _buildInfoField('Comments/Remarks', _jobStationTicket.comments ?? '-')),

          ],
        ),
        const SizedBox(height: 16),
        // Row 7
        Row(
          children: [
            Expanded(child: _buildStatusField('Status', _jobStationTicket.status)),
            const Expanded(child: SizedBox()), // Empty space
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

  Widget _buildImageSection(String label, List<String> images) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          if (images.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _showImageGallery(images, index, label),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          else
            SizedBox(
              height: 20,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('No pictures available',),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChecklistResponseSection() {
    final checklist = _incomingMachineTicket?.vendingControllerChecklistResponse;

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

  Widget _buildPartsRequestSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Part Requests',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_jobStationTicket.status == 'In Progress' && hasAccess(_profile.position?.name ?? ''))
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext dialogContext) => PartRequestDetailsCreateDialog(
                          ticket: _jobStationTicket,
                          profile: _profile,
                          onUpdated: () async {
                            await _loadPartRequestDetails();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Part Request created successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          onHide: () { Navigator.of(dialogContext).pop(); },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text("Request Parts", style: TextStyle(fontSize: 12)),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (_partRequestDetails.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _partRequestDetails.length,
                separatorBuilder: (context, index) => const Divider(height: 16),
                itemBuilder: (context, index) {
                  final partRequest = _partRequestDetails[index];
                  return _buildPartRequestCard(partRequest);
                },
              )
            else
              const Text(
                'No part requests available',
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartRequestCard(PartRequestDetails partRequest) {
    final IrmsParts? irmsPart = _irmsPartsMap[partRequest.partName];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  irmsPart?.description ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _buildStatusChip(partRequest.status),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSmallInfoField('Quantity', '${partRequest.quantity ?? 0}'),
              ),
              Expanded(
                child: _buildSmallInfoField(
                  'Requested Date',
                  partRequest.requestedDate != null
                      ? Methods.formatDateTime(partRequest.requestedDate)
                      : '-',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSmallInfoField(
                  'Approved Date',
                  partRequest.approvedDate != null
                      ? Methods.formatDateTime(partRequest.approvedDate)
                      : 'In-Progress',
                ),
              ),
              Expanded(
                child: _buildUsageField(partRequest.isUsed), // Changed this line
              ),
            ],
          ),
          if (partRequest.comment != null && partRequest.comment!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildSmallInfoField('Comment', partRequest.comment!),
          ],
        ],
      ),
    );
  }

  Widget _buildUsageField(bool? isUsed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Usage',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: isUsed == true ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            isUsed == true ? 'Used' : 'Void',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String? status) {
    Color backgroundColor;
    switch (status) {
      case 'Pending':
        backgroundColor = Colors.orange;
        break;
      case 'Approved':
        backgroundColor = Colors.green;
        break;
      case 'Rejected':
        backgroundColor = Colors.red;
        break;
      default:
        backgroundColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status ?? 'Unknown',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
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