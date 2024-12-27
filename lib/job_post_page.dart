// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'job_post_bloc.dart';

class JobPostPage extends StatefulWidget {
  @override
  _JobPostPageState createState() => _JobPostPageState();
}

class _JobPostPageState extends State<JobPostPage> {
  final JobPostBloc _bloc = JobPostBloc();
  String _selectedLocation = "Any Location";
  String _selectedJobTitle = "Select";
  String _selectedWorkingDays = "Select";
  TextEditingController _tempWorkingDaysController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _otherJobTitleController = TextEditingController();

  @override
  void dispose() {
    _bloc.dispose();
    _tempWorkingDaysController.dispose();
    _descriptionController.dispose();
    _otherJobTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 242, 242),
      appBar: AppBar(
        actions: [],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(5.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                  width: 300,
                  child: DropdownButton<String>(
                    value: _selectedLocation,
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLocation = newValue!;
                        _bloc.updateLocation(_selectedLocation);
                      });
                    },
                    items: <String>['Any Location', 'Nearby Location']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Job Title Section
            Text.rich(
              TextSpan(
                text: "Job Title ",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                children: [
                  TextSpan(
                    text: "*",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            DropdownButton<String>(
              value: _selectedJobTitle,
              isExpanded: true,
              hint: Text('Select Job Title'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedJobTitle = newValue!;
                  if (newValue != "Others") {
                    _bloc.updateJobTitle(newValue);
                    _otherJobTitleController.clear();
                  }
                });
              },
              items: <String>[
                'Select',
                'Cooking',
                'Plumber',
                'Electrician',
                'Cleaning',
                'Driver',
                'Others'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            // Custom Job Title TextField
            if (_selectedJobTitle == "Others") ...[
              SizedBox(height: 10),
              TextField(
                controller: _otherJobTitleController,
                onChanged: (value) {
                  _bloc.updateJobTitle(value);
                },
                decoration: InputDecoration(
                  hintText: 'Enter custom job title',
                  border: OutlineInputBorder(),
                ),
              ),
            ],

            SizedBox(height: 20),

            // Location Section
            Text.rich(
              TextSpan(
                text: "Location ",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                children: [
                  TextSpan(
                    text: "*",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            TextField(
              onChanged: _bloc.updateLocation,
              decoration: InputDecoration(
                hintText: 'Enter location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Working Days Section
            Text.rich(
              TextSpan(
                text: "Working Days ",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                children: [
                  TextSpan(
                    text: "*",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            DropdownButton<String>(
              value: _selectedWorkingDays,
              isExpanded: true,
              hint: Text('Select Working Days'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedWorkingDays = newValue!;
                  _bloc.updateWorkingDays(_selectedWorkingDays);
                  if (newValue != 'Temporary') {
                    _tempWorkingDaysController.clear();
                  }
                });
              },
              items: <String>['Select', 'Permanent', 'Temporary']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Temporary Working Days Section
            if (_selectedWorkingDays == "Temporary")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: "Number of Temporary Working Days ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                      children: [
                        TextSpan(
                          text: "*",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    controller: _tempWorkingDaysController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _bloc.updateTempWorkingDays(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter number of days',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),

            // Salary Section
            Text.rich(
              TextSpan(
                text: "Salary per Day ",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                children: [
                  TextSpan(
                    text: "*",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: _bloc.updateSalary,
              decoration: InputDecoration(
                hintText: 'Enter salary',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Description Section
            Text.rich(
              TextSpan(
                text: "Description",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                children: [
                  TextSpan(
                    text: "*",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            TextField(
              controller: _descriptionController,
              onChanged: _bloc.updateDescription,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Banner Section
            Text.rich(
              TextSpan(
                text: "Banner",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                children: [
                  TextSpan(
                    text: "*",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.blue[50],
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.generating_tokens,
                    color: Colors.blue,
                    size: 30,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Generate Banner',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Submit Button
            StreamBuilder<bool>(
              stream: _bloc.isFormValid,
              initialData: false,
              builder: (context, snapshot) {
                return ElevatedButton(
                  onPressed: snapshot.data == true
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Job posted successfully!")),
                          );
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return states.contains(MaterialState.disabled)
                            ? Colors.grey
                            : Theme.of(context).primaryColor;
                      },
                    ),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 15.0)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: Text(
                    "Post Job",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
