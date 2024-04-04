import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/screens/auth/set_password_screen.dart';
import 'package:task_manager/presentation/screens/auth/sign_in_screen.dart';
import 'package:task_manager/presentation/utility/app_colour.dart';

import 'package:task_manager/presentation/widget/background_widget.dart';
import 'package:task_manager/presentation/widget/snacbar_message.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key, required this.email});
final String email;
  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {

  final TextEditingController _pinTEController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _emailRecoverOtpInProgress = false;


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
                  Text('Pin Verification',
                    style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 4,),
                  Text('A 6 digits verification code will be sent to your email address ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey
                      ),),

                  SizedBox(height: 16,),
                  PinCodeTextField(
                    controller: _pinTEController,
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(

                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      inactiveColor: Appcolor.themeColor,
                      selectedFillColor: Colors.white
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,

                    onCompleted: (v) {
                      print("Completed");
                    },
                    onChanged: (value) {
                    },
                    appContext : context,
                  ),
                  SizedBox(height: 8,),

                  SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: _emailRecoverOtpInProgress == false,
                        replacement: Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(onPressed: (){
                          _pinVerification();
                        }, child: Text('Verify'),),
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
  @override
  void dispose() {
    _pinTEController.dispose();


    super.dispose();
  }

  Future<void> _pinVerification() async{
    _emailRecoverOtpInProgress = true;
    setState(() {});
    final response = await NetworkCaller.getRequest(
        Urls.recoverVerifyOTP(widget.email, _pinTEController.text ));
    _emailRecoverOtpInProgress = false;
    if(response.isSuccess){
      if(!mounted){
        return;
      }
      Navigator.push(context, MaterialPageRoute(
          builder: (context)=> SetPasswordScreen(email: widget.email, otp: _pinTEController.text,)));

    }else{
      _emailRecoverOtpInProgress = false;
      setState(() {});
      if(!mounted){
        return;
      }
      showSnacbarMessage(context, response.errorMessage.toString());

    }
  }

}
