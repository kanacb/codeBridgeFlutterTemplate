  import 'package:flutter/material.dart';

class SupervisorCloseForm extends StatefulWidget {
  @override
  _SupervisorCloseFormState createState() => _SupervisorCloseFormState();
}

class _SupervisorCloseFormState extends State<SupervisorCloseForm> {
  String uploadedFilePath = "";
  String? selectedAction;
  final TextEditingController commentsController = TextEditingController();

  final List<String> actions = ["Close", "Abort", "Reopen"];

  void handleFileChange(String filePath) {
    setState(() {
      uploadedFilePath = filePath;
    });
  }

  void handleSubmit() {
    if (selectedAction == null || uploadedFilePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an action and upload a file.')),
      );
      return;
    }
    print('Supervisor Action: $selectedAction');
    print('File Uploaded: $uploadedFilePath');
    print('Comments: ${commentsController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supervisor Close Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Action:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedAction,
              items: actions.map((action) {
                return DropdownMenuItem(
                  value: action,
                  child: Text(action),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedAction = value;
                });
              },
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            Text('Attach Files:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SizedBox(height: 20),
            TextField(
              controller: commentsController,
              decoration: InputDecoration(
                labelText: 'Comments',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleSubmit,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
