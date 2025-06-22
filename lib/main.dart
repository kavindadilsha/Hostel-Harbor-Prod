import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/add_place_page.dart';
import 'package:flutter_application_2/admin.dart';
import 'package:flutter_application_2/admin_login_page.dart';
import 'package:flutter_application_2/admin_manage.dart';
import 'package:flutter_application_2/admin_signup_page.dart';
import 'package:flutter_application_2/admin_view.dart';
import 'package:flutter_application_2/hostels.dart';
import 'package:flutter_application_2/seeker.dart';
import 'package:flutter_application_2/seeker_login_page.dart';
import 'package:flutter_application_2/seeker_signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAPyM7hFpNLQ1ScWOJbKRCkJAGFYBfebjc",
            authDomain: "hostelharborapp-13bb0.firebaseapp.com",
            projectId: "hostelharborapp-13bb0",
            storageBucket: "hostelharborapp-13bb0.firebasestorage.app",
            messagingSenderId: "64194359384",
            appId: "1:64194359384:web:0d0546621c18b55569da2d"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const HostelHarborApp());
}

class HostelHarborApp extends StatelessWidget {
  const HostelHarborApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hostel Harbor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
          secondary: Colors.amber,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/admin': (context) => const AdminHomePage(),
        '/available_hostels': (context) => const AvailableHostelsPage(),
        // '/payment' route removed since PaymentPage needs arguments
        '/admin/hostels': (context) => const ManageHostelsPage(),
        '/admin/bookings': (context) => const ViewBookingsPage(),
        '/admin/add-place': (context) => const AddPlacePage(),
        '/login/seeker': (context) => const SeekerLoginPage(),
        '/signup/seeker': (context) => const SeekerSignupPage(),
        '/login/admin': (context) => const AdminLoginPage(),
        '/signup/admin': (context) => const AdminSignupPage(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool isAdmin = false;

  void _toggleUserType() {
    setState(() {
      isAdmin = !isAdmin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 5, 35, 87),
          shadowColor: Colors.black87,
          title: const Text(
            "Good Morning Kavinda",
            style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontSize: 16),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/bg.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 2),
                    Image.asset(
                      "assets/logo.png",
                      width: 200,
                      height: 150,
                    ),
                    const SizedBox(height: 5),
                    Image.asset(
                      "assets/lottie2.png",
                      width: 250,
                      height: 250,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      isAdmin ? 'I am a house owner' : 'I am a seeker',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 56, 56, 56),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 255, 255, 255),
                            Color.fromARGB(255, 255, 255, 255),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _toggleUserType,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.swap_horiz, color: Colors.white),
                        label: Text(
                          isAdmin
                              ? 'No, I want to find a place'
                              : 'No, I need to add my place',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 43, 43, 43)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 76, 84, 175),
                            Color.fromARGB(255, 0, 0, 0),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context,
                              isAdmin ? '/login/admin' : '/login/seeker');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.login, color: Colors.white),
                        label: const Text('Get Started Now',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
