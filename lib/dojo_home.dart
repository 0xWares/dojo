import 'package:flutter/material.dart';
import 'package:dojo/database/local/db_helper.dart';
import 'package:dojo/task_detail_page.dart';
import 'package:iconly/iconly.dart';

class DojoHome extends StatefulWidget {
  const DojoHome({super.key});

  @override
  State<DojoHome> createState() => _DojoHomeState();
}

class _DojoHomeState extends State<DojoHome> {
  late bool warn;
  late Future<List<Map<String, dynamic>>> _tasksFuture;
  final DbHelper _dbHelper = DbHelper.getInstance;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  void _refreshTasks() {
    setState(() {
      _tasksFuture = _dbHelper.getAllNotes();
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateTaskStatus(Map<String, dynamic> task, bool? value) async {
    if (value == null) return;

    await _dbHelper.getDB().then((db) async {
      await db.update(
        DbHelper.tableName,
        {DbHelper.noteStatus: value ? 1 : 0},
        where: '${DbHelper.serialNumber} = ?',
        whereArgs: [task[DbHelper.serialNumber]],
      );
      _refreshTasks();
    });
  }

  void _showAddTaskBottomSheet(
    BuildContext context,
    bool isEdit, {
    int sl_no = 0,
  }) {
    if (!isEdit) {
      titleController.clear();
      descriptionController.clear();
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                isEdit ? 'Edit Task' : 'Add Task',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              Visibility(
                child: Text(
                  "The title can not be empty!",
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (titleController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Title cannot be empty'),
                            ),
                          );
                          return;
                        }

                        if (isEdit) {
                          await _dbHelper.updateTask(
                            mTitle: titleController.text,
                            mDescription: descriptionController.text,
                            mSerialNumber: sl_no,
                          );
                        } else {
                          await _dbHelper.addNote(
                            title: titleController.text,
                            description: descriptionController.text,
                          );
                        }
                        _refreshTasks();
                        Navigator.pop(context);
                      },
                      child: Text(isEdit ? 'Update' : 'Add'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dojo Home')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No tasks available',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final task = snapshot.data![index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => TaskDetailPage(
                            title: task[DbHelper.noteTitle],
                            description: task[DbHelper.noteDescription],
                            status: task[DbHelper.noteStatus] == 1,
                          ),
                    ),
                  );
                },
                title: Text(
                  task[DbHelper.noteTitle],
                  style: TextStyle(
                    decoration:
                        task[DbHelper.noteStatus] == 1
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                  ),
                ),

                subtitle: Text(task[DbHelper.noteDescription]),
                trailing: SizedBox(
                  width: 160,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: task[DbHelper.noteStatus] == 1,
                        onChanged: (value) => _updateTaskStatus(task, value),
                      ),
                      IconButton(
                        onPressed: () {
                          titleController.text = task[DbHelper.noteTitle];
                          descriptionController.text =
                              task[DbHelper.noteDescription];
                          _showAddTaskBottomSheet(
                            context,
                            true,
                            sl_no: task[DbHelper.serialNumber],
                          );
                        },
                        icon: const Icon(IconlyBroken.edit, color: Colors.blue),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      IconButton(
                        onPressed: () async {
                          await _dbHelper.deleteTask(
                            serialNumber: task[DbHelper.serialNumber],
                          );
                          _refreshTasks();
                        },
                        icon: const Icon(
                          IconlyBroken.delete,
                          color: Colors.redAccent,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskBottomSheet(context, false);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
