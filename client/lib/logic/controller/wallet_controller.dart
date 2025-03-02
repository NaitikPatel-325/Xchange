import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WalletController extends GetxController {
  var barterPoints = 0.obs;
  var isLoading = true.obs;

  @override
  void onReady() {
    super.onReady();
    fetchBarterPoints(); // Fetches data whenever the page is opened
  }

  Future<void> fetchBarterPoints() async {
    try {
      isLoading(true);
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? email = pref.getString('EMAIL');
      if (email == null) {
        print("No email found in SharedPreferences");
        return;
      }

      var response = await http.get(Uri.parse('http://192.168.19.58:3000/api/users/email/$email'));
      if (response.statusCode == 200) {
        var data = json.decode(utf8.decode(response.bodyBytes));
        barterPoints.value = data['BarterPoints'];
      }
    } catch (e) {
      print("Error fetching points: $e");
    } finally {
      isLoading(false);
    }
  }
}
