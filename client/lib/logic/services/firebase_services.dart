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

  static Future<void> createAccount() async {
    final String baseUrl = 'http://192.168.19.73:3000';
    print("Inside signup: $baseUrl");

    try {
      signUpController.setLoading(true);
      final String email = signUpController.email.value.text;
      final String password = signUpController.password.value.text;
      final String displayName = signUpController.name.value.text;
      final String node = email.substring(0, email.indexOf('@'));

      final response = await http.post(
        Uri.parse('$baseUrl/api/users/register'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'displayName': displayName,
        }),
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw Exception("Request timed out. Check the backend server.");
      });

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 201 && responseData['success'] == true) {
        String mongoUserId = responseData['data']['_id'];

        await database.ref('Accounts').child(node).set({
          'displayName': displayName,
          'email': email,
          'password': password,
        });

        UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        UserPref.setUser(
          displayName,
          email,
          mongoUserId,
        );

        Utils.showSnackBar(
          'Sign up',
          "Account successfully created",
          const Icon(Icons.done, color: Colors.white),
        );

        signUpController.setLoading(false);
        Get.offAllNamed("/preferencesScreen");
      } else {
        throw Exception(responseData['message']);
      }
    } catch (e) {
      Utils.showSnackBar(
        'Error',
        Utils.extractFirebaseError(e.toString()),
        const Icon(FontAwesomeIcons.triangleExclamation, color: Colors.red),
      );
      signUpController.setLoading(false);
    }
  }



  static final FirebaseDatabase database = FirebaseDatabase.instance;
  static final signInController = Get.put(SignInController());


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
          UserPref.setUser(name, email,  value.toString());

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

    Get.offAllNamed("/homePage");
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
                  "NOTOKEN",
              );
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
