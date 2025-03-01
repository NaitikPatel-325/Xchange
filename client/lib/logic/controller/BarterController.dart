import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class barterController extends GetxController {
  var barterItems = [].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchBarterItems();
    super.onInit();
  }

  Future<void> fetchBarterItems() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse("http://192.168.19.58:3000/api/barter/"));

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);

        if (responseBody is Map<String, dynamic> && responseBody.containsKey("data")) {
          List<dynamic> data = responseBody["data"];

          barterItems.assignAll(data.map((item) => {
            "title": item["title"]?.toString() ?? "No Title",
            "description": item["description"]?.toString() ?? "No Description",
            "offeredBy": item["userId"]?["displayName"]?.toString() ?? "Unknown",
          }).toList());
        } else {
          print("Invalid data format received.");
        }
      } else {
        print("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching items: $e");
    } finally {
      isLoading(false);
    }
  }
}
