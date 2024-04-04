import 'package:get/get.dart';
import 'package:task_manager/data/model/login_response.dart';
import 'package:task_manager/data/model/response_object.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/controllers/auth_controllers.dart';

class SignInController extends GetxController{
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;
  String get errorMessage => _errorMessage ?? 'Login Failed';

  Future<bool> signIn(String email, String password) async{
    _inProgress = true;
    update();
    Map<String, dynamic> inputParams = {
      "email": email,
      "password": password,
    };
    final ResponseObject response = await NetworkCaller.postRequest(Urls.login, inputParams);
    _inProgress = false;

    if(response.isSuccess){

      LoginResponse loginResponse = LoginResponse.fromJson(response.responseBody);

      await AuthController.saveUserData(loginResponse.userData!);
      await AuthController.saveUserToken(loginResponse.token!);
      update();
      return true;
    }else{
      _errorMessage =response.errorMessage;
      update();
      return false;

    }

  }

}