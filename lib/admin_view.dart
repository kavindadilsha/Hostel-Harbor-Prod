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
                .where('ownerId', isEqualTo: ownerId)
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, reservationSnapshot) {
              if (reservationSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!reservationSnapshot.hasData ||
                  reservationSnapshot.data!.docs.isEmpty) {
                print('Current Owner UID: $ownerId');

                return const Center(child: Text('No reservations found.'));
              }

              final reservations = reservationSnapshot.data!.docs;

              return ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final data =
                      reservations[index].data() as Map<String, dynamic>;

                  return Card(
                    margin: const EdgeInsets.all(10),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/3.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      title: Text(data['seekerName'] ?? 'Seeker'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Address: ${data['placeAddress'] ?? 'N/A'}"),
                          Text("Payment: ${data['paymentMethod'] ?? 'N/A'}"),
                          Text(
                              "Seeker Contact: ${data['seekerEmail'] ?? 'N/A'}"),
                          Text("Amount: ${data['amount'] ?? 'N/A'} LKR"),
                          const SizedBox(height: 4),
                          Text(
                            data['createdAt'] != null
                                ? 'Date: ${(data['createdAt'] as Timestamp).toDate()}'
                                : '',
                            style: const TextStyle(fontSize: 12),
                          ),
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
