import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentDetailPage extends StatefulWidget {
  const CommentDetailPage({super.key, required this.id});
  final String id;

  @override
  State<CommentDetailPage> createState() => _CommentDetailPageState();
}

class _CommentDetailPageState extends State<CommentDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
