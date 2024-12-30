import 'package:flutter/material.dart';
import 'package:hack/utils/track_card.dart';

class TrackPage extends StatefulWidget {
  const TrackPage({super.key});

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  late List<TrackData> profiles;

  @override
  void initState() {
    super.initState();
    profiles = _getProfiles();
  }

  List<TrackData> _getProfiles() {
    return [
      TrackData(
        name: "Vijay Kumar",
        city: "Puducherry, India",
        cost: "₹500/day",
        rating: 4.8,
        tags: [
          "Plumbing",
          "Pipe Fitting",
          "Water Heater",
          "Bathroom Repair",
          "Emergency Service"
        ],
        profileImage: "assets/profile2.jpeg",
      ),
      TrackData(
        name: "Shiva Prasad",
        city: "Puducherry, India",
        cost: "₹600/day",
        rating: 4.6,
        tags: [
          "Carpentry",
          "Furniture Making",
          "Wood Work",
          "Cabinet Installation",
          "Custom Design"
        ],
        profileImage: "assets/profile5.jpeg",
      ),
      TrackData(
        name: "Sarathy M",
        city: "Puducherry, India",
        cost: "₹450/day",
        rating: 4.3,
        tags: [
          "Electrical",
          "Wiring",
          "Fan Installation",
          "LED Lighting",
          "Circuit Repair"
        ],
        profileImage: "assets/profile4.jpeg",
      ),
      TrackData(
        name: "Bala Krishnan",
        city: "Puducherry, India",
        cost: "₹400/day",
        rating: 4.5,
        tags: [
          "Painting",
          "Wall Finishing",
          "Waterproofing",
          "Interior",
          "Exterior"
        ],
        profileImage: "assets/profile1.jpeg",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Applied',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 20, 164, 95),
      ),
      backgroundColor: const Color(0xFF121212),
      body: profiles.isNotEmpty
          ? SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: profiles
                    .map(
                      (profile) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TrackCard(
                          name: profile.name,
                          city: profile.city,
                          cost: profile.cost,
                          rating: profile.rating,
                          tags: profile.tags,
                          profileImage: profile.profileImage,
                          onReject: () {
                            setState(() {
                              profiles.remove(profile);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Rejected ${profile.name}")),
                            );
                          },
                          onAccept: () {
                            setState(() {
                              profile.showSlider = true;
                            });
                          },
                          showSlider: profile.showSlider,
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
          : const Center(
              child: Text(
                'No profiles available',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
    );
  }
}

class TrackData {
  final String name;
  final String city;
  final String cost;
  final double rating;
  final List<String> tags;
  final String profileImage;
  bool showSlider;

  TrackData({
    required this.name,
    required this.city,
    required this.cost,
    required this.rating,
    required this.tags,
    required this.profileImage,
    this.showSlider = false,
  });
}
