import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class barterController extends GetxController {
  var barterItems = [].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    print("BarterController initialized");
    fetchBarterItems();
    super.onInit();
  }

  Future<void> fetchBarterItems() async {
    try {
      isLoading(true);
      print("inside fetch barterr");
      final response = await http.get(Uri.parse("http://192.168.19.73:3000/api/barter/"));

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);

        if (responseBody is Map<String, dynamic> && responseBody.containsKey("data")) {
          List<dynamic> data = responseBody["data"];

          barterItems.assignAll(data.map((item) => {
            "title": item["title"]?.toString() ?? "No Title",
            "description": item["description"]?.toString() ?? "No Description",
            "offeredBy": item["userId"]?["displayName"]?.toString() ?? "Unknown",
            "barterPoints": item["barterPoints"] ?? 0,

            "email" : item["userId"]?["email"]?.toString() ?? "test@test.com" ,
            "listingId" : item["_id"]?.toString() ?? "0xFucker" ,
            "userId" : item["userId"]?["_id"]?.toString() ?? "0xSex" ,
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
