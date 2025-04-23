import 'package:dojo/task.dart';
import 'package:flutter/material.dart';

class EditTaskForm extends StatelessWidget {
  TextEditingController TitleText = TextEditingController();
  TextEditingController descriptionText = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  Task task;

  EditTaskForm(this.task, {super.key}) {
    TitleText.text = task.title;
    descriptionText.text = task.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Check if currentState is not null before validating
              if (formkey.currentState != null &&
                  formkey.currentState!.validate()) {
                print(TitleText.text);
                print(descriptionText.text);
                bool success = true;
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Task updated successfully")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to update task")),
                  );
                }
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Form(
        // Assign the formkey here
        key: formkey,
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
    );
  }
}
