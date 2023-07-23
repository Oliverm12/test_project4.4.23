import 'package:password_text_field/password_text_field.dart';
import 'package:flutter/material.dart';

class UserReg extends StatelessWidget{
  const UserReg ({Key? key}) : super (key: key);

  @override
  Widget build (BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          const TextField (decoration: InputDecoration (labelText: 'Name'),),
          const TextField (decoration: InputDecoration (labelText: 'Lastname'),),
          const TextField (decoration: InputDecoration (labelText: 'Email'),),
          const PasswordTextField(decoration: InputDecoration(hintText: 'New Password'),),
          ElevatedButton (onPressed: (){Navigator.pop(context);}, child: const Text(' Save Data'),),
        ],
      ),
    );
  }
}