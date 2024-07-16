import 'package:flutter/material.dart';
import 'package:timeline_demo/config/app_colors.dart';
import 'package:timeline_demo/config/text_style.dart';
import 'package:timeline_demo/view/task_comment.dart';

class TaskCommentsPage extends StatelessWidget {
  final int taskId;
  final String taskTitle;

  const TaskCommentsPage({required this.taskId, required this.taskTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primary,
        title:  Text('Task Details',style: AppTextStyle.regular600.copyWith(
          fontSize: 18,
          color: AppColors.whiteColor
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Text(taskTitle,style: AppTextStyle.regular700.copyWith(
                color: AppColors.purpleLight,
                fontSize: 20
              ),),
              SizedBox(height: 20,),
              TaskComments(taskId: taskId),
            ],
          ),
        ),
      ),
    );
  }
}
