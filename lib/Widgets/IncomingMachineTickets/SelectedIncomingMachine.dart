import 'dart:developer';

import 'package:aims/Widgets/Companies/Companies.dart';
import 'package:aims/Widgets/ExternalMachines/ExternalMachinesProvider.dart';
import 'package:aims/Widgets/IncomingMachineTickets/RaiseIncomingTicket.dart';
import 'package:aims/Widgets/MemMachines/MemMachinesProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../App/MenuBottomBar/Profile/Profile.dart';
import '../../Utils/Methods.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Validators.dart';
import '../AtlasMachines/AtlasMachinesProvider.dart';
import '../IrmsMachines/IrmsMachinesProvider.dart';
import '../RaiseTicket/QrCodeScanner.dart';
import 'RaiseIncomingTicketProcess.dart';

class SelectedIncomingMachine extends StatefulWidget {
  final Barcode? result;
  final String companyType;

  const SelectedIncomingMachine({
    super.key,
    this.result,
    required this.companyType,
  });

  @override
  State<SelectedIncomingMachine> createState() => _SelectedIncomingMachineState();
}

class _SelectedIncomingMachineState extends State<SelectedIncomingMachine> {
  final _formKey = GlobalKey<FormState>();
  RaiseIncomingTicketProcess raiseIncomingTicketProcess = RaiseIncomingTicketProcess();
  String serialNumber = "";
  String qrcode = "";
  late List<dynamic>? _machines = [];
  late List<dynamic> checklists;
  late List<dynamic> checks;
  bool isSelected = false;
  bool isLoading = true;
  late final Profile? profile;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _init();
    });
  }

  Future<void> _QrCodeFound(String code) async {
    try {
      Response response = await IrmsMachinesProvider().fetchBySerialNoAndSave(code);
      if (response.data.isEmpty) {
        response = await AtlasMachinesProvider().fetchBySerialNoAndSave(code);
      }
      if (response.data.isEmpty) {
        response = await MemMachinesProvider().fetchBySerialNoAndSave(code);
      }
      if (response.data.isEmpty) {
        response = await ExternalMachinesProvider().fetchBySerialNoAndSave(code);
      }
      if (!mounted) return;

      final List<dynamic> machinesFromQR = response.data;
      if (machinesFromQR.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                'Machine with serial number "$code" not found.',
              ),
            ),
          );
      }
      setState(() {
        isLoading = false;
        _machines = machinesFromQR.isNotEmpty ? machinesFromQR : [];
      });

    } catch(e) {
      log(e.toString(), name: "ERROR QrCodeFound");
      if (mounted) {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'An error occurred while searching: $e',
            ),
          ),
        );
      }
    }
  }

  Future<void> _init() async {
    if (widget.result?.code is String) {
      await _QrCodeFound(widget.result!.code!);
    } else {
      setState(() {
        isLoading = false;
      });
    }
    profile = await Methods.loadSelectedProfile();
  }

  void loadChecks() async {
    dynamic check = await raiseIncomingTicketProcess.ChecklistsNChecks(context);
    checks = check["checks"];
    checklists = check["checklists"];
    log("checklists: ${check["checklists"].length}, checks: ${check["checks"].length}");
  }

  Future<void> _handleSearch() async {
    if (!_formKey.currentState!.validate()) {
      return; // stop if invalid
    }
    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });

    try {
      Response response = await IrmsMachinesProvider().fetchBySerialNoAndSave(serialNumber);
      if (response.data.isEmpty) {
        response = await AtlasMachinesProvider().fetchBySerialNoAndSave(serialNumber);
      }
      if (response.data.isEmpty) {
        response = await MemMachinesProvider().fetchBySerialNoAndSave(serialNumber);
      }
      if (response.data.isEmpty) {
        response = await ExternalMachinesProvider().fetchBySerialNoAndSave(serialNumber);
      }

      if (response.data.isEmpty) {
        setState(() {
          _machines = [];
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                'Machine with serial number "$serialNumber" not found.',
              ),
            ),
          );
        }
      } else {
        setState(() {
          _machines = response.data;
        });
      }
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Incoming Machine'),
        backgroundColor: Colors.white,
        elevation: 1,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Switch to Code Scanner'),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => QrCodeScanner(companyType: widget.companyType,),
                      ),
                    );
                  },
                  child: Icon(Icons.qr_code_2_outlined),
                ),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 20),
                Expanded(
                  flex: 4,
                  child: TextFormField(
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (_) => _handleSearch(),
                    autofocus: widget.result?.code is! String ,
                    initialValue: widget.result?.code,
                    maxLength: 35,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Vending Machine / Cooler Serial #',
                      labelText: 'Serial #',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    validator: (value) {
                      if (Validators.isStringNotEmpty(value)) {
                        return null;
                      }
                      return "Please enter valid Machine or Cooler Serial Number";
                    },
                    onSaved: (value) {
                      serialNumber = value!.toString();
                    },
                    onChanged:
                        (value) => setState(() {
                          serialNumber = value.toString();
                        }),
                  ),
                ),
                ElevatedButton(
                  autofocus: false,
                  onPressed: isLoading ? null : _handleSearch,
                  child: Icon(Icons.search),
                ),
              ],
            ),
            Column(
              children: [
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_machines != null && _machines!.isNotEmpty)
                  ..._machines!.map((m) => machineTile(m))
                else
                  const SizedBox.shrink()
              ]
            ),
          ],
        ),
      ),
    );
  }

  Widget machineTile(dynamic thisMachine) {
    Companies? machineCompany = Methods.getCompanyFromMachine(thisMachine);
    final Map<String, String> companies = {
      "atlas": "Atlas Machines",
      "etika": "MeM Machines",
      "external": "External Machines",
      "irms": "IRMS Machines",
    };

    loadChecks();

    return InkWell(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => RaiseIncomingTicket(
              qrCode: qrcode,
              profile: profile!,
              machine: thisMachine,
              checklists: checklists,
              checks: checks,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        padding: const EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(18.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Serial number + checkmark
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Serial #: ${thisMachine.serialNumber}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle, color: Colors.blue, size: 28),
              ],
            ),

            const SizedBox(height: 8),

            // Machine type
            Text(
              thisMachine.vendingMachineType!.name ?? "",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),

            const SizedBox(height: 4),

            // Company name
            Text(
              machineCompany?.name ?? "Unknown Company",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 14),

            // Model chip
            Chip(
              backgroundColor: Colors.orangeAccent,
              labelStyle: const TextStyle(color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
              label: Text(
                "Model: ${thisMachine.modelNo}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Bottom row: Code chip + company
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    "Code: ${thisMachine.vendingMachineCode}",
                    style: const TextStyle(fontSize: 13.0),
                  ),
                  backgroundColor: Colors.blue,
                  labelStyle: const TextStyle(color: Colors.white),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                ),
                Text(
                  companies[machineCompany?.companyType?.toLowerCase()] ?? "Unknown",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
