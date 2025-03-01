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
      "description": "Offering graphic design work in exchange for website development.",
      "offeredBy": "Alice Smith",
    },
    {
      "title": "Vintage Vinyl Records",
      "description": "Swapping vintage vinyl records for rare comic books.",
      "offeredBy": "Michael Lee",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Barter Listings",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Get.to(() => CreateBarterScreen());
            },
          ),
        ],
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: barterItems.length,
        itemBuilder: (context, index) {
          final item = barterItems[index];
          return _buildBarterCard(context, item);
        },
      ),
    );
  }

  Widget _buildBarterCard(BuildContext context, Map<String, String> item) {
    return GestureDetector(
      onTap: () {
        Get.to(() => BarterDetailScreen(item: item));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              item["title"] ?? "No Title",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 10),

            // Description
            Text(
              item["description"] ?? "No description available.",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 15),

            // Footer: Posted by + Arrow icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.grey, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      "By ${item["offeredBy"] ?? "Unknown"}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
