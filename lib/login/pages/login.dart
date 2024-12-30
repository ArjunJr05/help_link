import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hack/login/pages/signup.dart';
import 'package:hack/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.supabase}) : super(key: key);
  final SupabaseClient supabase;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController(); // Add name controller
  bool _obscurePassword = true;
  bool _redirecting = false;
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    widget.supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      }
    });

    _firebaseAuth.authStateChanges().listen((user) {
      if (user != null && !_redirecting) {
        _redirecting = true;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose(); // Dispose name controller
    super.dispose();
  }

  Future<void> _loginAndSaveData() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Sign in with Supabase
        final response = await widget.supabase.auth.signInWithPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // If Supabase authentication is successful
        if (response == null) {
          await _saveUserDataInSupabase();

          if (mounted) {
            _emailController.clear();
            _passwordController.clear();
            _redirecting = true;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          }
        } else {
          // If Supabase fails, try Firebase authentication
          await _signInWithFirebase();
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unexpected error occurred')),
        );
      }
    }
  }

  Future<void> _signInWithFirebase() async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        await _saveUserDataInFirebase();

        if (mounted) {
          _emailController.clear();
          _passwordController.clear();
          _redirecting = true;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        }
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Authentication failed')),
      );
    }
  }

  Future<void> _saveUserDataInSupabase() async {
    try {
      // Save name, email, password to your Supabase database here
      final response = await widget.supabase.from('users').upsert({
        'name': _nameController.text.isNotEmpty
            ? _nameController.text
            : _emailController.text
                .split('@')[0], // Default to email username if name is empty
        'email': _emailController.text,
        'password': _passwordController.text,
      });

      if (response.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data in Supabase')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data')),
      );
    }
  }

  Future<void> _saveUserDataInFirebase() async {
    try {
      // Save name, email, password to Firebase Firestore
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': _nameController.text.isNotEmpty
              ? _nameController.text
              : _emailController.text
                  .split('@')[0], // Default to email username if name is empty
          'email': user.email,
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data in Firebase')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
            painter: MinimalistWavePainter(),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 120),
                Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: Center(
                    child: Text(
                      'Login Page',
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        color: const Color.fromARGB(255, 20, 164, 95),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildTextField(
                    controller: _nameController,
                    label: 'Name',
                    isPassword: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    isPassword: false,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildTextField(
                    controller: _passwordController,
                    label: 'Password',
                    isPassword: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password cannot be empty';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: _loginAndSaveData,
                  child: Text(
                    'Login',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: screenHeight * 0.018,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 20, 164, 95),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: GoogleFonts.poppins(
                        fontSize: screenHeight * 0.018,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      child: Text(
                        'Sign up',
                        style: GoogleFonts.poppins(
                          fontSize: screenHeight * 0.018,
                          color: const Color.fromARGB(255, 20, 164, 95),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) =>
                                SignUpPage(supabase: widget.supabase),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool isPassword,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.white),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.greenAccent),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.greenAccent),
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.greenAccent,
                ),
              )
            : null,
      ),
      validator: validator,
    );
  }
}

class MinimalistWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 20, 164, 95)
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, size.height * 0.15);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.10,
        size.width * 0.5, size.height * 0.15);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.20, size.width, size.height * 0.15);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);

    final secondPaint = Paint()..color = Colors.greenAccent.withOpacity(0.2);
    final secondPath = Path();
    secondPath.moveTo(0, size.height * 0.18);
    secondPath.quadraticBezierTo(size.width * 0.25, size.height * 0.13,
        size.width * 0.5, size.height * 0.18);
    secondPath.quadraticBezierTo(
        size.width * 0.75, size.height * 0.23, size.width, size.height * 0.18);
    secondPath.lineTo(size.width, 0);
    secondPath.lineTo(0, 0);
    secondPath.close();

    canvas.drawPath(secondPath, secondPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
