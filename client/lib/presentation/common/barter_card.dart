import 'package:flutter/material.dart';

class BarterCard extends StatelessWidget {
  final Map<String, dynamic> barter;

  const BarterCard({super.key, required this.barter});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.black,
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Left Section: Icon + Category
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.swap_horiz,
                    color: Colors.purpleAccent,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),

                // Right Section: Barter Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        barter["title"] ?? "Trade Item",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${barter["offer"]} ↔ ${barter["request"]}",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.purpleAccent, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            barter["location"] ?? "Unknown Location",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right Arrow for Navigation
                const Icon(Icons.arrow_forward_ios, color: Colors.purpleAccent, size: 20),
              ],
            ),
        ),
        );}
}