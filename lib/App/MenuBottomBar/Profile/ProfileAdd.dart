import 'package:flutter/material.dart';
import '../../../Utils/Dialogs/SnackBars.dart';
import '../../../Utils/PageUtils.dart';
import '../../../Utils/Services/Response.dart';
import '../../../Utils/Services/Schema.dart';
import 'Profile.dart';
import 'ProfileProvider.dart';

class ProfileAdd extends StatefulWidget {
  const ProfileAdd({super.key, required this.resource});
  final List<Schema> resource;

  @override
  State<ProfileAdd> createState() => _ProfileAddState();
}

class _ProfileAddState extends State<ProfileAdd> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};
  Utils utils = Utils();

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
    ProfileProvider profileProvider = ProfileProvider();
    // Handle form submission logic here
    final data = Profile.fromJson(formData);
    Response response = await profileProvider.createOneAndSave(data);
    SnackBars snackBar = SnackBars();
    if (response.isSuccess) {
      snackBar.SuccessSnackBar(context, "Successfully created profile");
    } else {
      snackBar.FailedSnackBar(context, "Failed to create profile");
    }
  }

  bool shouldExcludeField(Schema field) {
    final excludedFields = [
      '_id',
      'createdAt',
      'updatedAt'
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
        title: const Text(
          "Add new profile",
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveForm,
        child: const Icon(Icons.save),
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
        return utils.buildTextField(field, onChanged, "");
      case 'boolean':
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
        return const SizedBox.shrink();
    }
  }
}
