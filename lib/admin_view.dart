import 'package:flutter/material.dart';

class ViewBookingsPage extends StatelessWidget {
  final List<String> bookings = const ['Booking 1', 'Booking 2', 'Booking 3'];
  const ViewBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 255, 255, 255), // Deep green app bar
        shadowColor: const Color.fromARGB(221, 255, 255, 255),
        title: const Text(
          "Your active reservations",
          style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Color.fromARGB(255, 24, 24, 24),
              fontSize: 16),
        ),
      ),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 5,
            child: ListTile(
              leading: Image.asset(
                'assets/3.jpg', // Path to your asset
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              title: Text(bookings[index]),
              subtitle: Text('Details of Booking ${index + 1}'),
            ),
          );
        },
      ),
    );
  }
}
