import 'package:flutter/material.dart';
import 'package:flutter_boardview/board_item.dart';
import 'package:flutter_boardview/board_list.dart';
import 'package:flutter_boardview/boardview.dart';
import 'package:flutter_boardview/boardview_controller.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timeline_demo/config/app_colors.dart';
import 'package:timeline_demo/config/text_style.dart';
import 'package:timeline_demo/view/addtask/view/add_task.dart';
import 'package:timeline_demo/view/comment_page.dart';
import 'package:timeline_demo/view/model.dart';
import 'package:timeline_demo/view/sql_class.dart';
import 'package:timeline_demo/view/task_timer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BoardViewController boardViewController = BoardViewController();

  void _refreshBoard() {
    setState(() {});
  }

  Future<void> _updateTaskStatus(int taskId, String newStatus) async {
    await DatabaseHelper.instance.updateTaskStatus(taskId, newStatus);
    _refreshBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primary,
        title: Text(
          'Home',
          style: AppTextStyle.regular600
              .copyWith(fontSize: 18, color: AppColors.whiteColor),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: Get.context!,
            builder: (context) {
              return AddTaskForm(onTaskAdded: _refreshBoard);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<Database?>(
        future: DatabaseHelper.instance.database,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return FutureBuilder<List<List<BoardItem>>>(
                future: _buildLists(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<List<BoardItem>> lists = snapshot.data!;
                      return BoardView(
                        bottomPadding: 20,
                        boardViewController: boardViewController,
                        lists: [
                          BoardList(
                            backgroundColor: AppColors.transparentColor,
                            onTapList: (v) {
                              print("[[]]]");
                            },
                            onDropList: (c, v) {
                              print("---=--=$c $v");
                            },
                            items: lists[0],
                            header: [Container(
                                alignment: Alignment.center,
                                // color: AppColors.purpleLight,
                                height: 30,
                                child: const Text('To Do'))],
                          ),
                          BoardList(
                            backgroundColor: AppColors.transparentColor,
                            items: lists[1],
                            header: [Container(
                                alignment: Alignment.center,
                                // color: AppColors.purpleLight,
                                height: 30,
                                child: const Text('In Progress'))],
                          ),
                          BoardList(
                            backgroundColor: AppColors.transparentColor,
                            items: lists[2],
                            header: [Container(
                              alignment: Alignment.center,
                              // color: AppColors.purpleLight,
                              height: 30,
                                child: const Text('Done'))],
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: Text('No tasks found'));
                    }
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading tasks'));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            } else {
              return const Center(child: Text('Error initializing database'));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<List<List<BoardItem>>> _buildLists() async {
    List<BoardItem> toDoItems = await _buildTasks('To Do');
    List<BoardItem> inProgressItems = await _buildTasks('In Progress');
    List<BoardItem> doneItems = await _buildTasks('Done');
    return [toDoItems, inProgressItems, doneItems];
  }

  Future<List<BoardItem>> _buildTasks(String status) async {
    List<Task> tasks = await DatabaseHelper.instance.getTasksByStatus(status);

    return tasks.map((task) {
      return BoardItem(
        item: Padding(
          padding:
              const EdgeInsets.only(top: 16),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TaskCommentsPage(taskId: task.id!, taskTitle: task.title),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(8),
              color: AppColors.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title),
                  SizedBox(
                    height: 8,
                  ),
                  TaskTimer(taskId: task.id!),
                  // TaskComments(taskId: task.id!),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}
