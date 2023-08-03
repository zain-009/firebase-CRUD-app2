import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool isLoading = false;

  Future passwordReset() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim());
      setState(() {
        isLoading = false;
      });
      showDialog(
          context: context, builder: (context) {
        return const AlertDialog(
          content: Text("Password reset link sent!"),
        );
      }
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(
          context: context, builder: (context) {
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      }
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
          color: Colors.grey[700],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 200,
                    child: SvgPicture.asset('assets/forgot_password.svg')
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Forgot\nPassword?",
                      style: GoogleFonts.quicksand(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Don\'t worry, Please enter the address associated with your account",
                  style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500]),),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.alternate_email),
                      hintText: 'Email'),
                ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    passwordReset();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.blue,
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Center(
                        child: isLoading? const CircularProgressIndicator(color: Colors.white,) : Text(
                          "Submit",
                          style: GoogleFonts.quicksand(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

