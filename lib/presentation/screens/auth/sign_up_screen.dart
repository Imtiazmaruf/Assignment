import 'package:flutter/material.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/widget/background_widget.dart';
import 'package:task_manager/presentation/widget/snacbar_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _isRegistrasionInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 60,),
                  Text('Join With Us',style: Theme.of(context).textTheme.titleLarge,),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter your email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: InputDecoration(
                      hintText: 'First Name',

                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: InputDecoration(
                      hintText: 'Last Name',

                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter your last name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _mobileTEController,
                    decoration: InputDecoration(
                      hintText: 'Mobile',

                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter your mobile number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordTEController,
                    decoration: InputDecoration(
                      hintText: 'Password',

                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter your password';
                      }
                      if(value!.length <= 6){
                        return 'Password should more than 6 letter';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: _isRegistrasionInProgress == false,
                        replacement: Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                             _signUp();

                          }
                        },
                          child: Icon(Icons.arrow_circle_right_rounded),),
                      )),
                  SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(" have account?",style: TextStyle(
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
        ),
      ),
    );
  }


  Future<void> _signUp() async {
    _isRegistrasionInProgress = true;
    setState(() {});
    Map<String, dynamic> inputParams = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": _passwordTEController.text,
    };

    final  response =
    await NetworkCaller.postRequest(Urls.registration, inputParams);

    _isRegistrasionInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      if (mounted) {
        showSnacbarMessage(context, 'Registration success! Please login.');
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        showSnacbarMessage(context, 'Registration failed! Try again.', true);
      }
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}

