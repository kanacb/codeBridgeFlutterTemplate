import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../Utils/Services/Response.dart';
import '../../Utils/Services/Schema.dart';
import '../../Utils/Dialogs/SnackBars.dart';
import '../../Utils/PageUtils.dart';
import 'AtlasChecksProvider.dart';
import 'AtlasChecks.dart';

class AtlasChecksAdd extends StatefulWidget {
  const AtlasChecksAdd({super.key, required this.resource});
  final List<Schema> resource;

  @override
  State<AtlasChecksAdd> createState() => _AtlasChecksAddState();
}

class _AtlasChecksAddState extends State<AtlasChecksAdd> {
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
    print('Form Data: $formData');
    AtlasChecksProvider provider = AtlasChecksProvider();
    final data = AtlasChecks.fromJson(formData);
    Response response = await provider.createOneAndSave(data);

    SnackBars snackBar = SnackBars();
    if (response.isSuccess) {
      snackBar.SuccessSnackBar(context, "Successfully added Atlas check");
    } else {
      snackBar.FailedSnackBar(context, "Failed to add Atlas check");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Atlas Check")),
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
