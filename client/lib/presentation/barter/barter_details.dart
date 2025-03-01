import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xchange/presentation/chat/chat_screen.dart';

class BarterDetailScreen extends StatelessWidget {
  final Map<String, String> item;

  const BarterDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(item["title"] ?? "Barter Details", style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item["title"] ?? "",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),

            Text(
              "Posted by: ${item["offeredBy"]}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            Text(
              "Description:",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(item["description"] ?? "", style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),

            Text(
              "Offering:",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(item["offer"] ?? "Not specified", style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),

            Text(
              "Requesting:",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(item["request"] ?? "Not specified", style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 30),

            // "Propose Exchange" Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.snackbar("Success", "Exchange proposal sent!");
                  // TODO: Implement barter request API call
                },
                child: const Text("Propose Exchange"),
              ),
            ),

            const SizedBox(height: 10),

            // "Start Chat" Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                onPressed: () {
                  Get.to(() => ChatScreen(
                    user: item["offeredBy"] ?? "Unknown",
                    title: item["title"] ?? "Barter Chat",
                  ));
                },
                child: const Text("Start Chat"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
