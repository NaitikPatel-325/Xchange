import 'package:flutter/material.dart';

import '../../core/app_color.dart';
import 'components/signup_body.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}
class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: darkBackgroundColor,
      body: SafeArea(
        child: SignupBody(),
      ),
    );
  }
}