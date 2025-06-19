import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<String> hostelTypes = [
    'Single Person Space',
    'Two People Space',
    'Hostel Rooms',
  ];
  String selectedHostelType = 'Single Person Space';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shadowColor: const Color.fromARGB(221, 255, 255, 255),
        title: const Text(
          "Find your cozy zone",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Color.fromARGB(255, 24, 24, 24),
            fontSize: 16,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Select Hostel Type',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedHostelType,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedHostelType = newValue;
                    });
                  }
                },
                items:
                    hostelTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 11, 11, 11),
                ),
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                underline: Container(
                  height: 1,
                  color: const Color.fromARGB(255, 5, 35, 87),
                ),
              ),
              const SizedBox(height: 30),

              // ✅ Fixed image widget
              Image.asset(
                "assets/singlehome.png",
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/available_hostels');
                },
                icon: const Icon(Icons.search),
                label: const Text('View Available Hostels'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 6, 6, 103),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
