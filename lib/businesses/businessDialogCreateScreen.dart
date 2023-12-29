import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../users/userModel.dart';
import '../validators.dart';
import 'businessesScreen.dart';

class BusinessDialogCreate extends StatefulWidget {
  BusinessDialogCreate({super.key, required this.user});
  final User user;
  late Map<String, dynamic> data;

  @override
  State<BusinessDialogCreate> createState() => _BusinessDialogCreateState();
}

class _BusinessDialogCreateState extends State<BusinessDialogCreate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  const Text("create Business"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return  const BusinessesScreen(scrollTo: 0);
                    },
                  ),
                );
              },
              icon: const Icon(Icons.save),
              color: Colors.orange,
              iconSize: 20,
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
              key: widget.key,
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 60.0, bottom: 20.0, left: 20.0, right: 20.0),
                  child: Wrap(children: [
                    TextFormField(
                      keyboardType: TextInputType.name,

                      validator: (value) {
                        if (Validators.isStringNotEmpty(value, true)) {
                          return null;
                        }
                        return "Please enter a value";
                      },
                      onSaved: (value) {
                        widget.data['name'] = value!;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Name',
                        labelText: 'Name',
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,

                      validator: (value) {
                        if (Validators.isStringNotEmpty(value, true)) {
                          return null;
                        }
                        return "Please enter a value";
                      },
                      onSaved: (value) {
                        widget.data["reg"] = value!;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Registration',
                        labelText: 'Registration',
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,

                      validator: (value) {
                        if (Validators.isStringNotEmpty(value, true)) {
                          return null;
                        }
                        return "Please enter a value";
                      },
                      onSaved: (value) {
                        widget.data['phone'] = value!;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Phone',
                        labelText: 'Phone',
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,

                      validator: (value) {
                        if (Validators.isStringNotEmpty(value, true)) {
                          return null;
                        }
                        return "Please enter a value";
                      },
                      onSaved: (value) {
                        widget.data['mobile'] = value!;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Mobile',
                        labelText: 'Mobile',
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,

                      validator: (value) {
                        if (Validators.isStringNotEmpty(value, true)) {
                          return null;
                        }
                        return "Please enter a value";
                      },
                      onSaved: (value) {
                        widget.data['postalcode'] = value!;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Postal Code',
                        labelText: 'Postal Code',
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,

                      validator: (value) {
                        if (Validators.isStringNotEmpty(value, true)) {
                          return null;
                        }
                        return "Please enter a value";
                      },
                      onSaved: (value) {
                        widget.data['city'] = value!;
                      },
                      decoration: const InputDecoration(
                        hintText: 'City',
                        labelText: 'City',
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,

                      validator: (value) {
                        if (Validators.isStringNotEmpty(value, true)) {
                          return null;
                        }
                        return "Please enter a value";
                      },
                      onSaved: (value) {
                        widget.data['state'] = value!;
                      },
                      decoration: const InputDecoration(
                        hintText: 'State',
                        labelText: 'State',
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,

                      validator: (value) {
                        if (Validators.isStringNotEmpty(value, true)) {
                          return null;
                        }
                        return "Please enter a value";
                      },
                      onSaved: (value) {
                        widget.data['country'] = value!;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Country',
                        labelText: 'Country',
                      ),
                    ),
                    Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            backgroundColor: Colors.orange,
                          ),
                          onPressed: () {

                          },
                          child: const Text("Create", style: TextStyle(color: Colors.white)),
                        ))
                  ]))),
        ));
  }
}
