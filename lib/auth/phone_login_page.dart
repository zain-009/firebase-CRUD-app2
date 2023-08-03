import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:workout/auth/phone_verification_page.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  var phoneNumber = "";
  bool isLoading = false;
  final auth = FirebaseAuth.instance;

  Future<void> sendCode() async {
    setState(() {
      isLoading = true;
    });
    try {
      auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (_) {},
          verificationFailed: (e) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Verification Failed!"),
              duration: Duration(seconds: 2),
            ));
          },
          codeSent: (String verificationId, int? token){
            setState(() {
              isLoading = false;
            });
            Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneVerificationPage(verificationId: verificationId,phoneNumber: phoneNumber,)));
          },
          codeAutoRetrievalTimeout: (_){}
          );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                  height: 200,
                  child: Image.asset('assets/business-and-finance.png')),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Please enter your phone number to receive the code",
                style: GoogleFonts.quicksand(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              IntlPhoneField(
                disableLengthCheck: false,
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
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  sendCode();
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
                              "Send the Code",
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Want to go back? ",
                    style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Login",
                      style: GoogleFonts.quicksand(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
