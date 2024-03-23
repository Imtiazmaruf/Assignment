import 'package:flutter/material.dart';
import 'package:task_manager/data/model/login_response.dart';
import 'package:task_manager/data/model/response_object.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/controllers/auth_controllers.dart';
import 'package:task_manager/presentation/screens/auth/email_verification_screen.dart';
import 'package:task_manager/presentation/screens/auth/sign_up_screen.dart';
import 'package:task_manager/presentation/screens/main_bottom_nav_screen.dart';


import 'package:task_manager/presentation/widget/background_widget.dart';
import 'package:task_manager/presentation/widget/snacbar_message.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _isLoginInProgress = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child:SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  const SizedBox(height: 100,),
                  Text('Get Started With',
                    style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter your Email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: _isLoginInProgress == false,
                        replacement: Center(child: CircularProgressIndicator(),),
                        child: ElevatedButton(
                          onPressed: (){
                            if(_formkey.currentState!.validate()){
                              _signIn();
                            }
                          },
                          child: Icon(Icons.arrow_circle_right_rounded),),
                      )),
                  SizedBox(height: 48,),
                  Center(
                      child: TextButton(
          
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EmailVerificationScreen()));
                          },
                          child: Text('Forgotten password?',style: TextStyle(color: Colors.grey),),),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have account?",style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16
                      ),),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                        },
                        child: Text('Sign In'),)
                    ],
                  )
                ],
              ),
            ),
          ),
        ),),

    );
  }
  Future<void> _signIn() async{
    _isLoginInProgress=true;
    setState(() {});
    Map<String, dynamic> inputParams = {
      "email": _emailTEController.text.trim(),
      "password": _passwordTEController.text,
    };
    final ResponseObject response = await NetworkCaller.postRequest(Urls.login, inputParams);
    _isLoginInProgress = false;
    setState(() {});
    if(response.isSuccess){
      if(!mounted){
        return;
      }
      LoginResponse loginResponse = LoginResponse.fromJson(response.responseBody);
      print(loginResponse.userData?.firstName);
      await AuthController.saveUserData(loginResponse.userData!);
      await AuthController.saveUserToken(loginResponse.token!);

      if(mounted) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => MainBottomNavScreen()),
                (route) => false);
      }

    }else{
      if(mounted){
        showSnacbarMessage(context, response.errorMessage ?? 'Login Failed');
      }

    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();

    super.dispose();
  }
}
