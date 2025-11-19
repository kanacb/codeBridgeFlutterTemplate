import 'package:flutter/material.dart';

import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Schema.dart';
import '../../Utils/Dialogs/SnackBars.dart';
import '../../Utils/PageUtils.dart';
import 'ExternalChecklists.dart';
import 'ExternalChecklistsProvider.dart';

class ExternalChecklistsEdit extends StatefulWidget {
  const ExternalChecklistsEdit({
    super.key,
    required this.resource,
    required this.checklist,
  });
  final List<Schema> resource;
  final ExternalChecklists checklist;

  @override
  State<ExternalChecklistsEdit> createState() => _ExternalChecklistsEditState();
}

class _ExternalChecklistsEditState extends State<ExternalChecklistsEdit> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};
  final Utils utils = Utils();

  @override
  void initState() {
    super.initState();
    // Initialize form data with the existing values from the checklist
    final initialValues = widget.checklist.toJson();
    for (var field in widget.resource) {
      formData[field.field] = initialValues[field.field];
    }
  }

  void saveForm() async {
    ExternalChecklistsProvider provider = ExternalChecklistsProvider();
    final data = ExternalChecklists.fromJson(formData);
    Response response =
    await provider.updateOneAndSave(data.id!, data);

    SnackBars snackBar = SnackBars();
    if (response.isSuccess) {
      snackBar.SuccessSnackBar(context, "Successfully updated checklist");
    } else {
      snackBar.FailedSnackBar(context, "Failed to update checklist");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Checklist - ${widget.checklist.id}"),
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
    final initialValues = widget.checklist.toJson();
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
