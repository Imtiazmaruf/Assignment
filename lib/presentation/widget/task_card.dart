import 'package:flutter/material.dart';
import 'package:task_manager/data/model/task_item.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key, required this.taskItem, required this.onDelet, required this.onEdit,
  });

  final TaskItem taskItem;
  final VoidCallback onDelet;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              taskItem.title ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold
            ),),
            Text(taskItem.description?? ''),
            Text('Date ${taskItem.createdDate}'),
            Row(
              children: [
                Chip(label: Text(taskItem.status ?? '')),
                Spacer(),
                IconButton(onPressed: onEdit, icon: Icon(Icons.edit)),
                IconButton(onPressed: onDelet, icon: Icon(Icons.delete)),
              ],
            )
          ],
        ),
      ),
    );
  }
}