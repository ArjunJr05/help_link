import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String profileImage; // Path to profile image
  final String name; // User name
  final String description; // Description text
  final String price; // Price

  const PostCard({
    super.key,
    required this.profileImage,
    required this.name,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 200, // Adjust height to accommodate all elements
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(profileImage), // Use parameter
              ),
              SizedBox(width: 10),
              Text(
                name, // Use parameter
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            description, // Use parameter
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Spacer(), // Pushes the price to the right
              Text(
                price, // Use parameter
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
