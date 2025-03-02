import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xchange/presentation/common/barter_card.dart';

class CategoryListingsScreen extends StatefulWidget {
  final String category;

  const CategoryListingsScreen({super.key, required this.category});

  @override
  _CategoryListingsScreenState createState() => _CategoryListingsScreenState();
}

class _CategoryListingsScreenState extends State<CategoryListingsScreen> {
  List<Map<String, dynamic>> allBarterItems = [];
  List<Map<String, dynamic>> filteredBarterItems = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchAllBarterItems();
  }

  Future<void> fetchAllBarterItems() async {
    try {
      final response = await http.get(Uri.parse("http://192.168.19.58:3000/api/barter"));
      // print(response.statusCode);
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);

        if (responseBody['success'] == true && responseBody['data'] is List) {
          List data = responseBody['data'];
          // print(data);
          setState(() {
            allBarterItems = data.map<Map<String, dynamic>>((item) => {
              "title": item["title"]?.toString() ?? "No Title",
              "description": item["description"]?.toString() ?? "No Description",
              "offer": item["offer"]?.toString() ?? "No Offer",
              "request": item["request"]?.toString() ?? "No Request",
              "category": item["category"]?.toString() ?? "Uncategorized",
              "location": item["location"]?.toString() ?? "Unknown",
              "barterPoints": item["barterPoints"] ?? 0,
              "userName": item["userId"]?["displayName"] ?? "Unknown User",
            }).toList();

            filterByCategory();
            isLoading = false;
          });
        } else {
          throw Exception("Invalid data format received.");
        }
      } else {
        throw Exception("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      print("Error fetching items: $e");
    }
  }

  void filterByCategory() {
    setState(() {
      filteredBarterItems = allBarterItems
          .where((item) => item["category"] == widget.category)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.purpleAccent))
          : hasError
          ? _errorState()
          : filteredBarterItems.isEmpty
          ? _emptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredBarterItems.length,
        itemBuilder: (context, index) {
          var barter = filteredBarterItems[index];
          return BarterCard(barter: barter);
        },
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 50, color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            "No listings available in ${widget.category}",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _errorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 50, color: Colors.red),
          const SizedBox(height: 10),
          const Text(
            "Error fetching data. Please try again later.",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
