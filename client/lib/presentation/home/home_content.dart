import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:xchange/widgets/custom_carousel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../barter/barter_details.dart';
import '../category/category_listing.dart';


class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>{
  List<Map<String, String>> recommendedItems = [];
  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("MONGO_USER_ID");
    if (userId != null) {
      print(userId);
      await _fetchFeaturedItems(userId);
    }
  }

  Future<void> _fetchFeaturedItems(String userId) async {
    try {
      print("inside function");

      final response = await http.get(
        Uri.parse('http://192.168.19.73:3000/api/v2/barter/recommend/$userId'),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('recommendations') && data['recommendations'] is List) {
          final List<dynamic> items = data['recommendations'];

          setState(() {
            recommendedItems = items.map((item) {
              return {
                "userId": item["userId"]?.toString() ?? "",
                "email": item["email"]?.toString() ?? "",
                "title": item["listingTitle"]?.toString() ?? "",
                "category": item["category"]?.toString() ?? "",
                "description": item["description"]?.toString() ?? "",
                "listingId": item["listingId"]?.toString() ?? "",
              };
            }).toList();
          });

          print("Recommended Items: $recommendedItems");
        } else {
          print("No recommendations found.");
        }
      } else {
        print('Failed to load recommendations: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching recommendations: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppHeader(context),
          const SizedBox(height: 20),

          _buildSectionHeader(
            title: "Featured Trades",
            icon: Icons.local_fire_department,
            color: Colors.deepOrange,
          ),
          const SizedBox(height: 16),
          _buildFeaturedTrades(context),

          const SizedBox(height: 24),
          _buildSectionHeader(
            title: "Explore Categories",
            icon: Icons.explore,
            color: Colors.teal,
          ),
          const SizedBox(height: 16),
          _tradeCategories(context),

          const SizedBox(height: 24),
          _buildSectionHeader(
            title: "Recommended for You",
            icon: Icons.recommend,
            color: Colors.lightBlue,
          ),
          const SizedBox(height: 16),
          _recommendedItems(),

          const SizedBox(height: 24),
          _buildSectionHeader(
            title: "Popular Barter Deals",
            icon: Icons.star,
            color: Colors.amber,
          ),
          const SizedBox(height: 16),
          _popularBarters(),



          const SizedBox(height: 80), // Extra space at bottom
        ],
      ),
    );
  }

  // New Recommended Section
  Widget _recommendedItems() {
    print("printing recommeneded items");
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: recommendedItems.length,
      itemBuilder: (context, index) {
        var item = recommendedItems[index];
        return GestureDetector(
          onTap: () {
            Get.to(() => BarterDetailScreen(item: item));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["title"] ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item["description"] ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item["category"] ?? "",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.purpleAccent,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.purpleAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // New app header with search bar
  Widget _buildAppHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Find Your Perfect Trade",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   decoration: BoxDecoration(
          //     color: Colors.grey[800],
          //     borderRadius: BorderRadius.circular(12),
          //     border: Border.all(color: Colors.grey[700]!),
          //   ),
          //   child: Row(
          //     children: [
          //       Icon(Icons.search, color: Colors.grey[400]),
          //       const SizedBox(width: 12),
          //       Expanded(
          //         child: TextField(
          //           decoration: InputDecoration(
          //             hintText: "Search for items to trade...",
          //             hintStyle: TextStyle(color: Colors.grey[500]),
          //             border: InputBorder.none,
          //             contentPadding: const EdgeInsets.symmetric(vertical: 16),
          //           ),
          //           style: const TextStyle(color: Colors.white),
          //         ),
          //       ),
          //       IconButton(
          //         icon: Icon(Icons.tune, color: Colors.grey[400]),
          //         onPressed: () {},
          //         constraints: const BoxConstraints(),
          //         padding: EdgeInsets.zero,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  // Improved Featured Trades section with CarouselSlider
  Widget _buildFeaturedTrades(BuildContext context) {
    List<Map<String, String>> featuredItems = [
      {
        "title": "iPad Pro for DJI Mini Drone",
        "image": "https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?q=80&w=200"
      },
      {
        "title": "MacBook for Camera Gear",
        "image": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=200"
      },
      {
        "title": "iPhone for Gaming Console",
        "image": "https://images.unsplash.com/photo-1592899677977-9c10ca588bbd?q=80&w=200"
      }
    ];

    return SizedBox(
      height: 220,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 220,
          aspectRatio: 16/9,
          viewportFraction: 0.85,
          enlargeCenterPage: true,
          enableInfiniteScroll: true,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
        ),
        items: featuredItems.map((item) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.deepPurple,
                      Colors.deepPurple.shade800,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gradient overlay over image
                      CachedNetworkImage(
                        imageUrl: item["image"] ?? "",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[900],
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[800],
                          child: const Icon(Icons.shopping_cart, color: Colors.purpleAccent, size: 40),
                        ),
                      ),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              item["title"] ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.deepOrange.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.local_fire_department,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "Featured",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: Text(
            "See All",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // Fixed Popular Barters section with adjusted layout to prevent overflow
  Widget _popularBarters() {
    // More realistic barter items with image URLs
    List<Map<String, String>> barters = [
      {
        "title": "MacBook Pro for DSLR Camera",
        "user": "John Doe",
        "image": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=200",
        "avatar": "https://randomuser.me/api/portraits/men/32.jpg",
        "description": "Looking to trade my MacBook Pro (2022) with M2 chip for a professional DSLR camera with accessories.",
        "offer": "MacBook Pro 2022 (M2, 16GB RAM, 512GB SSD)",
        "request": "Canon EOS or Nikon D850 with lenses",
        "offeredBy": "John Doe"
      },
      {
        "title": "Mountain Bike for AirPods Pro",
        "user": "Alice Smith",
        "image": "https://images.unsplash.com/photo-1485965120184-e220f721d03e?q=80&w=200",
        "avatar": "https://randomuser.me/api/portraits/women/44.jpg",
        "description": "Trading my barely used mountain bike for AirPods Pro. The bike is in excellent condition.",
        "offer": "Trek Mountain Bike (2023 model)",
        "request": "AirPods Pro (2nd generation)",
        "offeredBy": "Alice Smith"
      },
      {
        "title": "iPad Pro for DJI Mini Drone",
        "user": "David Johnson",
        "image": "https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?q=80&w=200",
        "avatar": "https://randomuser.me/api/portraits/men/22.jpg",
        "description": "Would like to trade my iPad Pro for a DJI Mini drone. iPad is in perfect condition with case included.",
        "offer": "iPad Pro 11-inch (2022)",
        "request": "DJI Mini 3 Pro with controller",
        "offeredBy": "David Johnson"
      },
      {
        "title": "Gaming PC for Apple Watch",
        "user": "Michael Lee",
        "image": "https://images.unsplash.com/photo-1593640408182-31c70c8268f5?q=80&w=200",
        "avatar": "https://randomuser.me/api/portraits/men/42.jpg",
        "description": "Trading my custom gaming PC setup for an Apple Watch. PC has RTX 3080 and i9 processor.",
        "offer": "Custom Gaming PC (RTX 3080, i9, 32GB RAM)",
        "request": "Apple Watch Series 8 or newer",
        "offeredBy": "Michael Lee"
      },
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75, // Adjusted aspect ratio to provide more vertical space
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: barters.length,
      itemBuilder: (context, index) {
        var item = barters[index];
        return GestureDetector(
          onTap: () {
            // Navigate to BarterDetailScreen with the selected item
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BarterDetailScreen(item: item),
              ),
            );

            // Alternative navigation using Get if you prefer:
            // Get.to(() => BarterDetailScreen(item: item));
          },
          child: Card(
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                      ),
                      child: CachedNetworkImage(
                        imageUrl: item["image"] ?? "",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[900],
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[800],
                          child: const Icon(Icons.shopping_cart, color: Colors.purpleAccent, size: 40),
                        ),
                      ),
                    ),
                  ),
                ),

                // Content section - simplified with compact layout
                Container(
                  // Fixed height content area to prevent overflow
                  height: 72,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title with limited height
                      SizedBox(
                        height: 36,
                        child: Text(
                          item["title"] ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      // User info row with strict height constraints
                      SizedBox(
                        height: 20, // Fixed height to prevent overflow
                        child: Row(
                          children: [
                            // Avatar with fixed dimensions
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: item["avatar"] ?? "",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[700],
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[700],
                                    child: const Icon(Icons.person, color: Colors.white, size: 14),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item["user"] ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  Widget _tradeCategories(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {
        "icon": Icons.devices,
        "label": "Electronics",
        "color": Colors.blue
      },
      {
        "icon": Icons.pedal_bike,
        "label": "Transport",
        "color": Colors.green
      },
      {
        "icon": Icons.sports_basketball,
        "label": "Sports",
        "color": Colors.orange
      },
      {
        "icon": Icons.palette,
        "label": "Arts",
        "color": Colors.pink
      },
      {
        "icon": Icons.chair,
        "label": "Furniture",
        "color": Colors.amber
      },
      {
        "icon": Icons.work,
        "label": "Jobs",
        "color": Colors.teal
      },
    ];

    return SizedBox(
        height: 120,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (context, index) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            var category = categories[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => CategoryListingsScreen(category: category["label"]));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          category["color"],
                          category["color"].withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: category["color"].withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 80,
                        height: 80,
                        color: Colors.black26,
                        child: Icon(
                          category["icon"],
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category["label"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        );
    }

}