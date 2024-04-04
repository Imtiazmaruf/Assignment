import 'package:flutter/material.dart';
import 'package:task_manager/data/model/task_list_wrapper.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/widget/empty_list_widget.dart';
import 'package:task_manager/presentation/widget/profile_bar.dart';
import 'package:task_manager/presentation/widget/background_widget.dart';
import 'package:task_manager/presentation/widget/snacbar_message.dart';
import 'package:task_manager/presentation/widget/task_card.dart';

class CompleteTaskScreen extends StatefulWidget {
  const CompleteTaskScreen({super.key});

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {
  bool _getCompletedTaskListInProgress = true;
  TaskListWrapper _completedTaskListWrapper = TaskListWrapper();

  @override
  void initState() {
    _getAllCompletedTaskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: BackgroundWidget(
        child: Visibility(
          visible: _getCompletedTaskListInProgress == false,
          replacement: Center(
            child: CircularProgressIndicator(),
          ),
          child: RefreshIndicator(
            onRefresh: () async{
              _getAllCompletedTaskList();
            },
            child: Visibility(
              visible: _completedTaskListWrapper.taskList?.isNotEmpty ?? false,
              replacement: EmptyListWidget(),
              child: ListView.builder(
                    itemCount: _completedTaskListWrapper.taskList?.length ?? 0,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskItem : _completedTaskListWrapper.taskList![index],
                        refreshList: (){
                          _getAllCompletedTaskList();
                        }
                      );
                    },
                  ),
            ),
          ),
        ),


      ),
    );
  }
  Future<void> _getAllCompletedTaskList() async {
    _getCompletedTaskListInProgress = true;
    setState(() {});
    final response = await NetworkCaller.getRequest(Urls.completedTaskList);
    if (response.isSuccess) {
      _completedTaskListWrapper = TaskListWrapper.fromJson(response.responseBody);
      _getCompletedTaskListInProgress = false;
      setState(() {});
    } else {
      _getCompletedTaskListInProgress = false;
      setState(() {});
      if (mounted) {
        showSnacbarMessage(context,
            response.errorMessage ?? 'get completed task list has been failed');
      }
    }
  }

}

