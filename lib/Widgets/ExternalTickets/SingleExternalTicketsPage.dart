import 'package:aims/Widgets/DocumentsStorage/DocumentStorage.dart';
import 'package:aims/Widgets/DocumentsStorage/DocumentStorageProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../Utils/Methods.dart';
import '../../Utils/Services/Response.dart';
import '../ExternalMachines/ExternalMachines.dart';
import 'ExternalTickets.dart';

class SingleExternalTicketsPage extends StatefulWidget {
  final ExternalTickets ticket;
  final ExternalMachines? machine;

  const SingleExternalTicketsPage({
    super.key,
    required this.ticket,
    this.machine,
  });

  @override
  State<SingleExternalTicketsPage> createState() => _SingleExternalTicketsPageState();
}

class _SingleExternalTicketsPageState extends State<SingleExternalTicketsPage> {

  late final ExternalTickets _ticket;
  late final ExternalMachines? _machine;
  late final List<DocumentStorage> _documentStorages;
  bool _isLoading = true;

  List<String> _machineImageURLs = [];
  List<String> _beforeRepairImageURLs = [];
  List<String> _afterRepairImageURLs = [];

  String? _timeDifference;

  @override
  void initState() {
    super.initState();
    _loadTicketData();
  }

  Future<void> _loadTicketData() async {
    _ticket = widget.ticket;
    _machine = widget.machine;
    await _loadDocumentStorages(_ticket);

    try {
      // Set image URLs from the ticket
      if (_ticket.machineImage != null) {
        _machineImageURLs = _documentStorages
            .where((doc) => _ticket.machineImage!.contains(doc.id))
            .map((doc) => doc.url ?? "")
            .where((url) => url.isNotEmpty) // filter out null/empty urls
            .toList();
      }
      if (_ticket.uploadOfPictureBeforeRepair != null) {
        _beforeRepairImageURLs = _documentStorages
            .where((doc) => _ticket.uploadOfPictureBeforeRepair!.contains(doc.id))
            .map((doc) => doc.url ?? "")
            .where((url) => url.isNotEmpty) // filter out null/empty urls
            .toList();
      }
      if (_ticket.uploadOfPictureAfterRepair != null) {
        _afterRepairImageURLs = _documentStorages
            .where((doc) => _ticket.uploadOfPictureAfterRepair!.contains(doc.id))
            .map((doc) => doc.url ?? "")
            .where((url) => url.isNotEmpty) // filter out null/empty urls
            .toList();
      }

      // Calculate time difference
      if (_ticket.endTime != null && _ticket.startTime != null) {
        final diff = _ticket.endTime!.difference(_ticket.startTime!);
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

  Future<void> _loadDocumentStorages(ExternalTickets ticket) async {
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
        return Colors.green;
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
    final link = 'app://externalTickets/${widget.ticket.id}';
    Clipboard.setData(ClipboardData(text: link));
    _showSnackBar('Page link copied to clipboard!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('External Tickets'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
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
            // First row with 3 cards
            LayoutBuilder(
              builder: (context, constraints) {
                // Desktop/tablet layout
                if (constraints.maxWidth > 900) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildMachineDetailsCard()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildExternalUserCard()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildSupervisorCard()),
                    ],
                  );
                }
                // Mobile layout
                return Column(
                  children: [
                    _buildMachineDetailsCard(),
                    const SizedBox(height: 16),
                    _buildExternalUserCard(),
                    const SizedBox(height: 16),
                    _buildSupervisorCard(),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            // Full width technician card
            _buildTechnicianCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildMachineDetailsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.settings, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Machine Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Machine Serial No', _machine?.serialNumber ?? '-'),
            _buildInfoRow('Model No', _machine?.modelNo ?? '-'),
            _buildInfoRow('Machine Type', _machine?.vendingMachineType?.name ?? '-'),
            _buildInfoRow('Ownership', _machine?.ownership.name ?? '-'),
            _buildInfoRow('Company', _machine?.ownership.companyId.name ?? '-'),
            _buildStatusRow('Status', _ticket.status ?? 'Unknown'),
            _buildInfoRow('Time Difference', _timeDifference ?? 'Calculating...'),
          ],
        ),
      ),
    );
  }

  Widget _buildExternalUserCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'External User',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('External User', _ticket.externalUser?.name ?? 'N/A'),
            _buildInfoRow('Start Time', _ticket.startTime != null ? Methods.formatDateTime(_ticket.startTime) : 'In-Progress'),
            _buildInfoRow('End Time', _ticket.endTime != null ? Methods.formatDateTime(_ticket.endTime) : 'In-Progress'),
            _buildChecklistSection(),
            _buildImageSection('Machine Image', _machineImageURLs),
            // todo uncomment this after this got added in the webapp
            // _buildInfoRow('Comment', _ticket.salesmanComment?.isNotEmpty == true
            //     ? _ticket.salesmanComment!
            //     : 'No comment available'),
          ],
        ),
      ),
    );
  }

  Widget _buildSupervisorCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Supervisor',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Supervisor', _ticket.assignedSupervisor?.name ?? 'N/A'),
            _buildInfoRow('Start Time', _ticket.supervisorStartTime != null ? Methods.formatDateTime(_ticket.supervisorStartTime) : 'In-Progress'),
            _buildInfoRow('End Time', _ticket.supervisorEndTime != null ? Methods.formatDateTime(_ticket.supervisorEndTime) : 'In-Progress'),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicianCard() {
    return SafeArea(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.purple,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Technician',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Responsive layout for technician info
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 900) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildInfoRow('Technician', _ticket.assignedTechnician?.name ?? 'N/A')),
                        Expanded(child: _buildInfoRow('Start Time', _ticket.technicianStartTime != null ? Methods.formatDateTime(_ticket.technicianStartTime) : 'In-Progress')),
                        Expanded(child: _buildInfoRow('End Time', _ticket.technicianEndTime != null ? Methods.formatDateTime(_ticket.technicianEndTime) : 'In-Progress')),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _buildInfoRow('Technician', _ticket.assignedTechnician?.name ?? 'N/A'),
                      _buildInfoRow('Start Time', _ticket.technicianStartTime != null ? Methods.formatDateTime(_ticket.technicianStartTime) : 'In-Progress'),
                      _buildInfoRow('End Time', _ticket.technicianEndTime != null ? Methods.formatDateTime(_ticket.technicianEndTime) : 'In-Progress'),
                    ],
                  );
                },
              ),
              _buildImageSection('Pictures Before Repair', _beforeRepairImageURLs),
              _buildImageSection('Pictures After Repair', _afterRepairImageURLs),
              _buildInfoRow('Opening Remarks', _ticket.openingRemarks?.isNotEmpty == true
                  ? _ticket.openingRemarks!
                  : 'No comment available'),
              _buildInfoRow('Closing Remarks', _ticket.closingRemarks?.isNotEmpty == true
                  ? _ticket.closingRemarks!
                  : 'No comment available'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String? status) {
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
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(status),
              borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }

  Widget _buildChecklistSection() {
    final checklist = _ticket.checklistResponse;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Checklist Response',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          if (checklist != null && checklist.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: checklist.asMap().entries.map((entry) {
                final colors = [
                  Colors.blue,
                  Colors.green,
                  Colors.orange,
                  Colors.purple,
                  Colors.red,
                ];
                return Chip(
                  label: Text(
                    entry.value,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  backgroundColor: colors[entry.key % colors.length],
                );
              }).toList(),
            )
          else
            const Text('No checklist data available'),
        ],
      ),
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
            const Text('No pictures available'),
        ],
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