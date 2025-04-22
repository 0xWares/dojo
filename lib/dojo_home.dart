import 'package:dojo/add_task_form.dart';
import 'package:dojo/task.dart';
import 'package:dojo/task_detail_page.dart';
import 'package:flutter/material.dart';

class DojoHome extends StatefulWidget {
  const DojoHome({super.key});

  @override
  State<DojoHome> createState() => _DojoHomeState();
}

class _DojoHomeState extends State<DojoHome> {
  List listDummyTasks = Task.getDummyTask();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dojo Home')),
      body: ListView.separated(
        itemCount: listDummyTasks.length,
        itemBuilder: (context, index) {
          Task task = listDummyTasks[index];
          return ListTile(
            onTap: () {
              MaterialPageRoute route = MaterialPageRoute(
                builder:
                    (context) => TaskDetailPage(task, upadateListItemByIndex),
              );
              Navigator.push(context, route);
            },
            autofocus: true,
            title: Text(
              task.title,
              style: TextStyle(
                decoration:
                    (task.status == "complete")
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
              ),
            ),
            subtitle: Text(task.description),
            trailing: Checkbox(
              value: task.status == "complete",
              onChanged: (bool? value) {
                if (value == true) {
                  task.status = "complete";
                } else {
                  task.status = "incomplete";
                }
                upadateListItemByIndex(task);
              },
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Colors.grey,
            height: 1.0,
            thickness: 1.0,
            indent: 16.0,
            endIndent: 16.0,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskForm()),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  upadateListItemByIndex(Task task) {
    int index = listDummyTasks.indexWhere(
      (element) => element.taskid == task.taskid,
    );

    listDummyTasks[index] = task;
    setState(() {});
  }
}
