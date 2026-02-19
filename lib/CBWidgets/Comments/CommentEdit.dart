import 'package:flutter/material.dart';

import '../../Utils/Services/Response.dart';
import '../../Utils/Validators.dart';
import 'CommentProvider.dart';
import 'Comment.dart';

class CommentEdit extends StatefulWidget {
  const CommentEdit({super.key, required this.id});
  final String id;

  @override
  State<CommentEdit> createState() => _CommentEditState();
}

class _CommentEditState extends State<CommentEdit> {
  late Comment item;

  @override
  void initState() {
    super.initState();
    _getRecord();
  }

  void _getRecord() async {
    final Response response =
        await CommentProvider().fetchOneAndSave(widget.id);
    if (response.error == null) {
      item = response?.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    late String comment = "";
    late LabeledGlobalKey<FormState> key =
        LabeledGlobalKey<FormState>("LoginForm");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Form(
        key: key,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 20.0, bottom: 2.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Comment",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: item.text,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (Validators.isStringNotEmpty(value)) {
                        return null;
                      }
                      return "Please enter comment";
                    },
                    onSaved: (value) {
                      comment = value!;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your comment',
                      hintStyle: const TextStyle(color: Colors.grey),
                      fillColor: Colors.white60,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Is Resolved",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          onPressed: () async {
                            if (key.currentState!.validate()) {
                              key.currentState!.save();
                            }
                            item.text = comment;
                            final response = await CommentProvider()
                                .updateOneAndSave(widget.id, item);
                            if (response.error == null) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Saved comment"),
                                    elevation: 2,
                                    duration: const Duration(seconds: 3),
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(5),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Failed to save comment"),
                                    elevation: 2,
                                    duration: const Duration(seconds: 3),
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(5),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text(
                            'Send',
                            style:
                                TextStyle(fontSize: 25.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
