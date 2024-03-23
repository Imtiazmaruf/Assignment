
import 'package:flutter/material.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/presentation/controllers/auth_controllers.dart';
import 'package:task_manager/presentation/screens/auth/sign_in_screen.dart';
import 'package:task_manager/presentation/screens/update_profile_screen.dart';
import 'package:task_manager/presentation/utility/app_colour.dart';

PreferredSizeWidget get profileAppBar {
  return AppBar(

    automaticallyImplyLeading: false,
    backgroundColor: Appcolor.themeColor,
    title: GestureDetector(
      onTap: (){
        Navigator.push(TaskManager.navigatorKey.currentState!.context,
            MaterialPageRoute(builder: (context)=> UpdateProfileScreen()));
      },
      child: Row(
        children: [
          CircleAvatar(),
          SizedBox(width: 8,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AuthController.userData?.fullName ,style: TextStyle(
                    fontSize: 16,
                    color: Colors.white
                ),),
                Text(AuthController.userData?.email ?? '', style: TextStyle(
                    fontSize: 12,
                    color: Colors.white
                ),),
      
              ],
            ),
          ),
          IconButton(onPressed: () async{
            await AuthController.clearUserData();
            Navigator.pushAndRemoveUntil(
                TaskManager.navigatorKey.currentState!.context,
            MaterialPageRoute(builder: (context)=> SignInScreen()),
                    (route) => false);
          }, icon: Icon(Icons.logout))
        ],
      ),
    ),
  );
}
