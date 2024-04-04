import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/model/user_data.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/controllers/auth_controllers.dart';
import 'package:task_manager/presentation/screens/main_bottom_nav_screen.dart';
import 'package:task_manager/presentation/widget/background_widget.dart';
import 'package:task_manager/presentation/widget/profile_bar.dart';
import 'package:task_manager/presentation/widget/snacbar_message.dart';

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
  XFile? _pickedImage;
  bool _updateProfileInProgress = false;

  @override
  void initState() {
    super.initState();
    _emailTEController.text = AuthController.userData?.email ?? '';
    _firstNameTEController.text = AuthController.userData?.firstName ?? '';
    _lastNameTEController.text = AuthController.userData?.lastName ?? '';
    _mobileTEController.text = AuthController.userData?.mobile ?? '';
  }

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
              imagePickerButton(),
              SizedBox(height: 8),

              TextFormField(
                enabled: false,
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
                validator: (String? value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Enter your first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8,),
              TextFormField(
                controller: _lastNameTEController,
                decoration: InputDecoration(
                    hintText: 'Last Name'
                ),
                validator: (String? value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Enter your last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8,),
              TextFormField(
                controller: _mobileTEController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Mobile'
                ),
                validator: (String? value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Enter your mobile number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8,),
              TextFormField(
                controller: _passwordTEController,
                decoration: InputDecoration(
                    hintText: 'Password(optional)'
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                  width: double.infinity,
                  child: Visibility(
                    visible: _updateProfileInProgress == false,
                    replacement: Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ElevatedButton(
                      onPressed: (){
                        _updateProfile();
                      },
                      child: Icon(Icons.arrow_circle_right_rounded),),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget imagePickerButton() {
    return GestureDetector(
      onTap: (){
        pickImageFromGallery();
      },
      child: Container(
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
                    Expanded(child: Text(_pickedImage?.name ?? '', maxLines: 1,
                        style: TextStyle(
                      overflow: TextOverflow.ellipsis
                    ),),),
                  ],
                ),
              ),
    );
  }
  Future<void> pickImageFromGallery() async{
    ImagePicker imagePicker = ImagePicker();
    _pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});

  }

  Future<void> _updateProfile() async {
    String? photo;
    _updateProfileInProgress = true;
    setState(() {});
    Map<String, dynamic> inputParams = {
      "email": _emailTEController.text,
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
    };
    if(_passwordTEController.text.isNotEmpty){
      inputParams['password'] = _passwordTEController.text;
    }
    if(_pickedImage != null){
      List<int> bytes = File(_pickedImage!.path).readAsBytesSync();
      String photo = base64Encode(bytes);
      inputParams['photo'] = photo;
    }
    final response = await NetworkCaller.postRequest(Urls.updateProfle, inputParams);

    _updateProfileInProgress = false;
    if(response.isSuccess){
      if(response.responseBody['status'] == 'success'){
        UserData userData = UserData(
            email: _emailTEController.text,
            firstName: _firstNameTEController.text.trim(),
    lastName: _lastNameTEController.text.trim(),
    mobile: _mobileTEController.text.trim(),
          photo: photo
        );
        await AuthController.saveUserData(userData);
      }
      if(mounted) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => MainBottomNavScreen()), (
                route) => false);
      }
    }else{
      if(!mounted){
        return;
      }
      setState(() {});
      showSnacbarMessage(context, 'Upadte Profile Failled! Try again');
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
