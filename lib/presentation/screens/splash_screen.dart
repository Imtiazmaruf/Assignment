import 'package:flutter/material.dart';
import 'package:task_manager/presentation/controllers/auth_controllers.dart';
import 'package:task_manager/presentation/screens/auth/sign_in_screen.dart';
import 'package:task_manager/presentation/screens/main_bottom_nav_screen.dart';


import 'package:task_manager/presentation/widget/app_logo.dart';

import 'package:task_manager/presentation/widget/background_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _moveToNextScreen();

  }


  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    bool loginState = await AuthController.isUserLoggedIn();

    if (mounted) {
      if(loginState) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MainBottomNavScreen()));
      }else{

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => SignInScreen()));
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: Center(
          child: AppLogo(),
        ),
      )
    );
  }

}


