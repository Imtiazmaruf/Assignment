import 'package:flutter/material.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/screens/auth/sign_in_screen.dart';
import 'package:task_manager/presentation/widget/background_widget.dart';
import 'package:task_manager/presentation/widget/snacbar_message.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key, this.email, this.otp});
  final email;
  final otp;

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {

  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _setPasswordInProgress = false;


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
                  Text('Set your password',
                    style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 4,),
                  Text('Minimum leanth password 8 character with letter and number combination ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey
                      ),),

                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                    ),
                  ),

                  SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: _setPasswordInProgress == false,
                        replacement: Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(onPressed: (){
                          _setPassword();
                        },
                          child: Text('Confirm'),),
                      )),
                  SizedBox(height: 48,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Have account?",style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16
                      ),),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> SignInScreen()));
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
  Future<void> _setPassword() async{
    _setPasswordInProgress = true;
    setState(() {});
    Map<String, dynamic> inputparams = {
      "email": widget.email,
      "OTP": widget.otp,
      "password": _confirmPasswordTEController.text
    };
    final response = await NetworkCaller.postRequest(
        Urls.recoverResetPass, inputparams);
    _setPasswordInProgress = false;
    if(response.isSuccess){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) => SignInScreen()), (route) => false);
    }else{
      _setPasswordInProgress= false;
      setState(() {});
      showSnacbarMessage(context, response.errorMessage.toString());
    }
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
