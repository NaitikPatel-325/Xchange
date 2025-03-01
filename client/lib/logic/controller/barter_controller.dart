import 'package:get/get.dart';

class BarterController extends GetxController {
  var title = ''.obs;
  var description = ''.obs;
  var offer = ''.obs;
  var request = ''.obs;
  var imageUrl = ''.obs; // Store uploaded image URL

  void submitBarter() {
    if (title.isEmpty || description.isEmpty || offer.isEmpty || request.isEmpty) {
      Get.snackbar("Error", "All fields are required!");
      return;
    }

    // Placeholder: Send data to backend (to be implemented)
    print("Submitting barter: Title=$title, Offer=$offer, Request=$request");

    Get.back(); // Navigate back after submission
  }
}
