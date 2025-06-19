import 'package:flutter/material.dart';

class AvailableHostelsPage extends StatelessWidget {
  const AvailableHostelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 255, 255, 255), // Deep green app bar
        shadowColor: const Color.fromARGB(221, 255, 255, 255),
        title: const Text(
          "Reserve your preferred stay",
          style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Color.fromARGB(255, 24, 24, 24),
              fontSize: 16),
        ),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 5,
            child: ListTile(
              //leading: const Icon(Icons.home,
              //    size: 40, color: Color.fromARGB(255, 32, 47, 2)),

              title: Text('Hostel ${index + 1}'),
              subtitle: Text('Description of Hostel ${index + 1}'),
              trailing: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/payment');
                },
                icon: const Icon(Icons.payment),
                label: const Text('Reserve Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 10, 10, 87),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
