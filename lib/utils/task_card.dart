import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String rate;
  final String description;

  const TaskCard({
    Key? key,
    required this.title,
    required this.rate,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive layout
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // You can adjust the card padding and text sizes based on the screen size
    double cardPadding = screenWidth * 0.05; // 5% of screen width for padding
    double textSize = screenWidth * 0.05; // 5% of screen width for text size
    double descriptionSize =
        screenWidth * 0.04; // 4% of screen width for description text size

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: screenWidth / 1.1,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: textSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            rate,
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: textSize * 0.8, // Smaller font size for rate
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey,
              fontSize: descriptionSize,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Divider(color: Colors.grey),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 20, 164, 95),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                        color: Color.fromARGB(255, 2, 119, 35), width: 2),
                  ),
                ),
                onPressed: () {
                  // Handle apply button press
                },
                child: Row(
                  children: const [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Apply',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                        color: Color.fromARGB(255, 20, 164, 95),
                        width: 2), // Border color and width
                  ),
                ),
                onPressed: () {
                  // Handle chat button press
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.chat,
                      color: Color.fromARGB(255, 20, 164, 95),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 20, 164, 95),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
