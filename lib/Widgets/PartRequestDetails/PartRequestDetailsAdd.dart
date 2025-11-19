import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Schema.dart';
import '../../Utils/Dialogs/SnackBars.dart';
import '../../Utils/PageUtils.dart';
import 'PartRequestDetails.dart';
import 'PartRequestDetailsProvider.dart';

class PartRequestDetailsAdd extends StatefulWidget {
  const PartRequestDetailsAdd({super.key, required this.resource});
  final List<Schema> resource;

  @override
  State<PartRequestDetailsAdd> createState() => _PartRequestDetailsAddState();
}

class _PartRequestDetailsAddState extends State<PartRequestDetailsAdd> {
  final _formKey = GlobalKey<FormState>();
  Utils utils = Utils();

  final Map<String, dynamic> formData = {};

  @override
  void initState() {
    super.initState();
    // Initialize default values for each field
    for (var field in widget.resource) {
      formData[field.field] = field.type == 'bool' ? false : null;
    }
  }

  void saveForm() async {
    print('Form Data: $formData');
    PartRequestDetailsProvider externalTicketProvider = PartRequestDetailsProvider();
    // Handle form submission logic here
    final data = PartRequestDetails.fromJson(formData);
    Response response = await externalTicketProvider.createOneAndSave(data);
    SnackBars snackBar = SnackBars();
    if (response.isSuccess) {
      snackBar.SuccessSnackBar(context, "Successfully created external ticket");
    } else {
      snackBar.FailedSnackBar(context, "Failed to create external ticket");
    }
  }

  bool shouldExcludeField(Schema? field) {
    if (field == null) return true; // Exclude null fields

    final excludedFields = [
      '_id',
      'createdAt',
      'updatedAt',
      'password'
    ];
    final excludedTypes = ['bool', 'date'];

    if (field.field == null || field.type == null) return true;

    return excludedFields.contains(field.field) ||
        excludedTypes.contains(field.type);
  }


  @override
  Widget build(BuildContext context) {
    Utils utils = Utils();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Add new external ticket",
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // children: [
                //   ...widget.resource
                //       .where((field) => !shouldExcludeField(field))
                //       .map((field) => buildField(field))
                //       .toList(),
                //   SizedBox(height: 16.0),
                // ],
              ),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveForm,
        child: Icon(Icons.save),
      ),
    );
  }

  // Helper method to build fields dynamically
  Object buildField(Schema field) {
    switch (field.type?.toLowerCase()) {
      case 'string':
        void onChange(value) {
          setState(() {
            formData[field.field] = value;
          });
        }
        if (field.field.toLowerCase().contains("email")) {
          return utils.buildEmailField(field, onChange, "");
        } else if (field.description!.toLowerCase().contains("isArray")) {
          return utils.buildCheckboxArray(field, formData, onChange, false);
        } else {
          return utils.buildTextField(field, onChange, "");
        }
      case 'boolean':
        void onChange(value) {
          setState(() {
            formData[field.field] = value;
          });
        }
        return utils.buildCheckbox(field, formData, onChange, false);
      case 'bool':
        void onChange(value) {
          setState(() {
            formData[field.field] = value;
          });
        }
        return utils.buildCheckbox(field, formData, onChange, false);
      case 'number':
        void onChanged(value) {
          setState(() {
            formData[field.field] = value;
          });
        }
        return utils.buildNumberField(field, formData, onChanged, 0);
      case 'date':
        void onSetDate(value) {
          setState(() {
            formData[field.field] = value;
          });
        }
        return utils.buildDateField(field, formData, context, onSetDate, DateTime.now());
      default:
        return SizedBox.shrink();
    }
  }
}
