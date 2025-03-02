import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xchange/core/app_color.dart';
import '../../logic/controller/BarterController.dart';
import 'barter_details.dart';
import 'create_barter.dart';

class BarterListScreen extends StatelessWidget {
  final barterController controller = Get.put(barterController());
  final TextEditingController searchController = TextEditingController();

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              onChanged: (value) => controller.filterBarterItems(value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search by title or description...',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white70),
                  onPressed: () {
                    searchController.clear();
                    controller.filterBarterItems('');
                  },
                )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredBarterItems.isEmpty) {
                return const Center(
                  child: Text(
                    "No barter items found!",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: controller.filteredBarterItems.length,
                itemBuilder: (context, index) {
                  final item = controller.filteredBarterItems[index] as Map<String, dynamic>;
                  return _buildBarterCard(context, item);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBarterCard(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Get.to(() => BarterDetailScreen(
          item: item.map((key, value) => MapEntry(key, value.toString())),
        ));
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
            Text(
              item["title"]?.toString() ?? "No Title",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            Text(
              item["description"]?.toString() ?? "No description available.",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.grey, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      "By ${item["offeredBy"]?.toString() ?? "Unknown"}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.orangeAccent, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      "${item["barterPoints"] ?? 0} Points",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
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
