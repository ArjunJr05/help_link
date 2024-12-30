import 'package:flutter/material.dart';

class TrackCard extends StatefulWidget {
  final String name;
  final String city;
  final String cost;
  final double rating;
  final List<String> tags;
  final String profileImage;
  final VoidCallback onReject;
  final VoidCallback onAccept;
  final bool showSlider;

  const TrackCard({
    Key? key,
    required this.name,
    required this.city,
    required this.cost,
    required this.rating,
    required this.tags,
    required this.profileImage,
    required this.onReject,
    required this.onAccept,
    required this.showSlider,
  }) : super(key: key);

  @override
  _TrackCardState createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  double _sliderValue = 0.5; // Start in the middle (Working)

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double textSize = screenWidth * 0.035;

    return Container(
      height: 370,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: screenWidth * 0.08,
                backgroundColor: Colors.grey[800],
                backgroundImage: AssetImage(widget.profileImage),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: textSize * 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.city,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: textSize,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Cost: ${widget.cost}',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: textSize,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rating: ${widget.rating.toStringAsFixed(1)}',
                    style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: textSize,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: widget.tags
                .map(
                  (tag) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenWidth * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: textSize * 0.9,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.grey),
          const SizedBox(height: 10),
          if (widget.showSlider)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status:',
                  style: TextStyle(color: Colors.white, fontSize: textSize),
                ),
                Slider(
                  value: _sliderValue,
                  min: 0,
                  max: 2,
                  divisions: 2,
                  label: getStatusLabel(_sliderValue),
                  onChanged: (double value) {
                    setState(() {
                      _sliderValue = value;
                    });
                  },
                  activeColor: Colors.greenAccent,
                  inactiveColor: Colors.grey,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        getStatusLabel(_sliderValue),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30, // Font size of 50 for the status labels
                        ),
                      ),
                      SizedBox(width: 170),
                      if (_sliderValue ==
                          2) // Show "Pay" when status is "Completed"
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 20, 164, 95),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Pay',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 10),
          if (!widget.showSlider)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Reset slider to 'Accepted' state after pressing 'Accept'
                    setState(() {
                      _sliderValue = 0; // Reset to Accepted
                    });
                    widget.onAccept();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 20, 164, 95),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                          color: Color.fromARGB(255, 0, 156, 44), width: 2),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.check, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Accept',
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
                  onPressed: widget.onReject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                          color: Color.fromARGB(255, 20, 164, 95), width: 2),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.close,
                          color: Color.fromARGB(255, 20, 164, 95)),
                      SizedBox(width: 8),
                      Text(
                        'Reject',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 20, 164, 95),
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String getStatusLabel(double value) {
    if (value == 0) {
      return 'Accepted';
    } else if (value == 1) {
      return 'Working';
    } else {
      return 'Completed';
    }
  }
}
