import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xchange/core/routes/routes.dart';
import 'package:xchange/presentation/signin/components/signin_bar.dart';
import 'package:xchange/presentation/signin/components/signin_input_form.dart';
import 'package:xchange/presentation/signup/components/button.dart';
import 'package:xchange/presentation/signup/components/signup_options.dart';
import 'package:xchange/logic/controller/signin_controller.dart';



class SignInBody extends StatelessWidget {
  SignInBody({super.key});
  final controller = Get.put(SignInController());
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            const SignInBar(),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Sign in with one of the following options.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 20,
            ),
            const SignUpOptions(),
            SignInForm(),
            Obx(
                  () => AccountButton(
                text: "Login Account",
                loading: controller.loading.value,
                onTap: () {
                  controller.loginAccount();
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => Get.toNamed(Routes.signUpScreen),
                  child: RichText(
                      text: const TextSpan(children: [
                        TextSpan(
                            text: 'Don\'t have an account? ',
                            style: TextStyle(
                              color: Colors.grey,
                            )),
                        TextSpan(
                            text: 'Sign up',
                            style: TextStyle(
                              color: Colors.white,
                            ))
                      ])),
                ))
          ],
        ),
      ),
    );
  }
}