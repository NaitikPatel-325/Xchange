import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:xchange/logic/services/shared_pref.dart';
import 'package:xchange/utils/utils.dart';
import 'package:xchange/logic/controller/signin_controller.dart';
import 'package:xchange/logic/controller/signup_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';


class FirebaseServices {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseDatabase database = FirebaseDatabase.instance;
  static final signInController = Get.put(SignInController());
  static Future<void> createAccount() async {
    final String baseUrl = 'http://192.168.19.73:3000';

    print("insidesignup"+ baseUrl);
    try {
      signUpController.setLoading(true);
      final String str = signUpController.email.value.text.toString();
      final String node = str.substring(0, str.indexOf('@'));


      final response = await http
          .post(
        Uri.parse('$baseUrl/api/users/register'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'email': signUpController.email.value.text,
          'password': signUpController.password.value.text,
          'displayName': signUpController.name.value.text,
        }),
      )
          .timeout(Duration(seconds: 10), onTimeout: () {
        throw Exception("Request timed out. Check the backend server.");
      });

      print("Response received: ${response.statusCode} - ${response.body}");

      database.ref('Accounts').child(node).set({
        'displayName': signUpController.name.value.text.toString(),
        'email': signUpController.email.value.text.toString(),
        'password': signUpController.password.value.text.toString(),
      }).then((value) {
        auth
            .createUserWithEmailAndPassword(
            email: signUpController.email.value.text.toString(),
            password: signUpController.password.value.text.toString())
            .then((value) {
          UserPref.setUser(
              signUpController.name.value.text.toString(),
              signUpController.email.value.text.toString(),
              signUpController.password.value.text.toString(),
              node,
              value.user!.uid.toString());
          Utils.showSnackBar(
              'Sign up',
              "Account is successfully created",
              const Icon(
                Icons.done,
                color: Colors.white,
              ));
          signUpController.setLoading(false);

        }).onError((error, stackTrace) {
          Utils.showSnackBar(
              'Error',
              Utils.extractFirebaseError(error.toString()),
              const Icon(
                FontAwesomeIcons.triangleExclamation,
                color: Colors.red,
              ));
          signUpController.setLoading(false);
        });
      }).onError((error, stackTrace) {
        Utils.showSnackBar(
            'Error',
            Utils.extractFirebaseError(error.toString()),
            const Icon(
              FontAwesomeIcons.triangleExclamation,
              color: Colors.red,
            ));
        signUpController.setLoading(false);
      });
      print("Navigating to Preferences Screen...");
      Get.offAllNamed("/preferencesScreen");

    } catch (e) {
      Utils.showSnackBar(
          'Error',
          Utils.extractFirebaseError(e.toString()),
          const Icon(
            FontAwesomeIcons.triangleExclamation,
            color: Colors.red,
          ));
      signUpController.setLoading(true);
    }
  }


  static final signUpController = Get.put(SignupController());
  static Future<void> loginAccount() async {
    try {
      signInController.setLoading(true);
      // Perform sign-in with await
      UserCredential value = await auth.signInWithEmailAndPassword(
        email: signInController.email.value.text,
        password: signInController.password.value.text,
      );


      // Extract user email
      String node = value.user!.email!.substring(0, value.user!.email!.indexOf('@'));
      // String node = value.user!.email!.substring(0, value.user!.email!.indexOf('@'))

      // Fetch user data from the database
      database.ref('Accounts').child(node).onValue.listen((event) {
        print("Event: ${event.snapshot.value}");

        var data = event.snapshot.value;

        if (data is Map<dynamic, dynamic>) { // Ensure data is a Map
          // Fetch user details safely
          String name = data['name']?.toString() ?? "Unknown";
          String email = data['email']?.toString() ?? "Unknown";
          String password = data['password']?.toString() ?? "Unknown";

          // Store user data in preferences
          UserPref.setUser(name, email, password, node, value.toString());

          Utils.showSnackBar(
            'Sign in',
            "Successfully logged in. Welcome back!",
            const Icon(Icons.done, color: Colors.white),
          );
        } else {
          print("Unexpected data format: $data");
          Utils.showSnackBar(
            'Error',
            "Invalid data format received from Firebase.",
            const Icon(FontAwesomeIcons.triangleExclamation, color: Colors.red),
          );
        }

        signInController.setLoading(false);
      }).onError((error, stackTrace) {
        Utils.showSnackBar(
          'Error',
          Utils.extractFirebaseError(error.toString()),
          const Icon(FontAwesomeIcons.triangleExclamation, color: Colors.red),
        );
        signInController.setLoading(false);
      });

      Get.offAllNamed("homePage");
      // Show success message
      Utils.showSnackBar(
        'Sign in',
        "Successfully logged in. Welcome back!",
        const Icon(Icons.done, color: Colors.white),
      );

    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      Utils.showSnackBar(
        'Error',
        Utils.extractFirebaseError(e.message.toString()),
        const Icon(FontAwesomeIcons.triangleExclamation, color: Colors.red),
      );
      print("Firebase Auth Error: ${e.code} - ${e.message}");
      signInController.setLoading(false);
    } catch (e) {
      // Handle unexpected errors
      Utils.showSnackBar(
        'Error',
        Utils.extractFirebaseError(e.toString()),
        const Icon(FontAwesomeIcons.triangleExclamation, color: Colors.red),
      );
      print("Unexpected Error: $e");
      signInController.setLoading(false);
    }
  }

  static Future<void> signInwWithGoogle()async{
    try{
      final GoogleSignIn googleSignIn = GoogleSignIn();
      googleSignIn.signIn().then((GoogleSignInAccount? googleSignInAccount) async {
        if (googleSignInAccount != null) {
          // Get the GoogleSignInAuthentication object
          final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
          // Create an AuthCredential object
          final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken,
          );

          await auth.signInWithCredential(credential).then((value) {
            final String str = value.user!.email.toString();
            final String node = str.substring(0, str.indexOf('@'));
            database.ref('Accounts').child(node).set({
              'name' : value.user!.displayName,
              'email' : value.user!.email,
            }).then((val) {
              Utils.showSnackBar(
                  'Login',
                  'Successfully Login',
                  const Icon(
                    FontAwesomeIcons.triangleExclamation,
                    color: Colors.red,
                  ));
              UserPref.setUser(
                  value.user!.displayName!,
                  value.user!.email!,
                  "NOPASSWORD",
                  node,
                  value.user!.uid);
            }).onError((error, stackTrace) {
              Utils.showSnackBar(
                  'Error',
                  Utils.extractFirebaseError(error.toString()),
                  const Icon(
                    FontAwesomeIcons.triangleExclamation,
                    color: Colors.red,
                  ));
              return;
            });
          }).onError((error, stackTrace) {
            Utils.showSnackBar(
                'Error',
                Utils.extractFirebaseError(error.toString()),
                const Icon(
                  FontAwesomeIcons.triangleExclamation,
                  color: Colors.red,
                ));
            return;
          });
        }
      }).onError((error, stackTrace) {
        Utils.showSnackBar(
            'Error',
            Utils.extractFirebaseError(error.toString()),
            const Icon(
              FontAwesomeIcons.triangleExclamation,
              color: Colors.red,
            ));
        return;
      });
    }catch(e){
      Utils.showSnackBar(
          'Error',
          Utils.extractFirebaseError(e.toString()),
          const Icon(
            FontAwesomeIcons.triangleExclamation,
            color: Colors.red,
          ));
    }
  }
  static Future<void> signInWithApple()async{
  }


}