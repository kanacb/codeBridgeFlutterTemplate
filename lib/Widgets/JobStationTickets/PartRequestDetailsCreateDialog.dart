import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:aims/App/MenuBottomBar/Profile/Profile.dart';
import 'package:aims/Widgets/IrmsParts/IrmsParts.dart';
import 'package:aims/Widgets/IrmsParts/IrmsPartsProvider.dart';
import 'package:aims/Widgets/PartRequestDetails/PartRequestDetailsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Utils/Services/IdName.dart';
import '../../Utils/Services/SharedPreferences.dart';
import '../PartRequestDetails/PartRequestDetails.dart';
import '../Users/User.dart';
import 'JobStationTicket.dart';

class PartRequestDetailsCreateDialog extends StatefulWidget {
  final JobStationTicket ticket;
  final Profile profile;
  final VoidCallback onUpdated;
  final VoidCallback onHide;

  const PartRequestDetailsCreateDialog({
    super.key,
    required this.ticket,
    required this.profile,
    required this.onUpdated,
    required this.onHide,
  });

  @override
  State<PartRequestDetailsCreateDialog> createState() =>
      _PartRequestDetailsCreateDialogState();
}

class _PartRequestDetailsCreateDialogState extends State<PartRequestDetailsCreateDialog> {
  List<IrmsParts> _allParts = [];
  List<IrmsParts> _filteredParts = [];
  IrmsParts? _selectedPart;
  late final User _user;

  int _quantity = 1;

  bool _loading = false;
  String? _error;

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _init();
    _fetchParts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _init() async {
    _user = User.fromJson(jsonDecode(await getPref("user") ?? ""));
  }

  Future<void> _fetchParts() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final partsProvider = Provider.of<IrmsPartsProvider>(context, listen: false);
      await partsProvider.fetchAllAndSave();

      setState(() {
        _allParts = partsProvider.data;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to fetch parts: $e";
        _allParts = [];
      });
      log(_error!, name: "PartRequestDetailsCreateDialog");
    } finally {
      setState(() => _loading = false);
    }
  }

  void _searchParts(String query) {
    _debounceTimer?.cancel();

    final searchTerm = query.trim().toLowerCase();

    if (searchTerm.length < 2) {
      setState(() {
        _filteredParts = [];
      });
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 250), () {
      final filtered = _allParts.where((part) {
        final searchableText =
        '${part.serialNo ?? ''} ${part.itemNo ?? ''} ${part.description ?? ''}'
            .toLowerCase();
        return searchableText.contains(searchTerm);
      }).toList();

      setState(() {
        _filteredParts = filtered.take(50).toList();
      });
    });
  }

  bool _validate() {
    if (_selectedPart == null) {
      setState(() {
        _error = "Please select a part.";
      });
      return false;
    }
    return true;
  }

  Future<void> _save() async {
    if (!_validate()) return;

    setState(() => _loading = true);

    try {
      final PartRequestDetails partRequestDetails = PartRequestDetails(
        partName: _selectedPart!.id,
        quantity: _quantity,
        status: 'Pending',
        requestedDate: DateTime.now().toUtc(),
        jobId: widget.ticket.id,
        isUsed: false,
        technician: IdName(sId: widget.profile.id, name: widget.profile.name),
        createdBy: IdName(sId: _user.id, name: _user.name),
        updatedBy: IdName(sId: _user.id, name: _user.name),
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      final response = await PartRequestDetailsProvider().createOneAndSave(partRequestDetails);
      if (response.error != null) {
        throw Exception(response.error);
      }

      if (context.mounted) {
        widget.onHide();
        widget.onUpdated();
      }
    } catch (e) {
      setState(() {
        _error = "Failed to create part request: $e";
      });
      log(_error!, name: "PartRequestDetailsCreateDialog");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create Part Request: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Part Request"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Part Name Search/Autocomplete
            Autocomplete<IrmsParts>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                _searchParts(textEditingValue.text);
                return _filteredParts;
              },
              displayStringForOption: (IrmsParts option) => option.displayLabel,
              onSelected: (IrmsParts selection) {
                setState(() {
                  _selectedPart = selection;
                  _error = null;
                });
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                _searchController.text = controller.text;
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Part Name',
                    hintText: 'Search by Serial No, Item No, or Description',
                    errorText: _error,
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                  ),
                  onChanged: _searchParts,
                );
              },
            ),
            const SizedBox(height: 16),

            // Quantity Input
            Row(
              children: [
                const Text(
                  'Quantity:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: _loading || _quantity <= 1
                      ? null
                      : () {
                    setState(() {
                      _quantity--;
                    });
                  },
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '$_quantity',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  onPressed: _loading
                      ? null
                      : () {
                    setState(() {
                      _quantity++;
                    });
                  },
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
              ],
            ),

            if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : widget.onHide,
          child: const Text("Close"),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _save,
          child: const Text("Save"),
        ),
      ],
    );
  }
}