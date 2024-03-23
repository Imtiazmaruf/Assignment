import 'package:flutter/material.dart';

class TaskCounterCard extends StatefulWidget {
  const TaskCounterCard({
    super.key, required this.amount, required this.title,
  });

  final int amount;
  final String title;

  @override
  State<TaskCounterCard> createState() => _TaskCounterCardState();
}

class _TaskCounterCardState extends State<TaskCounterCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('${widget.amount}',style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400
            ),),
            Text('${widget.title}',style: TextStyle(
                color: Colors.grey
            ),)
          ],
        ),
      ),
    );
  }
}
