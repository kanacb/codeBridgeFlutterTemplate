import 'package:flutter/material.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Schema.dart';
import '../../Utils/Dialogs/SnackBars.dart';
import '../../Utils/PageUtils.dart';
import 'UserInvite.dart';
import 'UserInvitesProvider.dart';
import '../Positions/Position.dart';
import '../Roles/Role.dart';
import '../Companies/Company.dart';
import '../Branches/Branch.dart';
import '../Departments/Department.dart';
import '../Sections/Section.dart';

class UserInvitesEdit extends StatefulWidget {
  const UserInvitesEdit({
    super.key,
    required this.schema,
    required this.data,
    required this.emailToInvite,
		this.status,
		this.position,
		this.role,
		this.company,
		this.branch,
		this.department,
		this.section,
		this.code,
		this.sendMailCounter
  });
  final List<Schema> schema;
  final UserInvite data;
  final String emailToInvite;
	final bool? status;
	final Position? position;
	final Role? role;
	final Company? company;
	final Branch? branch;
	final Department? department;
	final Section? section;
	final int? code;
	final int? sendMailCounter;

  @override
  State<UserInvitesEdit> createState() => _UserInvitesEditState();
}

class _UserInvitesEditState extends State<UserInvitesEdit> {
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
    UserInvitesProvider provider = UserInvitesProvider();
    // Handle form submission logic here
    final data = UserInvite.fromJson(formData);
    Response response = await provider.updateOneAndSave(data.id!, data);
    SnackBars snackBar = SnackBars();
    if (response.isSuccess) {
      snackBar.SuccessSnackBar(context, "Successfully updated User Invites");
    } else {
      snackBar.FailedSnackBar(context, "Failed to update User Invites");
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