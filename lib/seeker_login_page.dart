import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SeekerLoginPage extends StatefulWidget {
  const SeekerLoginPage({super.key});

  @override
  State<SeekerLoginPage> createState() => _SeekerLoginPageState();
}

class _SeekerLoginPageState extends State<SeekerLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (_) {
      setState(() {
        _errorMessage = 'An unexpected error occurred.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (_) {
      setState(() {
        _errorMessage = 'Google sign-in failed.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildGoogleButton() {
    return OutlinedButton.icon(
      onPressed: _signInWithGoogle,
      icon: Image.asset(
        'assets/google_logo.png',
        height: 24,
        width: 24,
      ),
      label: const Text('Continue with Google'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: const BorderSide(color: Color(0xFF4285F4)),
        textStyle: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool obscure = false,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: const Text('Seeker Login'),
        backgroundColor: const Color(0xFFF4F4F4),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    _buildTextField(
                      label: 'Email',
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Enter email';
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Invalid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Password',
                      controller: _passwordController,
                      obscure: true,
                      validator: (value) => value == null || value.length < 6
                          ? 'Minimum 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1A237E),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    textStyle: const TextStyle(fontSize: 16),
                                  ),
                                  child: const Text('Login'),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildGoogleButton(),
                            ],
                          ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup/seeker');
                      },
                      child: const Text('Don\'t have an account? Sign Up'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF1A237E),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
