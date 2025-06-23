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
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        title: const Text(
          "Your Active Reservations",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
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
                return const Center(
                  child: Text(
                    'No reservations found.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              final reservations = reservationSnapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final data =
                      reservations[index].data() as Map<String, dynamic>;

                  final seekerName = data['seekerName'] ?? 'Unknown';
                  final seekerEmail = data['seekerEmail'] ?? 'No Email';
                  final seekerPhone = data['seekerPhone'] ?? 'No Phone';
                  final paymentMethod = data['paymentMethod'] ?? 'N/A';
                  final amount = data['amount'] ?? 'N/A';
                  final timestamp = data['createdAt'];
                  final date = timestamp is Timestamp
                      ? timestamp.toDate().toString().split('.')[0]
                      : 'N/A';

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/3.jpg',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  seekerName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text("Email: $seekerEmail"),
                                Text("Phone: $seekerPhone"),
                                Text("Payment: $paymentMethod"),
                                Text("Amount: Rs. $amount"),
                                Text("Reserved At: $date"),
                              ],
                            ),
                          ),
                        ],
                      ),
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
