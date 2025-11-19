import 'package:flutter/material.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Schema.dart';
import '../../Utils/Dialogs/SnackBars.dart';
import '../../Utils/PageUtils.dart';
import 'ExternalChecklistsProvider.dart';
import 'ExternalChecklists.dart';

class ExternalChecklistsAdd extends StatefulWidget {
  const ExternalChecklistsAdd({super.key, required this.resource});
  final List<Schema> resource;

  @override
  State<ExternalChecklistsAdd> createState() => _ExternalChecklistsAddState();
}

class _ExternalChecklistsAddState extends State<ExternalChecklistsAdd> {
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
    ExternalChecklistsProvider provider = ExternalChecklistsProvider();
    final data = ExternalChecklists.fromJson(formData);
    Response response = await provider.createOneAndSave(data);

    SnackBars snackBar = SnackBars();
    if (response.isSuccess) {
      snackBar.SuccessSnackBar(context, "Successfully added external checklist");
    } else {
      snackBar.FailedSnackBar(context, "Failed to add external checklist");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add External Checklist")),
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

  Widget buildField(field) {
    return utils.buildField(field, formData, context, setState);
  }
}
