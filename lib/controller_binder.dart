import 'package:get/get.dart';

import 'presentation/controllers/add_new_task_screen_controller.dart';
import 'presentation/controllers/count_task_by_status_controller.dart';
import 'presentation/controllers/new_task_controller.dart';
import 'presentation/controllers/sign_in_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => SignInController());
    Get.lazyPut(() => CountTaskByStatusController(), fenix: true);
    Get.lazyPut(() => NewTaskController(),fenix: true);
    Get.lazyPut(() => AddNewTaskController(),fenix: true);
  }
}