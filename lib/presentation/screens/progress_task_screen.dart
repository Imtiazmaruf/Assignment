import 'package:flutter/material.dart';
import 'package:task_manager/presentation/utility/app_colour.dart';
import 'package:task_manager/presentation/widget/profile_bar.dart';
import 'package:task_manager/presentation/widget/background_widget.dart';
import 'package:task_manager/presentation/widget/task_card.dart';
import 'package:task_manager/presentation/widget/task_counter_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: BackgroundWidget(
        child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                //return TaskCard();
              },
            ),


      ),
    );
  }
}

