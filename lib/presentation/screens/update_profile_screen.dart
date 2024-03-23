import 'package:flutter/material.dart';
import 'package:task_manager/presentation/widget/background_widget.dart';
import 'package:task_manager/presentation/widget/profile_bar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: BackgroundWidget(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              SizedBox(height: 48,),
              Text('Update Profile', style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 24
              )),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8)
                        ),
                      ),
                      child: Text('Photo', style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                    SizedBox(width: 8),
                    Text('Image.png')
                  ],
                ),
              ),
              SizedBox(height: 8),

              TextFormField(
                controller: _emailTEController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
          
                    hintText: 'Email'
                ),
              ),
              SizedBox(height: 8,),
              TextFormField(
                controller: _firstNameTEController,
                decoration: InputDecoration(
                    hintText: 'Frist Name'
                ),
              ),
              SizedBox(height: 8,),
              TextFormField(
                controller: _lastNameTEController,
                decoration: InputDecoration(
                    hintText: 'Last Name'
                ),
              ),
              SizedBox(height: 8,),
              TextFormField(
                controller: _mobileTEController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Mobile'
                ),
              ),
              SizedBox(height: 8,),
              TextFormField(
                controller: _passwordTEController,
                decoration: InputDecoration(
                    hintText: 'Password'
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_circle_right_rounded),)),
            ],
          ),
        ),
      ),
    );
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
