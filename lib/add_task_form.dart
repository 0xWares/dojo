import 'package:flutter/material.dart';

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
}
