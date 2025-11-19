import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../MachineMaster/MachineMaster.dart';

class MachineNotFound extends StatefulWidget {
  final Function onBack;
  final String notAllowedStatus;
  final MachineMaster? machine;
  const MachineNotFound({
    super.key,
    required this.onBack,
    required this.notAllowedStatus,
    this.machine,
  });

  @override
  State<MachineNotFound> createState() => _MachineNotFoundState();
}

class _MachineNotFoundState extends State<MachineNotFound> {
  @override
  Widget build(BuildContext context) {
    switch (widget.notAllowedStatus) {
      case "notFound":
        return _buildNotFound(context);
      case "allowed":
        return _buildMachine(context, widget.machine);
      default:
        return _buildNotAllowed(context);
    }
  }

  Widget _buildNotFound(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () => widget.onBack(),
          child: Icon(Icons.qr_code_2_outlined),
        ),
        Text("Not found"),
        SizedBox(width: 22),
      ],
    );
  }

  Widget _buildNotAllowed(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Machine Not Allowed"),
        ElevatedButton(
          onPressed: () => widget.onBack(),
          child: Icon(Icons.arrow_forward),
        ),
        _buildMachine(context, widget?.machine),
      ],
    );
  }

  Widget _buildMachine(BuildContext context, MachineMaster? machine) {
    if (machine?.id is String) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Serial No"),
          Text(machine!.serialNumber.toString()),
          Text("Model"),
          Text(machine!.modelNo.toString()),
          Text("VM Code"),
          Text(machine!.vendingMachineCode.toString()),
          Text("Owner"),
          Text(machine.ownership.name.toString()),
          Text("Company"),
          Text(machine.ownership.companyId.name.toString()),
          SizedBox(width: 22),
        ],
      );
    } else {
      return SizedBox(width: 22);
    }
  }
}
