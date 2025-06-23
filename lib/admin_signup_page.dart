import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AdminSignupPage extends StatefulWidget {
  const AdminSignupPage({super.key});

  @override
  State<AdminSignupPage> createState() => _AdminSignupPageState();
}

class _AdminSignupPageState extends State<AdminSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': 'admin',
      });

      Navigator.pushReplacementNamed(context, '/login/admin');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Unexpected error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signUpWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication auth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );

      final userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCred.user!.uid)
          .get();

      if (!doc.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCred.user!.uid)
            .set({
          'name': userCred.user!.displayName ?? '',
          'email': userCred.user!.email ?? '',
          'role': 'admin',
        });
      }

      Navigator.pushReplacementNamed(context, '/admin');
    } catch (e) {
      setState(() {
        _errorMessage = 'Google sign-up failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool obscure = false,
    TextInputType inputType = TextInputType.text,
  }) =>
      TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: inputType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F1F1),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Admin Signup',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  _buildInputField(
                    label: 'Full Name',
                    controller: _nameController,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter your name' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    label: 'Email',
                    controller: _emailController,
                    inputType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter email';
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(v)) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    label: 'Password',
                    controller: _passwordController,
                    obscure: true,
                    validator: (v) =>
                        v == null || v.length < 6 ? 'Min 6 characters' : null,
                  ),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _signUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A237E),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Sign Up',
                                style: TextStyle(fontSize: 16)),
                          ),
                        ),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('OR'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : _signUpWithGoogle,
                      icon: Image.asset('assets/google_logo.png', height: 20),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text('Sign Up with Google',
                            style: TextStyle(fontSize: 16)),
                      ),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: const BorderSide(color: Color(0xFF4285F4)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/login/admin'),
                    child: const Text('Already have an account? Log In'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
