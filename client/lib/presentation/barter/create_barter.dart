import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xchange/logic/controller/barter_controller.dart';

class CreateBarterScreen extends StatelessWidget {
  final BarterController controller = Get.put(BarterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Barter Deal")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) => controller.title.value = value,
              decoration: const InputDecoration(labelText: "Barter Title"),
            ),
            TextField(
              onChanged: (value) => controller.description.value = value,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 2,
            ),
            TextField(
              onChanged: (value) => controller.offer.value = value,
              decoration: const InputDecoration(labelText: "What are you offering?"),
            ),
            TextField(
              onChanged: (value) => controller.request.value = value,
              decoration: const InputDecoration(labelText: "What do you want in return?"),
            ),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.submitBarter,
                child: const Text("Submit Barter"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
