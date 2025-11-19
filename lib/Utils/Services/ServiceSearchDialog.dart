import 'package:flutter/material.dart';

class ServiceSearchDialog extends StatelessWidget {
  const ServiceSearchDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: TextField(
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            suffixIcon: const Icon(Icons.close),
                            hintText: "global search text",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(30))))),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                "Recent Search",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const ListTile(
              title: Text("Mani "),
              leading: Icon(Icons.search),
              trailing: Icon(Icons.close),
            )
          ],
        ),
      )),
    );
  }
}
