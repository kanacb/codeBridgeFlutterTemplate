import 'package:flutter/material.dart';

import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Schema.dart';
import '../../Utils/Dialogs/SnackBars.dart';
import '../../Utils/PageUtils.dart';
import 'User.dart';
import 'UserProvider.dart';

class UserEdit extends StatefulWidget {
  const UserEdit({super.key, required this.resource, required this.user});
  final List<Schema> resource;
  final User user;

  @override
  State<UserEdit> createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  final _formKey = GlobalKey<FormState>();
  Utils utils = Utils();

  final Map<String, dynamic> formData = {};

  @override
  void initState() {
    super.initState();
    dynamic initialValue = widget.user.toJson();
    // Initialize default values for each field
    for (var field in widget.resource) {
      formData[field.field] = initialValue[field.field];
    }
  }

  void saveForm() async {
    print('Form Data: $formData');
    UserProvider userProvider = UserProvider();
    // Handle form submission logic here
    final data = User.fromJson(formData);
    Response response = await userProvider.updateOneAndSave(data.id!, data);
    SnackBars snackBar = SnackBars();
    if (response.isSuccess) {
      snackBar.SuccessSnackBar(context, "successfully updated user");
    } else {
      snackBar.FailedSnackBar(context, "failed to update user");
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Edit - ${widget.user.name}",
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
                  ...widget.resource
                      .where((field) => !shouldExcludeField(field))
                      .map((field) => buildField(field)),
                  SizedBox(height: 16.0),
                ],
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
  Widget buildField(Schema field) {
    dynamic initialValue = widget.user.toJson();
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
        if(field.field == null){
          return utils.buildDateField(
              field, formData, context, onSetDate,
              DateTime.parse("2025-01-17"));
        }
        else {
          return utils.buildDateField(
              field, formData, context, onSetDate,
              DateTime.parse(initialValue[field.field]));
        }
      default:
        return SizedBox.shrink();
    }
  }
}
