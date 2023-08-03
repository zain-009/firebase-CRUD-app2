import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout/auth/forgot_password_page.dart';
import 'package:workout/auth/phone_login_page.dart';
import 'package:workout/views/home_page.dart';
import 'package:workout/views/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> logIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e){
      setState(() {
        isLoading = false;
      });
    }

  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 200,
                    child: SvgPicture.asset('assets/collecting.svg')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style: GoogleFonts.quicksand(
                          fontSize: 34, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.alternate_email), hintText: 'Email'),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.lock_outline), hintText: 'Password'),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordPage()));
                      },
                      child: Text(
                        "Forgot Password?",
                        style: GoogleFonts.quicksand(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: (){
                    logIn();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.blue,
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Center(
                        child: isLoading? CircularProgressIndicator(color: Colors.white,) : Text(
                      "Login",
                      style: GoogleFonts.quicksand(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                        child: Divider(
                      height: 5,
                      thickness: 2,
                      color: Colors.grey,
                      endIndent: 10,
                    )),
                    Text(
                      "Or",
                      style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    const Expanded(
                        child: Divider(
                      height: 5,
                      thickness: 2,
                      color: Colors.grey,
                      indent: 10,
                    )),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const PhoneLoginPage()));},
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[300],
                    ),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, color: Colors.grey[700]),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Login with Phone Number",
                          style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                      ],
                    )),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member? ",
                      style: GoogleFonts.quicksand(
                          //fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700]),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage()));
                      },
                      child: Text(
                        "Register",
                        style: GoogleFonts.quicksand(
                            //fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
