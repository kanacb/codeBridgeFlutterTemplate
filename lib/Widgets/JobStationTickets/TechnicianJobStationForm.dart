import 'package:flutter/material.dart';
import '../DocumentsStorage/FileUploadPage.dart';

class TechnicianJobStationCloseForm extends StatefulWidget {
  @override
  _TechnicianJobStationCloseFormState createState() => _TechnicianJobStationCloseFormState();
}

class _TechnicianJobStationCloseFormState extends State<TechnicianJobStationCloseForm> {
  String uploadedFilePath = "";
  final TextEditingController remarksController = TextEditingController();

  void handleFileChange(String filePath) {
    setState(() {
      uploadedFilePath = filePath;
    });
  }

  void openFileUpload() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FileUploadPage(
          table: 'JobStationClose',
          tableId: '12345', // Replace with appropriate ID if available
          onChange: handleFileChange,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Close Job Station'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Attach Files:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: openFileUpload,
              child: Text('Upload File'),
            ),
            if (uploadedFilePath.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Uploaded File: $uploadedFilePath',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            SizedBox(height: 20),
            TextField(
              controller: remarksController,
              decoration: InputDecoration(
                labelText: 'Remarks',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic for closing the job station
                print('Closing job station with file: $uploadedFilePath');
                print('Remarks: ${remarksController.text}');
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class TechnicianJobStationOpenForm extends StatefulWidget {
  @override
  _TechnicianJobStationOpenFormState createState() => _TechnicianJobStationOpenFormState();
}

class _TechnicianJobStationOpenFormState extends State<TechnicianJobStationOpenForm> {
  String uploadedFilePath = "";
  final TextEditingController remarksController = TextEditingController();

  void handleFileChange(String filePath) {
    setState(() {
      uploadedFilePath = filePath;
    });
  }

  void openFileUpload() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FileUploadPage(
          table: 'JobStationOpen',
          tableId: '67890', // Replace with appropriate ID if available
          onChange: handleFileChange,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Open Job Station'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Attach Files:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: openFileUpload,
              child: Text('Upload File'),
            ),
            if (uploadedFilePath.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Uploaded File: $uploadedFilePath',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            SizedBox(height: 20),
            TextField(
              controller: remarksController,
              decoration: InputDecoration(
                labelText: 'Remarks',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic for opening the job station
                print('Opening job station with file: $uploadedFilePath');
                print('Remarks: ${remarksController.text}');
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
