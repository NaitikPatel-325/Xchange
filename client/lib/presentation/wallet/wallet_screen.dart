import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xchange/core/app_color.dart';

import '../../logic/controller/wallet_controller.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("wallet page");
    final WalletController controller = Get.put(WalletController());

    return Scaffold(
      backgroundColor: darkBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Available Barter Credits",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            // Wallet Balance Card with Gradient
            Obx(() {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    colors: [Colors.purpleAccent, Colors.pinkAccent],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your Balance",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 5),
                    controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator(color: Colors.white))
                        : Text(
                      "${controller.barterPoints.value} BP",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 30),

            const Text(
              "Transaction History",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: [
                  _transactionItem(
                    "Received from John Doe",
                    "+300 BP",
                    Colors.green,
                  ),
                  _transactionItem(
                    "Exchanged for Camera",
                    "-500 BP",
                    Colors.red,
                  ),
                  _transactionItem(
                    "Received from Alice",
                    "+200 BP",
                    Colors.green,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Transfer & Request Buttons with Gradient
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton(Icons.send, "Transfer"),
                _actionButton(Icons.request_page, "Request"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactionItem(String title, String amount, Color amountColor) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: Text(
          amount,
          style: TextStyle(color: amountColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: const LinearGradient(
              colors: [Colors.purpleAccent, Colors.pinkAccent],
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
