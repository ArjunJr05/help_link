import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Map<String, dynamic> profileData = {};
  bool isLoading = true;
  bool isEditingLocation = false; // Flag to toggle editing location
  TextEditingController _locationController = TextEditingController();
  TextEditingController _skillController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      // Fetch the current user's UID
      String? userId = auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Fetch the user's profile data
      final docSnapshot = await firestore.collection('users').doc(userId).get();
      if (!docSnapshot.exists) {
        throw Exception('Profile data not found');
      }

      setState(() {
        profileData = docSnapshot.data() ?? {};
        _locationController.text = profileData['location'] ?? '';
        _bioController.text = profileData['bio'] ?? '';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching profile data: $e')),
      );
    }
  }

  Future<void> saveProfileData() async {
    try {
      String? userId = auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Update the user's profile data
      await firestore.collection('users').doc(userId).update({
        'location': _locationController.text,
        'skills': FieldValue.arrayUnion([_skillController.text]),
        'bio': _bioController.text.isNotEmpty
            ? _bioController.text
            : FieldValue.delete(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
      fetchProfileData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile data: $e')),
      );
    }
  }

  void _showAddSkillDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Skill'),
          content: TextField(
            controller: _skillController,
            decoration: InputDecoration(hintText: "Skill"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ADD'),
              onPressed: () {
                if (_skillController.text.isNotEmpty) {
                  saveProfileData();
                  _skillController.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddBioDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Bio'),
          content: TextField(
            controller: _bioController,
            decoration: InputDecoration(hintText: "Bio"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ADD'),
              onPressed: () {
                if (_bioController.text.isNotEmpty) {
                  saveProfileData();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page',
            style: TextStyle(color: Colors.white, fontSize: 30)),
        backgroundColor: const Color.fromARGB(255, 20, 164, 95),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: HexColor("29292b"),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.05),
                        child: Center(
                          child: CircleAvatar(
                            backgroundImage: profileData['avatar_url'] != null
                                ? NetworkImage(profileData['avatar_url'])
                                : AssetImage('assets/profile6.jpeg')
                                    as ImageProvider,
                            radius: screenWidth * 0.18,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Column(
                        children: [
                          Center(
                            child: Text(
                              profileData['name'] ?? 'Name not set',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SizedBox(width: 25),
                                  Expanded(
                                    child: TextField(
                                      controller: _locationController,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 25),
                                      decoration: InputDecoration(
                                        hintText: 'Location',
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                      textAlign: TextAlign.center,
                                      enabled:
                                          isEditingLocation, // Enable text field when editing
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isEditingLocation =
                                            !isEditingLocation; // Toggle editing
                                      });
                                      if (!isEditingLocation) {
                                        saveProfileData(); // Save data when editing is done
                                      }
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color:
                                          Colors.greenAccent.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      buildContainer(
                        context,
                        heightFactor: 0.11,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  profileData['total_size']?.toString() ?? '0',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                Text(
                                  'Total Size',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: const Color.fromARGB(
                                          255, 20, 164, 95),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      profileData['reviews']?.toString() ?? '0',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                    SizedBox(width: 3),
                                    Icon(Icons.star,
                                        color: Colors.amber, size: 18),
                                  ],
                                ),
                                Text(
                                  'Reviews',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: const Color.fromARGB(
                                          255, 20, 164, 95),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      buildContainer(
                        context,
                        heightFactor: 0.12,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 15, top: 10),
                                    child: Text(
                                      'Skills:',
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: const Color.fromARGB(
                                            255, 20, 164, 95),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add,
                                        color: Colors.greenAccent),
                                    onPressed: _showAddSkillDialog,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 10, right: 15),
                                child: (profileData['skills']?.isEmpty ?? true)
                                    ? Center(
                                        child: Text('No skills available',
                                            style:
                                                TextStyle(color: Colors.white)))
                                    : Wrap(
                                        spacing: 8.0,
                                        runSpacing: 4.0,
                                        children: (profileData['skills'] ?? [])
                                            .map<Widget>((tag) => Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.greenAccent
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  child: Text(
                                                    tag,
                                                    style: const TextStyle(
                                                        color:
                                                            Colors.greenAccent,
                                                        fontSize: 16),
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      buildContainer2(
                        context,
                        heightFactor: 0.12,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 15, top: 10),
                                    child: Text(
                                      'Bio:',
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: const Color.fromARGB(
                                            255, 20, 164, 95),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add,
                                        color: Colors.greenAccent),
                                    onPressed: _showAddBioDialog,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 10, right: 15),
                                child: Text(
                                  profileData['bio'] ?? 'No bio available',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildContainer(BuildContext context,
      {required double heightFactor, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withOpacity(0.2),
      ),
      height: MediaQuery.of(context).size.height * heightFactor,
      child: child,
    );
  }

  Widget buildContainer2(BuildContext context,
      {required double heightFactor, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withOpacity(0.2),
      ),
      height: MediaQuery.of(context).size.height * 0.22,
      child: child,
    );
  }
}
