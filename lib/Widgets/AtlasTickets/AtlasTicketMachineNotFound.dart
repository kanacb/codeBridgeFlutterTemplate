import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AtlasTicketMachineNotFound extends StatefulWidget {
  final Function onBack;
  final String notAllowedStatus;
  const AtlasTicketMachineNotFound(
      {super.key, required this.onBack, required this.notAllowedStatus});

  @override
  State<AtlasTicketMachineNotFound> createState() =>
      _AtlasTicketMachineNotFoundState();
}

class _AtlasTicketMachineNotFoundState
    extends State<AtlasTicketMachineNotFound> {
  @override
  Widget build(BuildContext context) {
    return (widget.notAllowedStatus == "notFound")
        ? _buildNotFound(context)
        : _buildNotAllowed(context);
  }

  Widget _buildNotFound(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
            onPressed: () => widget.onBack(),
            child: Icon(Icons.qr_code_2_outlined)),
        Text("Not found"),
        SizedBox(
          width: 22,
        )
      ],
    );
  }

  Widget _buildNotAllowed(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
            onPressed: () => widget.onBack(),
            child: Icon(Icons.qr_code_2_outlined)),
        Text("Not Allowed"),
        SizedBox(
          width: 22,
        )
      ],
    );
  }
}
