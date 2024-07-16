import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline_demo/view/model.dart';
import 'package:timeline_demo/view/sql_class.dart';
import 'package:timeline_demo/widget/common_textfield.dart';

class AddTaskForm extends StatefulWidget {
  final Function onTaskAdded;

  AddTaskForm({super.key, required this.onTaskAdded});

  @override
  _AddTaskFormState createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _status = 'To Do';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Task task = Task(
        title: _title,
        description: _description,
        status: _status,
        timeSpent: 0,
      );
      await DatabaseHelper.instance.addTask(task);
      // widget.onTaskAdded();
      Navigator.of(Get.context!).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Task'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              onSaved: (value) {
                _title = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              onSaved: (value) {
                _description = value!;
              },
            ),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: InputDecoration(labelText: 'Status'),
              items: ['To Do', 'In Progress', 'Done']
                  .map((status) => DropdownMenuItem(
                value: status,
                child: Text(status),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _status = value!;
                });
              },
              onSaved: (value) {
                _status = value!;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
