import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:workout/views/login_page.dart';
import 'package:workout/views/phone_verification_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  bool phoneNumberExists = true;
  bool isLoading = false;
  var phoneNumber = "";

  Future emailPasswordReset() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.grey[700],
        content: Center(
          child: Text(
            "Password reset link sent!",
            style: GoogleFonts.quicksand(
                fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        duration: const Duration(seconds: 2),
      ));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } on FirebaseAuthException catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.grey[700],
            content: Center(
              child: Text(
                "Invalid Email",
                style: GoogleFonts.quicksand(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            duration: const Duration(seconds: 2),
          ));
        }
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future <void> phoneNumberCheck () async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "$phoneNumber@gmail.com", password: "x");
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          setState(() {
            phoneNumberExists = false;
          });
        }
        if(e.code == 'wrong-password') {
          setState(() {
            phoneNumberExists = true;
          });
        }
      }
    }
  }

  Future<void> checkField () async {
    if(_emailController.text.isNotEmpty && _phoneNumberController.text.isEmpty) {
      emailPasswordReset();
    } else if(_phoneNumberController.text.isNotEmpty && _emailController.text.isEmpty) {
      setState(() {
        isLoading = true;
      });
      await phoneNumberCheck();
      if (phoneNumberExists == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.grey[700],
          content:
          Center(
            child: Text("Incorrect Phone Number!", style: GoogleFonts.quicksand(
                fontSize: 14, fontWeight: FontWeight.bold),
            ),),
          duration: const Duration(seconds: 2),
        ));
        setState(() {
          isLoading = false;
        });
      }
      if (phoneNumberExists == true){
        setState(() {
          isLoading = true;
        });
        try {
          FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: phoneNumber,
              verificationCompleted: (_) {},
              verificationFailed: (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(e.toString()),
                  duration: const Duration(seconds: 2),
                ));
              },
              codeSent: (String verificationId, int? token){
                setState(() {
                  isLoading = false;
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneVerificationPage(verificationId: verificationId,phoneNumber: phoneNumber,fromPhonePasswordReset: true,)));
              },
              codeAutoRetrievalTimeout: (_){}
          );
        } catch (e) {
          setState(() {
            isLoading = false;
          });
        }
        setState(() {
          isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.grey[700],
        content: Center(
          child: Text(
            "Please fill out one field only!",
            style: GoogleFonts.quicksand(
                fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        duration: const Duration(seconds: 2),
      ));
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
                    child: SvgPicture.asset('assets/forgot_password.svg')),
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
                  "Don\'t worry, Please enter the details associated with your account",
                  style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500]),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _emailController,
                  onFieldSubmitted: (_){_phoneNumberController.clear();},
                  decoration: const InputDecoration(
                      icon: Icon(Icons.alternate_email), hintText: 'Email'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                        child: Divider(
                      indent: 60,
                      height: 5,
                      thickness: 2,
                      color: Colors.black,
                      endIndent: 10,
                    )),
                    Text(
                      "Or",
                      style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const Expanded(
                        child: Divider(
                      endIndent: 60,
                      height: 5,
                      thickness: 2,
                      color: Colors.black,
                      indent: 10,
                    )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                IntlPhoneField(
                  controller: _phoneNumberController,
                  disableLengthCheck: true,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    hintText: 'Phone Number',
                    labelText: null,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode: 'PK',
                  onChanged: (phone) {
                    phoneNumber = phone.completeNumber;
                  },
                  onSubmitted: (_){_emailController.clear();},
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    checkField();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.blue,
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
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
