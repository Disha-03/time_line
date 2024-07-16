import 'package:flutter/material.dart';
import 'package:timeline_demo/view/model.dart';
import 'package:timeline_demo/view/sql_class.dart';

import '../main.dart';

class TaskComments extends StatefulWidget {
  final int taskId;

  TaskComments({super.key, required this.taskId});

  @override
  _TaskCommentsState createState() => _TaskCommentsState();
}

class _TaskCommentsState extends State<TaskComments> {
  final TextEditingController _commentController = TextEditingController();

  Future<List<Comment>> _fetchComments() async {
    return await DatabaseHelper.instance.getComments(widget.taskId);
  }

  void _addComment() async {
    if (_commentController.text.isNotEmpty) {
      Comment comment = Comment(
        taskId: widget.taskId,
        text: _commentController.text,
        timestamp: DateTime.now(),
      );
      await DatabaseHelper.instance.addComment(widget.taskId, comment);
      _commentController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Comments:'),
        FutureBuilder<List<Comment>>(
          future: _fetchComments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data!
                      .map((comment) => ListTile(
                    title: Text(comment.text),
                    subtitle: Text(comment.timestamp.toString()),
                  ))
                      .toList(),
                );
              } else {
                return Text('No comments yet.');
              }
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        TextField(
          controller: _commentController,
          decoration: InputDecoration(labelText: 'Add a comment'),
        ),
        ElevatedButton(
          onPressed: _addComment,
          child: Text('Add Comment'),
        ),
      ],
    );
  }
}
