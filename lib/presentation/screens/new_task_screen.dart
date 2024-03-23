import 'package:flutter/material.dart';
import 'package:task_manager/data/model/count_by_status_wrapper.dart';
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
  CountByStatusWrapper _countByStatusWrapper = CountByStatusWrapper();

  @override
  void initState() {
    _getAllTaskCountByStatus();
    super.initState();
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
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return TaskCard();
                },
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
}


