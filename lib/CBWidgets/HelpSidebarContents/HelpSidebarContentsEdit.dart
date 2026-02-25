import 'package:flutter/material.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Schema.dart';
import '../../Utils/Dialogs/SnackBars.dart';
import '../../Utils/PageUtils.dart';
import 'HelpSidebarContent.dart';
import 'HelpSidebarContentsProvider.dart';


class HelpSidebarContentsEdit extends StatefulWidget {
  const HelpSidebarContentsEdit({
    super.key,
    required this.schema,
    required this.data,
    this.serviceName,
		required this.content
  });
  final List<Schema> schema;
  final HelpSidebarContent data;
  final String? serviceName;
	final String content;

  @override
  State<HelpSidebarContentsEdit> createState() => _HelpSidebarContentsEditState();
}

class _HelpSidebarContentsEditState extends State<HelpSidebarContentsEdit> {
  final _formKey = GlobalKey<FormState>();
  Utils utils = Utils();

  final Map<String, dynamic> formData = {};

  @override
  void initState() {
    super.initState();
    dynamic initialValue = widget.data.toJson();
    // Initialize default values for each field
    for (var field in widget.schema) {
      formData[field.field] = initialValue[field.field];
    }
  }

  void saveForm() async {
    HelpSidebarContentsProvider provider = HelpSidebarContentsProvider();
    // Handle form submission logic here
    final data = HelpSidebarContent.fromJson(formData);
    Response response = await provider.updateOneAndSave(data.id!, data);
    SnackBars snackBar = SnackBars();
    if (response.isSuccess) {
      snackBar.SuccessSnackBar(context, "Successfully updated Help Sidebar Contents");
    } else {
      snackBar.FailedSnackBar(context, "Failed to update Help Sidebar Contents");
    }
  }

  bool shouldExcludeField(Schema field) {
    final excludedFields = [
      '_id',
      'createdAt',
      'updatedAt',
      'password'
    ]; // Keys to exclude
    final excludedTypes = ['bool', 'date']; // Types to exclude
    return excludedFields.contains(field.field) ||
        excludedTypes.contains(field.type!);
  }

  @override
  Widget build(BuildContext context) {
    dynamic initialValue = widget.data.toJson();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Edit ~cb-service-name-title-singular~",
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
              children: [
                ...widget.schema
                    .where((field) => !shouldExcludeField(field))
                    .map((field) => buildField(field)),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveForm,
        child: Icon(Icons.save),
      ),
    );
  }

  Widget buildField(Schema field) {
    dynamic initialValue = widget.data.toJson();
    switch (field.type?.toLowerCase()) {
      case 'string':
        void onChanged(value) {
          setState(() {
            formData[field.field] = value;
          });
        }
        if (field.field.toLowerCase().contains("email")) {
          return utils.buildEmailField(
              field, onChanged, initialValue[field.field]);
        } else {
          return utils.buildTextField(
              field, onChanged, initialValue[field.field]);
        }
      case 'boolean':
        void onChange(value) {
          setState(() {
            formData[field.field] = value;
          });
        }
        return utils.buildCheckbox(
            field, formData, onChange, initialValue[field.field]);
      case 'bool':
        void onChange(value) {
          setState(() {
            formData[field.field] = value;
          });
        }
        return utils.buildCheckbox(
            field, formData, onChange, initialValue[field.field]);
      case 'number':
        void onChange(value) {
          setState(() {
            formData[field.field] = value;
          });
        }
        return utils.buildNumberField(
            field, formData, onChange, initialValue[field.field]);
      case 'date':
        void onSetDate(value) {
          setState(() {
            formData[field.field] = value;
          });
        }
        return utils.buildDateField(
            field, formData, context, onSetDate, DateTime.parse(initialValue[field.field]));
      default:
        return SizedBox.shrink();
    }
  }
}