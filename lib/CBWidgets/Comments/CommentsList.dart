import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CommentDetailPage.dart';
import 'CommentProvider.dart';

class CommentList extends StatefulWidget {
  const CommentList({super.key});

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    await CommentProvider().fetchAllAndSave();
  }

  @override
  Widget build(BuildContext context) {
    final commentProvider = Provider.of<CommentProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: ListView.builder(
        itemCount: commentProvider.comments.length,
        itemBuilder: (context, index) {
          final comment = commentProvider.comments[index];
          return ListTile(
            title: Text(comment.recordId!),
            subtitle: Text(comment.text),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommentDetailPage( id: comment.id!),
              ),
            ),
          );
        },
      ),
    );
  }
}
