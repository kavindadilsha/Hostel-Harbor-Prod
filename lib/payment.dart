import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/seeker.dart';

class PaymentPage extends StatefulWidget {
  final String placeId;
  final Map<String, dynamic> placeData;

  const PaymentPage(
      {super.key, required this.placeId, required this.placeData});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _paypalEmailController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _bankRoutingController = TextEditingController();

  String selectedPaymentMethod = 'Credit Card';
  bool _isProcessing = false;

  Future<void> _makePayment() async {
    setState(() => _isProcessing = true);

    try {
      await FirebaseFirestore.instance.collection('reservations').add({
        'placeId': widget.placeId,
        'placeData': widget.placeData,
        'paymentMethod': selectedPaymentMethod,
        'seekerId': FirebaseAuth.instance.currentUser!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Reservation Confirmed'),
          content: const Text(
              'Your payment has been simulated and the reservation was successful.\n\nThank you for choosing Hostel Harbor.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const HomePage()));
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildPaymentSection() {
    switch (selectedPaymentMethod) {
      case 'Credit Card':
        return Column(
          children: [
            _buildInputField(
              label: 'Card Number',
              controller: _cardNumberController,
              inputType: TextInputType.number,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: 'Expiry Date (MM/YY)',
                    controller: _expiryDateController,
                    inputType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    label: 'CVV',
                    controller: _cvvController,
                    inputType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        );
      case 'PayPal':
        return _buildInputField(
          label: 'PayPal Email',
          controller: _paypalEmailController,
          inputType: TextInputType.emailAddress,
        );
      case 'Bank Transfer':
        return Column(
          children: [
            _buildInputField(
              label: 'Bank Account Number',
              controller: _bankAccountController,
              inputType: TextInputType.number,
            ),
            _buildInputField(
              label: 'Bank Routing Number',
              controller: _bankRoutingController,
              inputType: TextInputType.number,
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Payment Method',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...['Credit Card', 'PayPal', 'Bank Transfer'].map((method) {
                return RadioListTile<String>(
                  title: Text(method),
                  value: method,
                  groupValue: selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value!;
                    });
                  },
                );
              }).toList(),
              const SizedBox(height: 24),
              const Text(
                'Enter Payment Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildPaymentSection(),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _makePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: _isProcessing
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Confirm & Pay'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
