import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart'; // Import the package
import 'package:hack/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Method to get the content for each tab
  Widget _getContentForSelectedTab() {
    switch (_selectedIndex) {
      case 0:
        return _buildTabContent(Icons.home, 'Home');
      case 1:
        return _buildTabContent(Icons.task, 'Tasks');
      case 2:
        return _buildTabContent(Icons.notifications, 'Notifications');
      case 3:
        return _buildTabContent(Icons.settings, 'Settings');
      default:
        return _buildTabContent(Icons.home, 'Home');
    }
  }

  // Method to build the content for each tab
  Widget _buildTabContent(IconData icon, String title) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 30, color: Colors.blue),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/background.png'), // Add your image path here
              fit: BoxFit.cover, // Adjust the image to cover the screen
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 60), // Optional spacing
              Row(
                children: [
                  SizedBox(width: 30),
                  Text(
                    "MyTask",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 100),
                  Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(child: Text("+ Add task")),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Container(
                    color: const Color.fromARGB(255, 235, 234, 234),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 21),
                            PostCard(
                              profileImage:
                                  'assets/profile1.jpeg', // Pass image path
                              name: 'vicky', // Pass user name
                              description:
                                  'This is a sample description of the post.', // Pass description
                              price: '\₹49.99', // Pass price
                            ),
                            SizedBox(height: 20),
                            PostCard(
                              profileImage: 'assets/profile1.jpeg',
                              name: 'shiva',
                              description:
                                  'This is a sample description of the post.',
                              price: '\₹49.99',
                            ),
                            SizedBox(height: 20),
                            PostCard(
                              profileImage: 'assets/profile1.jpeg',
                              name: 'sarathy',
                              description:
                                  'This is a sample description of the post.',
                              price: '\₹49.99',
                            ),
                            SizedBox(height: 20),
                            PostCard(
                              profileImage: 'assets/profile1.jpeg',
                              name: 'arjun',
                              description:
                                  'This is a sample description of the post.',
                              price: '\₹49.99',
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 80, // Set the height of the bottom navigation bar
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/background.png'), // Replace with your image asset
              fit: BoxFit.cover, // Adjust image to cover the area
            ),
          ),
          child: GNav(
            gap: 12, // Adjusts the gap between icons
            activeColor: Colors
                .white, // Active icon color (make icon white when selected)
            iconSize: 24, // Icon size
            padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15), // Adjust vertical padding to control height
            onTabChange: _onItemTapped, // Handle tab change
            backgroundColor:
                Colors.transparent, // Make background transparent to show image
            color: Colors.white, // Icon color when not selected
            tabBackgroundColor:
                Colors.blue.shade800, // Background color of selected tab
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ), // Text style for selected tab
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.task,
                text: 'Tasks',
              ),
              GButton(
                icon: Icons.notifications,
                text: 'Notifications',
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
              ),
            ],
          ),
        ));
  }
}
