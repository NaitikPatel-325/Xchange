import 'package:get/get.dart';

class MatchController extends GetxController {
  var recommendedBarters = <Map<String, String>>[].obs;

  // Dummy Data (AI recommendations will replace this later)
  final List<Map<String, String>> allBarters = [
    {"title": "Laptop for Camera", "user": "John Doe"},
    {"title": "Web Design for Guitar", "user": "Alice Smith"},
    {"title": "Books for Digital Credits", "user": "David Johnson"},
    {"title": "iPad for Drone", "user": "Emma Brown"},
  ];

  // Function to fetch AI-recommended barter deals
  void fetchRecommendedBarters() {
    // Simulating AI recommendation (we’ll later connect this to an AI API)
    recommendedBarters.value = allBarters.sublist(0, 3);
  }
}