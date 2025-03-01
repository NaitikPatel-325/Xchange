import 'package:get/get.dart';

class ChatController extends GetxController {
  var messages = <String>[].obs;
  var messageInput = ''.obs;

  void sendMessage() {
    if (messageInput.isNotEmpty) {
      messages.add("You: ${messageInput.value}");
      messageInput.value = ''; // Clear input field
    }
  }
}
