import 'package:flutter/material.dart';
import 'package:xchange/presentation/signin/components/sign_body.dart';

import '../../core/app_color.dart';


class SignIn extends StatelessWidget {
  const SignIn({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      body: SafeArea(
        child: SignInBody(),
      ),
    );
  }
}