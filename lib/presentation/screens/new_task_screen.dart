import 'package:flutter/material.dart';
import 'package:task_manager/data/model/count_by_status_wrapper.dart';
import 'package:task_manager/data/model/task_list_wrapper.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/screens/add_new_task_screen.dart';
import 'package:task_manager/presentation/utility/app_colour.dart';
import 'package:task_manager/presentation/widget/profile_bar.dart';
import 'package:task_manager/presentation/widget/background_widget.dart';
import 'package:task_manager/presentation/widget/snacbar_message.dart';
import 'package:task_manager/presentation/widget/task_card.dart';
import 'package:task_manager/presentation/widget/task_counter_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  bool _getAllTaskCountByStatusInProgress = false;
  bool _getNewTaskListInProgress = false;
  bool _deletTaskListInProgress = false;
  bool _updateTaskStatusInProgress = false;

  CountByStatusWrapper _countByStatusWrapper = CountByStatusWrapper();
  TaskListWrapper _newTaskListWrapper = TaskListWrapper();

  @override
  void initState() {
_getDataFromApi();
    super.initState();
  }
  void _getDataFromApi() {
    _getAllTaskCountByStatus();
    _getAllNewTaskList();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: BackgroundWidget(
        child: Column(
          children: [
            Visibility(
              visible: _getAllTaskCountByStatusInProgress == false,
                replacement: Padding(
                  padding: EdgeInsets.all(8),
                    child: LinearProgressIndicator()),
                child: taskCounterSection),
            Expanded(
              child: Visibility(
                visible: _getNewTaskListInProgress== false &&
                    _deletTaskListInProgress == false &&
                    _updateTaskStatusInProgress== false,
                replacement: Center(
                  child: CircularProgressIndicator(),
                ),
                child: RefreshIndicator(
                  onRefresh: () async => _getDataFromApi(),
                  child: ListView.builder(
                    itemCount: _newTaskListWrapper.taskList?.length ?? 0,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskItem: _newTaskListWrapper.taskList![index],
                        onDelet: (){
                          _deletTaskById(_newTaskListWrapper.taskList![index].sId!);
                        },
                        onEdit: (){
                          _showUpdateStatusDialog(_newTaskListWrapper.taskList![index].sId!);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddNewTaskScreen()));
        },
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Appcolor.themeColor,
      ),
    );
  }
  Widget get taskCounterSection {
    return SizedBox(
      height: 110,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.separated(
            itemCount: _countByStatusWrapper.listOfTaskByStatusData?.length ?? 0,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context,index){

              return TaskCounterCard(
                title: _countByStatusWrapper.listOfTaskByStatusData![index].sId ?? '',
                amount: _countByStatusWrapper.listOfTaskByStatusData![index].sum ?? 0,
              );
            },
            separatorBuilder: (_,__){
              return SizedBox(width: 8,);
            }
        ),
      ),
    );
  }

  void _showUpdateStatusDialog(String id) {
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Select status'),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text('New'), trailing: Icon(Icons.check),),
            ListTile(title: Text('Completed'), onTap: (){
              _updateTaskByTd(id, 'Completed');
              Navigator.pop(context);
            },),
            ListTile(title: Text('Progress'), onTap: (){
              _updateTaskByTd(id, 'Progress');
              Navigator.pop(context);

            },),
            ListTile(title: Text('Cancelled'),onTap: (){
              _updateTaskByTd(id, 'Cancelled');
              Navigator.pop(context);

            },),
          ],
        ),
      );

    });
  }

  Future<void> _getAllTaskCountByStatus() async{
    _getAllTaskCountByStatusInProgress = true;
    setState(() {});

    final response = await NetworkCaller.getRequest(Urls.taskStatusCount);

    if(response.isSuccess){
      _countByStatusWrapper = CountByStatusWrapper.fromJson(response.responseBody);
      _getAllTaskCountByStatusInProgress = false;
      setState(() {});

    }else{
      _getAllTaskCountByStatusInProgress = false;
      setState(() {});
      if(mounted){
        showSnacbarMessage(context, response.errorMessage ?? 'get task count by status has been failed');
      }
    }

  }

  Future<void> _getAllNewTaskList() async{
    _getNewTaskListInProgress = true;
    setState(() {});
    final response = await NetworkCaller.getRequest(Urls.newTaskList);
    if(response.isSuccess){
      _newTaskListWrapper = TaskListWrapper.fromJson(response.responseBody);
      _getNewTaskListInProgress =false;
      setState(() {});

    }else{
      _getNewTaskListInProgress =false;
      setState(() {});
      if(mounted){
        showSnacbarMessage(context,
            response.errorMessage ?? 'get new task list has been failed');
      }
    }
    }

  Future<void> _deletTaskById(String id) async {
    _deletTaskListInProgress = true;
    setState(() {});
    final response = await NetworkCaller.getRequest(Urls.deletTask(id));
    _deletTaskListInProgress = false;
    if (response.isSuccess) {
      _getDataFromApi();
    } else {
      _deletTaskListInProgress = false;
      setState(() {});
      if (mounted) {
        showSnacbarMessage(context,
            response.errorMessage ?? 'Delet task list has been failed');
      }
    }
  }

  Future<void> _updateTaskByTd(String id, String status) async {
    _updateTaskStatusInProgress = false;
    setState(() {});
    final response =await NetworkCaller.getRequest(Urls.updateTaskStatus(id, status));
    _updateTaskStatusInProgress = false;
    if(response.isSuccess){
      _getDataFromApi();

    }else{
      setState(() {});
      if (mounted) {
        showSnacbarMessage(context,
            response.errorMessage ?? 'Update task status has been failed');
      }
    }
  }
}


