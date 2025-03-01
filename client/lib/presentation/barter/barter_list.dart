import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xchange/core/app_color.dart';
import 'barter_details.dart';
import 'create_barter.dart';

class BarterListScreen extends StatelessWidget {
  final List<Map<String, String>> barterItems = [
    {
      "title": "Laptop for Camera",
      "description": "Looking to exchange my laptop for a DSLR camera.",
      "offeredBy": "John Doe",
    },
    {
      "title": "Graphic Design Services",
      "description":
          "Offering graphic design work in exchange for website development.",
      "offeredBy": "Alice Smith",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      // appBar: AppBar(
      //   title: const Text("Barter Listings", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.add),
      //       onPressed: () {
      //         Get.to(() => CreateBarterScreen());
      //       },
      //     ),
      //   ],
      // ),
      body: ListView.builder(
        itemCount: barterItems.length,
        itemBuilder: (context, index) {
          final item = barterItems[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(item["title"] ?? ""),
              subtitle: Text(item["description"] ?? ""),
              trailing: Text("By ${item["offeredBy"]}"),
              onTap: () {
                Get.to(() => BarterDetailScreen(item: item));
              },
            ),
          );
        },
      ),
    );
  }
}
