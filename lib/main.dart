import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hack/login/pages/login.dart';
import 'package:hack/screen/homepage.dart';
import 'package:hack/screen/profile.dart';
import 'package:hack/screen/request.dart';
import 'package:hack/screen/track.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; // Ensure this file is properly generated

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://spictfyolvdayfqrnzpz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNwaWN0ZnlvbHZkYXlmcXJuenB6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUyNTM5MTEsImV4cCI6MjA1MDgyOTkxMX0.j_hEbJdcVx5SqjGKLGNMv-iuetJ7n6YMhuF02vdQmCk',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the initialized Supabase client
    final supabaseClient = Supabase.instance.client;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(
          supabase: supabaseClient), // Pass Supabase client to LoginPage
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // List of pages to navigate between
  final List<Widget> _pages = const [
    HomePage(),
    RequestPage(),
    TrackPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("29292b"),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: HexColor("29292b"),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 10,
              ),
            ],
          ),
          child: GNav(
            gap: 8,
            activeColor: Colors.white,
            color: Colors.grey,
            iconSize: 24,
            backgroundColor: HexColor("29292b"),
            tabBackgroundColor: Colors.greenAccent.withOpacity(0.2),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.request_page,
                text: 'Request',
              ),
              GButton(
                icon: Icons.track_changes,
                text: 'Track',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
