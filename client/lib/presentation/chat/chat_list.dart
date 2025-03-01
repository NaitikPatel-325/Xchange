import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  final List<Map<String, String>> chats = [
    {
      "title": "Laptop for Camera",
      "lastMessage": "John: Let's finalize the deal!",
      "user": "John Doe",
    },
    {
      "title": "Graphic Design Services",
      "lastMessage": "Alice: Can you provide more details?",
      "user": "Alice Smith",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Chats", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(chat["title"] ?? "", style: const TextStyle(color: Colors.white)),
              subtitle: Text(chat["lastMessage"] ?? "", style: TextStyle(color: Colors.grey[400])),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {
                Get.to(() => ChatScreen(user: chat["user"] ?? "Unknown", title: chat["title"] ?? ""));
              },
            ),
          );
        },
      ),
    );
  }
}
