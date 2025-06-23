import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewBookingsPage extends StatelessWidget {
  const ViewBookingsPage({super.key});

  Future<String?> getCurrentOwnerId() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shadowColor: const Color.fromARGB(221, 255, 255, 255),
        title: const Text(
          "Your active reservations",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Color.fromARGB(255, 24, 24, 24),
            fontSize: 16,
          ),
        ),
      ),
      body: FutureBuilder<String?>(
        future: getCurrentOwnerId(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final ownerId = snapshot.data;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('reservations')
                .where('placeData.ownerId', isEqualTo: ownerId)
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, reservationSnapshot) {
              if (reservationSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!reservationSnapshot.hasData ||
                  reservationSnapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No reservations found.'));
              }

              final reservations = reservationSnapshot.data!.docs;

              return ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final data =
                      reservations[index].data() as Map<String, dynamic>;

                  final seekerName = data['seekerName'] ?? 'Unknown';
                  final seekerEmail = data['seekerEmail'] ?? 'No Email';
                  final seekerPhone = data['seekerPhone'] ?? 'No Phone';
                  final paymentMethod = data['paymentMethod'] ?? 'N/A';
                  final amount = data['amount'] ?? 'N/A';
                  final place = data['placeData'] ?? {};
                  // ignore: unused_local_variable
                  final address = place['address'] ?? 'N/A';
                  final timestamp = data['createdAt'];
                  final date = timestamp is Timestamp
                      ? timestamp.toDate().toString().split('.')[0]
                      : 'N/A';

                  return Card(
                    margin: const EdgeInsets.all(10),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/3.jpg',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      title: Text(seekerName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email: $seekerEmail"),
                          Text("Phone: $seekerPhone"),
                          Text("Payment: $paymentMethod"),
                          Text("Amount: Rs. $amount"),
                          Text("Reserved At: $date"),
                        ],
                      ),
                      isThreeLine: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
