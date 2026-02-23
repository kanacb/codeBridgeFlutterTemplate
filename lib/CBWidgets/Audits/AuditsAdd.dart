import 'package:flutter/material.dart';
  import '../../Utils/Services/Response.dart';
  import '../../Utils/Services/Schema.dart';
  import '../../Utils/Dialogs/SnackBars.dart';
  import '../../Utils/PageUtils.dart';
  import 'Audit.dart';
  import 'AuditsProvider.dart';
    
class AuditsAdd extends StatefulWidget {
  const AuditsAdd({super.key, required this.resource});
  final List<Schema> resource;

  @override
  State<AuditsAdd> createState() => _AuditsAddState();
}

class _AuditsAddState extends State<AuditsAdd> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};
  final Utils utils = Utils();

  @override
  void initState() {
    super.initState();
    for (var field in widget.resource) {
      formData[field.field] = field.type == 'bool' ? false : null;
    }
  }

  void saveForm() async {
    AuditsProvider provider = AuditsProvider();
    final data = Audit.fromJson(formData);
    Response response = await provider.createOneAndSave(data);

    SnackBars snackBar = SnackBars();
    if (response.isSuccess) {
      snackBar.SuccessSnackBar(context, "Successfully added Audits");
    } else {
      snackBar.FailedSnackBar(context, "Failed to add Audits");
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
          "Add Audit",
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
        void onChange(value) {
          setState(() {
            formData[field.field] = value;
          });
        }
        if (field.field.toLowerCase().contains("email")) {
          return utils.buildEmailField(field, onChange, "");
        } else if (field.description!.toLowerCase().contains("isArray")) {
          return Column( children: [...utils.buildCheckboxArray(field, formData, onChange, false)]);
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