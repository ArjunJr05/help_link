import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hack/login/pages/login.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class MyDrawer extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, String>> _getUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid) // Assuming you store user data by their UID
          .get();

      if (userDoc.exists) {
        String name = userDoc['name'] ?? 'Unknown Name';
        String email = userDoc['email'] ?? user.email ?? 'Unknown Email';
        return {'name': name, 'email': email};
      }
    }

    return {'name': 'Unknown Name', 'email': 'Unknown Email'};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Drawer(
            backgroundColor: HexColor("29292b"),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Drawer(
            backgroundColor: HexColor("29292b"),
            child: Center(child: Text('Error loading user data')),
          );
        }

        var userData = snapshot.data;

        return Drawer(
          backgroundColor: HexColor("29292b"),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 6, 134, 72).withOpacity(0.8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      userData?['name'] ?? 'John Doe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userData?['email'] ?? 'john.doe@example.com',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.person_outline, color: Colors.white),
                title: Text('Profile', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.work_outline, color: Colors.white),
                title: Text('My Tasks', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.star_outline, color: Colors.white),
                title: Text('Saved', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Divider(color: Colors.grey.shade700),
              ListTile(
                leading: Icon(Icons.settings_outlined, color: Colors.white),
                title: Text('Settings', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // Add settings navigation
                },
              ),
              ListTile(
                leading: Icon(Icons.help_outline, color: Colors.white),
                title: Text('Help & Support',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // Add help navigation
                },
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.white),
                title: Text('Logout', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  try {
                    // Attempt to sign out
                    await Supabase.instance.client.auth.signOut();
                    // Navigate to LoginPage after logout
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) =>
                            LoginPage(supabase: Supabase.instance.client),
                      ),
                      (route) => false, // Remove all previous routes
                    );
                  } catch (e) {
                    // Show an error message if logout fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error logging out: ${e.toString()}'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
