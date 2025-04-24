import 'package:flutter/material.dart';
import 'package:dojo/database/local/db_helper.dart';
import 'package:dojo/task_detail_page.dart';

class DojoHome extends StatefulWidget {
  const DojoHome({super.key});

  @override
  State<DojoHome> createState() => _DojoHomeState();
}

class _DojoHomeState extends State<DojoHome> {
  late Future<List<Map<String, dynamic>>> _tasksFuture;
  final DbHelper _dbHelper = DbHelper.getInstance;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dojo Home')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                onTap: () => _navigateToTaskDetail(context, task),
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
                trailing: Checkbox(
                  value: task[DbHelper.noteStatus] == 1,
                  onChanged: (value) => _updateTaskStatus(task, value),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToTaskDetail(BuildContext context, Map<String, dynamic> task) {
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

  void _showAddTaskBottomSheet(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
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
                        if (titleController.text.isNotEmpty) {
                          await _dbHelper.addNote(
                            title: titleController.text,
                            description: descriptionController.text,
                          );
                          _refreshTasks();
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Save'),
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
}
