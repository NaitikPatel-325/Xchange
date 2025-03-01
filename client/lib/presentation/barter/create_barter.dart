import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xchange/logic/controller/barter_controller.dart';

class CreateBarterScreen extends StatefulWidget {
  @override
  _CreateBarterScreenState createState() => _CreateBarterScreenState();
}

class _CreateBarterScreenState extends State<CreateBarterScreen> {
  final BarterController controller = Get.put(BarterController());

  final List<Map<String, dynamic>> categories = [
    {"icon": Icons.devices, "label": "Electronics", "color": Colors.blue},
    {"icon": Icons.pedal_bike, "label": "Transport", "color": Colors.green},
    {"icon": Icons.sports_basketball, "label": "Sports", "color": Colors.orange},
    {"icon": Icons.palette, "label": "Arts", "color": Colors.pink},
    {"icon": Icons.chair, "label": "Furniture", "color": Colors.amber},
    {"icon": Icons.work, "label": "Jobs", "color": Colors.teal},
    {"icon": Icons.category, "label": "Other", "color": Colors.grey},
  ];

  String? selectedCategory;
  bool isOtherSelected = false;
  TextEditingController otherCategoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Create Barter Deal",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField(
                label: "Barter Title",
                hint: "Enter a catchy title...",
                onChanged: (value) => controller.title.value = value,
              ),
              const SizedBox(height: 20),

              _buildInputField(
                label: "Description",
                hint: "Describe what you're offering...",
                maxLines: 3,
                onChanged: (value) => controller.description.value = value,
              ),
              const SizedBox(height: 20),

              _buildInputField(
                label: "What are you offering?",
                hint: "E.g., Graphic Design Services",
                onChanged: (value) => controller.offer.value = value,
              ),
              const SizedBox(height: 20),

              _buildInputField(
                label: "What do you want in return?",
                hint: "E.g., Website Development",
                onChanged: (value) => controller.request.value = value,
              ),
              const SizedBox(height: 20),

              Text(
                "Category",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedCategory ?? "Electronics", // Default selection
              dropdownColor: Colors.grey[900],
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.purpleAccent),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category["label"],
                  child: Row(
                    children: [
                      Icon(category["icon"], color: category["color"]),
                      const SizedBox(width: 10),
                      Text(category["label"], style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                  isOtherSelected = value == "Other";
                  if (!isOtherSelected) {
                    controller.category.value = value!;
                  }
                });
              },
            ),

            const SizedBox(height: 20),

              if (isOtherSelected)
                _buildInputField(
                  label: "Other Category",
                  hint: "Specify your category...",
                  onChanged: (value) => controller.category.value = value,
                ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.submitBarter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Submit Barter",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.purpleAccent),
            ),
          ),
        ),
      ],
    );
  }
}
