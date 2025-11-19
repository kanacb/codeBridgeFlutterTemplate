import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog(
      {super.key,
      required this.id,
      required this.title,
      required this.content,
      required this.pos,
      required this.neg,
      required this.answer});
  final String id;
  final String title;
  final String content;
  final String pos;
  final String neg;
  final Function answer;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(title),
        content: Text(content + id),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              answer(id, false);
              Navigator.pop(context, neg);
            },
            child: Text(neg),
          ),
          TextButton(
            onPressed: () {
              answer(id, true);
              Navigator.pop(context, pos);
            },
            child: Text(pos),
          ),
        ]);
  }
}
