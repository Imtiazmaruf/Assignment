import 'package:flutter/material.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/screens/auth/pin_verification_screen.dart';
import 'package:task_manager/presentation/screens/auth/sign_up_screen.dart';
import 'package:task_manager/presentation/widget/background_widget.dart';
import 'package:task_manager/presentation/widget/snacbar_message.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {

  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _emailRecoverInProgress = false;


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
                  Text('Your Email Address',
                    style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 4,),
                  Text('A 6 digits verification code will be sent to your email address ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey
                      ),),

                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
          
                    ),
          
                  ),
                  SizedBox(height: 8,),

                  SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: _emailRecoverInProgress == false,
                        replacement: Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(onPressed: (){
                          _emailRecover();
                        }, child: Icon(Icons.arrow_circle_right_rounded),),
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
                          Navigator.pop(context);
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
    _emailTEController.dispose();

    super.dispose();
  }
  Future<void> _emailRecover() async{
    _emailRecoverInProgress = true;
    setState(() {});
    final response = await NetworkCaller.getRequest(
        Urls.recoverVerifyEmail(_emailTEController.text.trim()));
    _emailRecoverInProgress = false;
    if(response.isSuccess){
     if(!mounted){
       return;
     }
     Navigator.push(
         context, MaterialPageRoute(
         builder: (context)=> PinVerificationScreen(email: _emailTEController.text.trim(),)));

    }else{
      _emailRecoverInProgress = false;
      setState(() {});
      if(!mounted){
        return;
      }
      showSnacbarMessage(context, response.errorMessage.toString());

    }
  }
}
