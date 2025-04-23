import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AddTaskForm extends StatelessWidget {
  TextEditingController TitleText = TextEditingController();
  TextEditingController descriptionText = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  AddTaskForm({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Task'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                if (formkey.currentState!.validate()) {
                  print(TitleText.text);
                  print(descriptionText.text);
                  bool success = true;
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Task added successfully")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to add task")),
                    );
                  }
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        body: Form(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      FocusScope.of(context).unfocus();
                    }
                  },
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    controller: TitleText,

                    decoration: const InputDecoration(
                      labelText: "Title",
                      hintText: "Enter task title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      FocusScope.of(context).unfocus();
                    }
                  },
                  child: TextFormField(
                    controller: descriptionText,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      hintText: "Enter task description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addTaskToDB(Map<String, String> taskMap) async {
    final Database db = await openDatabase(
      join(await getDatabasesPath(), 'dojo_db'),
      onCreate:
          (db, version) => db.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY, user_id TEXT, title TEXT, desc TEXT, status TEXT)',
          ),
      version: 1,
    );
    int row = await db.insert('tasks', taskMap);
  }
}
