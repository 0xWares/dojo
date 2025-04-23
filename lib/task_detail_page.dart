import 'package:dojo/edit_task_form.dart';
import 'package:dojo/task.dart';
import 'package:flutter/material.dart';

class TaskDetailPage extends StatefulWidget {
  late Task task;
  Function(Task task) updateListItem;
  TaskDetailPage(this.task, this.updateListItem);

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  bool _deleted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditTaskForm(widget.task),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (builder) {
                  return AlertDialog(
                    title: Text('Delete Task'),
                    content: Text('Are you sure you want to delete this task?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _deleteTask();
                          Navigator.of(context).pop();
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              if (widget.task.status == 'incomplete') {
                setState(() {
                  widget.task.status = 'complete';
                });
              } else {
                setState(() {
                  widget.task.status = 'incomplete';
                });
              }
              widget.updateListItem(widget.task);
            },
          ),
        ],
      ),
      body:
          (_deleted)
              ? Center(child: Text('Task Deleted'))
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Status: ',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                          TextSpan(
                            text: widget.task.status,
                            style:
                                widget.task.status == 'incomplete'
                                    ? TextStyle(fontSize: 12, color: Colors.red)
                                    : TextStyle(
                                      fontSize: 12,
                                      color: Colors.green,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.task.description,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
    );
  }

  _deleteTask() {
    setState(() {
      _deleted = true;
    });
  }
}
