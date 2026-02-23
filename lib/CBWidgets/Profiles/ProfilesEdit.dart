import 'package:flutter/material.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Schema.dart';
import '../../Utils/Dialogs/SnackBars.dart';
import '../../Utils/PageUtils.dart';
import 'Profile.dart';
import 'ProfilesProvider.dart';
import '../Users/User.dart';
import '../Departments/Department.dart';
import '../Sections/Section.dart';
import '../Roles/Role.dart';
import '../Positions/Position.dart';
import '../Users/User.dart';
import '../Companies/Company.dart';
import '../Branches/Branch.dart';
import '../UserAddresses/UserAddress.dart';
import '../UserPhones/UserPhone.dart';

class ProfilesEdit extends StatefulWidget {
  const ProfilesEdit({
    super.key,
    required this.schema,
    required this.data,
    required this.name,
		this.userId,
		required this.image,
		this.bio,
		required this.department,
		required this.hod,
		this.section,
		required this.hos,
		this.role,
		required this.position,
		this.manager,
		required this.company,
		this.branch,
		this.skills,
		this.address,
		this.phone
  });
  final List<Schema> schema;
  final Profile data;
  final String name;
	final User? userId;
	final String image;
	final String? bio;
	final Department department;
	final bool hod;
	final Section? section;
	final bool hos;
	final Role? role;
	final Position position;
	final User? manager;
	final Company company;
	final Branch? branch;
	final String? skills;
	final UserAddress? address;
	final UserPhone? phone;

  @override
  State<ProfilesEdit> createState() => _ProfilesEditState();
}

class _ProfilesEditState extends State<ProfilesEdit> {
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
    ProfilesProvider provider = ProfilesProvider();
    // Handle form submission logic here
    final data = Profile.fromJson(formData);
    Response response = await provider.updateOneAndSave(data.id!, data);
    SnackBars snackBar = SnackBars();
    if (response.isSuccess) {
      snackBar.SuccessSnackBar(context, "Successfully updated Profiles");
    } else {
      snackBar.FailedSnackBar(context, "Failed to update Profiles");
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