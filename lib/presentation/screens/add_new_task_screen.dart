import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/controllers/add_new_task_screen_controller.dart';
import 'package:task_manager/presentation/screens/main_bottom_nav_screen.dart';
import 'package:task_manager/presentation/widget/background_widget.dart';
import 'package:task_manager/presentation/widget/profile_bar.dart';
import 'package:task_manager/presentation/widget/snacbar_message.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {


  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _shouldRefreshNewTaskList =false;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();




  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop){
        if(didPop){
          return;
        }
        Navigator.pop(context, _shouldRefreshNewTaskList);

      },
      child: Scaffold(
        appBar: profileAppBar,
        body: BackgroundWidget(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formkey,
                child: GetBuilder<AddNewTaskController>(
                  builder: (addNewTaskController) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 48,),
                        Text('Add New Task', style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 24
                        )),
                        SizedBox(height: 16,),
                        TextFormField(
                          controller: _titleTEController,
                          decoration: InputDecoration(
                            hintText: 'Title'
                          ),
                          validator: (String? value){
                            if(value?.trim().isEmpty ?? true){
                              return 'Enter your title';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8,),
                        TextFormField(
                          controller: _descriptionTEController,
                          maxLines: 6,
                          decoration: InputDecoration(
                            hintText: 'Description'
                          ),

                          validator: (String? value){
                            if(value?.trim().isEmpty ?? true){
                              return 'Enter your Description';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16,),
                        SizedBox(
                            width: double.infinity,
                            child: Visibility(
                              visible: addNewTaskController.addNewTaskInProgress == false,
                              replacement: Center(child: CircularProgressIndicator(),),
                              child: ElevatedButton(

                                onPressed: (){
                                  if(_formkey.currentState!.validate()){
                                     //_addNewTask();
                                   // addNewTaskController.addNewTask(_titleTEController.text.trim(),
                                    // _descriptionTEController.text.trim());
                                    addNewTaskController.addNewTask(_titleTEController.text.trim(), _descriptionTEController.text).then(
                                          (result) {
                                        if (result == true) {
                                          Get.offAll(const MainBottomNavScreen());
                                          Get.snackbar(
                                            'Congratulations!',
                                            'Add New Task Successful.',
                                            colorText: Colors.black,
                                            messageText: const Text(
                                              'Add New Task Successful.',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                          );
                                        } else {
                                          Get.snackbar(
                                            'Ops!',
                                            'Add New Task Failed! Try Again.',
                                            colorText: Colors.black,
                                            messageText: const Text(
                                              'Add New Task Failed! Try Again',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  }

                                },
                                child: Icon(Icons.arrow_circle_right_rounded),
                              ),
                            ),
                        ),
                      ],
                    );
                  }
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> _addNewTask() async{
  //   _addNewTaskInProgress = true;
  //   setState(() {});
  //
  //   Map<String, dynamic> inputParams ={
  //     "title":_titleTEController.text.trim(),
  //     "description":_descriptionTEController.text.trim(),
  //     "status":"New"
  //
  //   };
  //   final response = await NetworkCaller.postRequest(Urls.createTask, inputParams);
  //   _addNewTaskInProgress =false;
  //   setState(() {});
  //
  //   if(response.isSuccess){
  //     _shouldRefreshNewTaskList = true;
  //     _titleTEController.clear();
  //     _descriptionTEController.clear();
  //     if(mounted){
  //       showSnacbarMessage(context, 'New Task Added');
  //     }
  //
  //   }else{
  //     if(mounted){
  //       showSnacbarMessage(context, response.errorMessage ?? 'Add New Task Failled',true);
  //
  //     }
  //   }
  // }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
