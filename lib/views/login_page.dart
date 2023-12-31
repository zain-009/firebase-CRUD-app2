import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout/views/forgot_password_page.dart';
import 'package:workout/views/phone_password_reset_page.dart';
import 'package:workout/views/phone_register_page.dart';
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
  bool isVisible = true;
  bool isLoading = false;

  Future<void> logIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential credential =  await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: checkEmail()!,
          password: _passwordController.text.trim());
      User? user = credential.user;
      setState(() {
        isLoading = false;
      });
      if (user != null) {
        if (user.emailVerified) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.grey[700],
            content:
            Center(child: Text("Account not Verified",style: GoogleFonts.quicksand(
                fontSize: 14, fontWeight: FontWeight.bold),
            ),),
            duration: const Duration(seconds: 2),
          ));
          // You can navigate to a screen that prompts the user to verify their email
        }
      }
    } catch (e){
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.grey[700],
            content:
            Center(child: Text("Invalid Email or Phone Number!",style: GoogleFonts.quicksand(
                fontSize: 14, fontWeight: FontWeight.bold),
            ),),
            duration: const Duration(seconds: 2),
          ));
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.grey[700],
            content:
            Center(child: Text("Wrong Password",style: GoogleFonts.quicksand(
                fontSize: 14, fontWeight: FontWeight.bold),
            ),),
            duration: const Duration(seconds: 2),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.grey[700],
            content:
            Center(child: Text("Error occurred",style: GoogleFonts.quicksand(
                fontSize: 14, fontWeight: FontWeight.bold),
            ),),
            duration: const Duration(seconds: 2),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.grey[700],
          content:
          Center(child: Text("Error occurred",style: GoogleFonts.quicksand(
              fontSize: 14, fontWeight: FontWeight.bold),
          ),),
          duration: const Duration(seconds: 2),
        ));
      }
      setState(() {
        isLoading = false;
      });
    }

  }
  String? checkEmail(){
    if(_emailController.text.trim().contains('@')){
      return _emailController.text.trim();
    } else {
      return "${_emailController.text.trim()}@gmail.com";
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
                      icon: Icon(Icons.alternate_email), hintText: 'Email / Phone Number'),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  obscureText: isVisible,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      icon: const Icon(Icons.lock_outline), hintText: 'Password',
                  suffixIcon: IconButton(onPressed: (){
                    setState(() {
                      isVisible = !isVisible;
                    });
                  }, icon: isVisible? const Icon(Icons.visibility_off) : const Icon(Icons.visibility))
                  ),
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
                    if(_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                      logIn();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.grey[700],
                        content:
                        Center(child: Text("Please fill out the details!",style: GoogleFonts.quicksand(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        ),),
                        duration: const Duration(seconds: 2),
                      ));
                    }
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
                          "Register with Phone Number",
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
                SizedBox(height: 40,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PhonePasswordResetPage()));
                  },
                  child: Text(
                    "reset",
                    style: GoogleFonts.quicksand(
                      //fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
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
