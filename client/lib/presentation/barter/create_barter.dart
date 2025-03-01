import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xchange/logic/controller/barter_controller.dart';

class CreateBarterScreen extends StatelessWidget {
  final BarterController controller = Get.put(BarterController());

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

              _buildInputField(
                label: "Category",
                hint: "E.g., Technology, Art, Services...",
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
