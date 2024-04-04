import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/controllers/count_task_by_status_controller.dart';
import 'package:task_manager/presentation/controllers/new_task_controller.dart';
import 'package:task_manager/presentation/widget/snacbar_message.dart';

class AddNewTaskScreenController extends GetxController{

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool _inProgress = false;

  bool get inProgress => _inProgress;

  Future<void> addNewTask(BuildContext context ) async{
    bool isSuccess = false;
    _inProgress = true;
    update();
    Map<String, dynamic> inputParams = {
      "title": titleController.text.trim(),
      "description": descriptionController.text.trim(),
      "status": "New",
    };
    final response = await NetworkCaller.postRequest(Urls.createTask, inputParams);

    if(response.isSuccess){
      //inputParams.clear();
      if(context.mounted){
        showSnacbarMessage(context, 'New Task Added');
        Get.find<CountTaskByStatusController>().getCountByTaskStatus();
        Get.find<NewTaskController>().getNewTask();
      }

      isSuccess = true;
    }else{
      if(context.mounted){
        showSnacbarMessage(context, response.errorMessage ?? 'Add New Task Failed',true);

      }
    }
    _inProgress= false;
    update();
    //return isSuccess;

  }

}