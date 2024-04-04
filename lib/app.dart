import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controller_binder.dart';
import 'package:task_manager/presentation/controllers/sign_in_controller.dart';
import 'package:task_manager/presentation/screens/splash_screen.dart';
import 'package:task_manager/presentation/utility/app_colour.dart';

class TaskManager extends StatelessWidget {
   TaskManager({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: TaskManager.navigatorKey,
      title: 'Task Manager',
      home: const SplashScreen(),
      theme: _themeData,
      initialBinding: ControllerBinder(),
    );
  }

  final ThemeData _themeData = ThemeData(
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8)
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              ),
              backgroundColor: Appcolor.themeColor,
              foregroundColor: Colors.white,
              padding:const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
          )
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            foregroundColor: Appcolor.themeColor,
            textStyle:const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            )),
      ),
      textTheme:const TextTheme(
        titleLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
      ),
      chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          )
      )
  );
}

