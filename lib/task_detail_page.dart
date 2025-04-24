import 'package:flutter/material.dart';

class TaskDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final bool status;

  const TaskDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'Status:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Chip(
                  label: Text(status ? 'Completed' : 'Pending'),
                  backgroundColor:
                      status ? Colors.green[100] : Colors.orange[100],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
