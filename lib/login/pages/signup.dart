import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hack/login/pages/login.dart';
import 'package:hack/main.dart';
import 'package:supabase/supabase.dart';

class SignUpPage extends StatefulWidget {
  final SupabaseClient supabase;

  const SignUpPage({Key? key, required this.supabase}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
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
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate() &&
        _passwordController.text == _confirmPasswordController.text) {
      try {
        final supabaseRes = await widget.supabase.auth.signUp(
          email: _emailController.text,
          password: _passwordController.text,
          data: {'full_name': _nameController.text},
        );

        if (supabaseRes.user != null) {
          UserCredential firebaseUserCredential =
              await _firebaseAuth.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );

          final user = firebaseUserCredential.user;

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .set({
            'name': _nameController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
            'uid': user.uid,
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sign up successful!')),
            );
            _emailController.clear();
            _passwordController.clear();
            _confirmPasswordController.clear();
            _nameController.clear();
            _redirecting = true;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MainPage()),
            );
          }
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.grey[850],
        body: SingleChildScrollView(
          child: Stack(
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
                          'Sign Up',
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
                        obscureText: _obscurePassword,
                        toggleObscureText: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        isPassword: true,
                        obscureText: _obscureConfirmPassword,
                        toggleObscureText: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: _signUp,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 20, 164, 95),
                        ),
                      ),
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: screenHeight * 0.018,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: GoogleFonts.poppins(
                            fontSize: screenHeight * 0.018,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    LoginPage(supabase: widget.supabase),
                              ),
                            );
                          },
                          child: Text(
                            'Login',
                            style: GoogleFonts.poppins(
                              fontSize: screenHeight * 0.018,
                              color: const Color.fromARGB(255, 20, 164, 95),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool isPassword,
    bool obscureText = false,
    VoidCallback? toggleObscureText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? obscureText : false,
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
                onPressed: toggleObscureText,
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
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
