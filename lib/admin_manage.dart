import 'package:flutter/material.dart';

class ManageHostelsPage extends StatefulWidget {
  const ManageHostelsPage({super.key});

  @override
  ManageHostelsPageState createState() => ManageHostelsPageState();
}

class ManageHostelsPageState extends State<ManageHostelsPage> {
  final List<String> hostels = ['Hostel 1', 'Hostel 2', 'Hostel 3'];
  final TextEditingController _hostelController = TextEditingController();

  void _addHostel() {
    if (_hostelController.text.isNotEmpty) {
      setState(() {
        hostels.add(_hostelController.text);
        _hostelController.clear();
      });
    }
  }

  void _removeHostel(int index) {
    setState(() {
      hostels.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 255, 255, 255), // Deep green app bar
        shadowColor: const Color.fromARGB(221, 255, 255, 255),
        title: const Text(
          "Add new places",
          style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Color.fromARGB(255, 24, 24, 24),
              fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/addnew.png", // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            TextField(
              controller: _hostelController,
              decoration: const InputDecoration(
                labelText: 'Enter Place Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _addHostel,
              icon: const Icon(Icons.add),
              label: const Text('Save Place Details'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 10, 10, 87),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: hostels.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(hostels[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeHostel(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
