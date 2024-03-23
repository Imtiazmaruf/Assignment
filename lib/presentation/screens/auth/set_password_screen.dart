import 'package:flutter/material.dart';
import 'package:task_manager/presentation/screens/auth/sign_in_screen.dart';
import 'package:task_manager/presentation/widget/background_widget.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {

  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();


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
                    controller: _passwordTEController,
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
                      child: ElevatedButton(onPressed: (){},
                        child: Text('Confirm'),)),
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
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();

    super.dispose();
  }
}
