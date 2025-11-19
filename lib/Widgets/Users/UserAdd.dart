import 'package:flutter/material.dart';

import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Schema.dart';
import '../../Utils/Dialogs/SnackBars.dart';
import '../../Utils/PageUtils.dart';
import 'User.dart';
import 'UserProvider.dart';

class UserAdd extends StatefulWidget {
  const UserAdd({super.key, required this.resource});
  final List<Schema> resource;

  @override
  State<UserAdd> createState() => _UserAddState();
}

class _UserAddState extends State<UserAdd> {
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
    UserProvider userProvider = UserProvider();
    // Handle form submission logic here
    final data = User.fromJson(formData);
    Response response = await userProvider.createOneAndSave(data);
    SnackBars snackBar = SnackBars();
    if (response.isSuccess) {
      snackBar.SuccessSnackBar(context, "successfully created user");
    } else {
      snackBar.FailedSnackBar(context, "failed to create user");
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
    Utils utils = Utils();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Add new user",
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
                      .map((field) => buildField(field))
                      .toList(),
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
    switch (field.type?.toLowerCase()) {
      case 'string':
        void onChanged(value) {
          setState(() {
            formData[field.field] = value;
          });
        }
        if (field.field.toLowerCase().contains("email")) {
          return utils.buildEmailField(field, onChanged, "");
        } else {
          return utils.buildTextField(field, onChanged, "");
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
