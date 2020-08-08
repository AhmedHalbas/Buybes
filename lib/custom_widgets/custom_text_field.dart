import 'package:buybes/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final Function onSaved;
  final String initialValue;
  CustomTextField(
      {this.onSaved,
      @required this.hint,
      @required this.icon,
      this.initialValue});

  String _errorMessages() {
    switch (hint) {
      case 'Enter Your Name':
        return 'Fill Name';
      case 'Enter Your Email':
        return 'Fill Email';
      case 'Enter Your Password':
        return 'Fill Password';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        initialValue: initialValue,
        // ignore: missing_return
        validator: (value) {
          if (value.isEmpty) {
            return _errorMessages();
          }
        },
        obscureText: hint == 'Enter Your Password' ? true : false,
        onSaved: onSaved,
        cursorColor: kMainColor,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: kMainColor,
          ),
          filled: true,
          fillColor: kSecondaryColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
