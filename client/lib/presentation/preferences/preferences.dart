import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xchange/core/routes/routes.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  // Ensure icons are properly defined and not null
  final List<Map<String, dynamic>> preferences = [
    {'name': 'Electronics', 'icon': Icons.devices, 'color': Colors.blue},
    {'name': 'Furniture', 'icon': Icons.chair, 'color': Colors.amber},
    {'name': 'Books', 'icon': Icons.menu_book, 'color': Colors.green},
    {'name': 'Clothing', 'icon': Icons.shopping_bag, 'color': Colors.purple},
    {'name': 'Sports', 'icon': Icons.sports_soccer, 'color': Colors.orange},
    {'name': 'Vehicles', 'icon': Icons.directions_car, 'color': Colors.red},
    {'name': 'Art', 'icon': Icons.palette, 'color': Colors.pink},
    {'name': 'Photography', 'icon': Icons.camera_alt, 'color': Colors.teal},
    {'name': 'Gaming', 'icon': Icons.sports_esports, 'color': Colors.indigo},
    {'name': 'Music', 'icon': Icons.music_note, 'color': Colors.deepOrange},
    {'name': 'Tools', 'icon': Icons.handyman, 'color': Colors.brown},
    {'name': 'Collectibles', 'icon': Icons.diamond, 'color': Colors.lightBlue},
  ];

  List<String> selectedPreferences = [];

  void toggleSelection(String preference) {
    setState(() {
      if (selectedPreferences.contains(preference)) {
        selectedPreferences.remove(preference);
      } else {
        selectedPreferences.add(preference);
      }
    });
  }

  void savePreferences() {
    // Navigate to home after selection
    Get.toNamed(Routes.homePage, arguments: {'preferences': selectedPreferences});
  }

  @override
  Widget build(BuildContext context) {
    // Simplify the widget structure to eliminate potential null issues
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: const Text("What are you interested in?",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )
        ),
      ),
      body: Column(
        children: [
          // Description text
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            color: const Color(0xFF1E1E1E),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select categories to personalize your barter trading experience. You can always change these later.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                // Info banner with fixed layout
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[400], size: 20),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Select at least 3 categories for the best experience",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Simplified grid - now using GridView.builder directly
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,  // Changed to 2 for better mobile display
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: preferences.length,
              itemBuilder: (context, index) {
                final pref = preferences[index];
                final isSelected = selectedPreferences.contains(pref['name']);
                final IconData iconData = pref['icon'] as IconData;
                final Color color = Colors.blue;
                return GestureDetector(
                  onTap: () => toggleSelection(pref['name']),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withOpacity(0.15)
                          : const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? color : Colors.grey[800]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon container with explicit dimensions and properties
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSelected ? color : color.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            iconData,
                            color: isSelected ? Colors.white : color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Text with controlled properties
                        Text(
                          pref['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? color : Colors.white70,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // Simple selected indicator
                        if (isSelected) ...[
                          const SizedBox(height: 8),
                          Container(
                            width: 24,
                            height: 3,
                            color: color,
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Bottom bar with fixed properties and safe implementation
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  "${selectedPreferences.length} categories selected",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (selectedPreferences.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedPreferences.clear();
                      });
                    },
                    child: const Text(
                      "Clear All",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: selectedPreferences.length >= 3
                  ? savePreferences
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledBackgroundColor: Colors.blue.withOpacity(0.3),
                disabledForegroundColor: Colors.white60,
              ),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  selectedPreferences.length >= 3
                      ? "Continue"
                      : "Select at least 3 categories",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}