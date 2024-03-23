import 'package:flutter/material.dart';

void showSnacbarMessage(BuildContext context, String message, [bool isErorMessage = false]){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),
    backgroundColor: isErorMessage? Colors.red : null,),);
}

