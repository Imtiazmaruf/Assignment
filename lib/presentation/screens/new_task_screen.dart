import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/model/task_count_by_status_data.dart';
import 'package:task_manager/presentation/controllers/add_new_task_screen_controller.dart';
import 'package:task_manager/presentation/controllers/count_task_by_status_controller.dart';
import 'package:task_manager/presentation/controllers/new_task_controller.dart';
import 'package:task_manager/presentation/screens/add_new_task_screen.dart';
import 'package:task_manager/presentation/utility/app_colour.dart';
import 'package:task_manager/presentation/widget/empty_list_widget.dart';
import 'package:task_manager/presentation/widget/profile_bar.dart';
import 'package:task_manager/presentation/widget/background_widget.dart';
import 'package:task_manager/presentation/widget/task_card.dart';
import 'package:task_manager/presentation/widget/task_counter_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  // bool _getNewTaskListInProgress = false;
  // TaskListWrapper _newTaskListWrapper = TaskListWrapper();

  @override
  void initState() {
    _getDataFromApi();
    super.initState();
  }

  void _getDataFromApi() {
    Get.find<CountTaskByStatusController>().getCountByTaskStatus();
    Get.find<NewTaskController>().getNewTask();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: BackgroundWidget(
        child: Column(
          children: [
            GetBuilder<CountTaskByStatusController>(
              builder: (countTaskByStatusController) {
                return Visibility(
                    visible: countTaskByStatusController.inProgress == false,
                    replacement: Padding(
                        padding: EdgeInsets.all(8),
                        child: LinearProgressIndicator()),
                    child: taskCounterSection(
                        countTaskByStatusController.countByStatusWrapper.listOfTaskByStatusData ?? []), );

              }),
            Expanded(
              child: GetBuilder<NewTaskController>(
                builder: (newTaskController) {
                  return Visibility(
                    visible: newTaskController.inProgress == false,
                    replacement: Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: RefreshIndicator(
                      onRefresh: () async => _getDataFromApi(),
                      child: Visibility(
                        visible: newTaskController.newTaskListWrapper.taskList?.isNotEmpty ?? false,
                        replacement: EmptyListWidget(),

                        child: ListView.builder(
                          itemCount: newTaskController.newTaskListWrapper.taskList?.length ?? 0,
                          itemBuilder: (context, index) {
                            return TaskCard(
                              taskItem: newTaskController.newTaskListWrapper.taskList![index],
                              refreshList: () {
                                _getDataFromApi();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNewTaskScreen(),),);
          if(result != null && result == true){
            _getDataFromApi();
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Appcolor.themeColor,
      ),
    );
  }

  Widget  taskCounterSection(List<TaskCountByStatusData> listOfTaskByStatusData) {
    return SizedBox(
      height: 110,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.separated(
            itemCount:
              listOfTaskByStatusData.length ?? 0,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return TaskCounterCard(
                title:
                   listOfTaskByStatusData![index].sId ??
                        '',
                amount:
                   listOfTaskByStatusData![index].sum ??
                        0,
              );
            },
            separatorBuilder: (_,__) {
              return SizedBox(
                width: 8,
              );
            }),
      ),
    );
  }

  // Future<void> _getAllTaskCountByStatus() async {
  //   _getAllTaskCountByStatusInProgress = true;
  //   setState(() {});
  //
  //   final response = await NetworkCaller.getRequest(Urls.taskStatusCount);
  //
  //   if (response.isSuccess) {
  //     _countByStatusWrapper =
  //         CountByStatusWrapper.fromJson(response.responseBody);
  //     _getAllTaskCountByStatusInProgress = false;
  //     setState(() {});
  //   } else {
  //     _getAllTaskCountByStatusInProgress = false;
  //     setState(() {});
  //     if (mounted) {
  //       showSnacbarMessage(
  //           context,
  //           response.errorMessage ??
  //               'get task count by status has been failed');
  //     }
  //   }
  // }

  // Future<void> _getAllNewTaskList() async {
  //   _getNewTaskListInProgress = true;
  //   setState(() {});
  //   final response = await NetworkCaller.getRequest(Urls.newTaskList);
  //   if (response.isSuccess) {
  //     _newTaskListWrapper = TaskListWrapper.fromJson(response.responseBody);
  //     _getNewTaskListInProgress = false;
  //     setState(() {});
  //   } else {
  //     _getNewTaskListInProgress = false;
  //     setState(() {});
  //     if (mounted) {
  //       showSnacbarMessage(context,
  //           response.errorMessage ?? 'get new task list has been failed');
  //     }
  //   }
  // }
}

