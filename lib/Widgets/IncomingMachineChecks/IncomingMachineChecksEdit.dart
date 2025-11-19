import 'package:flutter/material.dart';

import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Schema.dart';
import '../../Utils/Dialogs/SnackBars.dart';
import '../../Utils/PageUtils.dart';
import 'IncomingMachineChecks.dart';
import 'IncomingMachineChecksProvider.dart';

class IncomingMachineChecksEdit extends StatefulWidget {
  const IncomingMachineChecksEdit({
    super.key,
    required this.resource,
    required this.check,
  });
  final List<Schema> resource;
  final IncomingMachineChecks check;

  @override
  State<IncomingMachineChecksEdit> createState() => _IncomingMachineChecksEditState();
}

class _IncomingMachineChecksEditState extends State<IncomingMachineChecksEdit> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};
  final Utils utils = Utils();

  @override
  void initState() {
    super.initState();
    // Initialize form data with the existing values from the check
    final initialValues = widget.check.toJson();
    for (var field in widget.resource) {
      formData[field.field] = initialValues[field.field];
    }
  }

  void saveForm() async {
    IncomingMachineChecksProvider provider = IncomingMachineChecksProvider();
    final data = IncomingMachineChecks.fromJson(formData);
    Response response = await provider.updateOneAndSave(data.id!, data);

    SnackBars snackBar = SnackBars();
    if (response.isSuccess) {
      snackBar.SuccessSnackBar(context, "Successfully updated IncomingMachine check");
    } else {
      snackBar.FailedSnackBar(context, "Failed to update IncomingMachine check");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit IncomingMachine Check - ${widget.check.id}"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: widget.resource.map((field) => buildField(field)).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveForm,
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget buildField(Schema field) {
    final initialValues = widget.check.toJson();
    switch (field.type) {
      case 'string':
        return utils.buildTextField(field, (value) {
          formData[field.field] = value;
        }, initialValues[field.field]);
      case 'number':
        return utils.buildNumberField(field, formData, (value) {
          formData[field.field] = value;
        }, initialValues[field.field]);
      case 'bool':
        return utils.buildCheckbox(field, formData, (value) {
          formData[field.field] = value;
        }, initialValues[field.field]);
      default:
        return const SizedBox.shrink();
    }
  }
}
