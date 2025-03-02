import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/utils.dart';

class BarterController extends GetxController {
  var title = ''.obs;
  var description = ''.obs;
  var offer = ''.obs;
  var request = ''.obs;
  var category = ''.obs;
  var imageUrl = ''.obs;
  var barterPoints = 0.obs ;


  Future<void> submitBarter() async {
    if (title.isEmpty || description.isEmpty || offer.isEmpty || request.isEmpty || category.isEmpty) {
      Get.snackbar("Error", "All fields are required!");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('EMAIL');
    print(email);
    if (email == null) {
      Get.snackbar("Error", "User not logged in!");
      return;
    }

    var url = Uri.parse('http://192.168.19.58:3000/api/barter/create');

    var body = jsonEncode({
      "title": title.value,
      "description": description.value,
      "offer": offer.value,
      "request": request.value,
      "category": category.value,
      "email": email,
      "barterPoints" : barterPoints.value ,
    });

    print(body);

    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

        print(response.statusCode);
        if (response.statusCode == 200) {
          Utils.showSnackBar(
            "Success",
            "Barter deal created successfully!",
            const Icon(Icons.check_circle, color: Colors.green),
          );
          Get.offAllNamed('/homePage');
        } else {
          Utils.showSnackBar(
            "Error",
            "Failed to create barter deal. Try again.",
            const Icon(Icons.error, color: Colors.red),
          );
        }
      } catch (e) {
        Utils.showSnackBar(
          "Error",
          "Something went wrong: $e",
          const Icon(Icons.warning, color: Colors.orange),
        );
      }

  }
}
