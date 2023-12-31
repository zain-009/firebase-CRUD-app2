import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:workout/views/phone_password_reset_page.dart';
import 'package:workout/views/phone_signup_page.dart';

class PhoneVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final bool fromPhonePasswordReset;

  const PhoneVerificationPage(
      {super.key, required this.verificationId, required this.phoneNumber, this.fromPhonePasswordReset = false});

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  String smsCode = '';
  bool isLoading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> verifyOtp() async {
    final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: smsCode);

    setState(() {
      isLoading = true;
    });
    try{
      await auth.signInWithCredential(credential);
      setState(() {
        isLoading = false;
      });
      if(widget.fromPhonePasswordReset) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PhonePasswordResetPage()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneSignupPage(number: widget.phoneNumber,)));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),duration: const Duration(seconds: 2),));
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.grey[600],
              size: 30,
            )),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 200, child: Image.asset('assets/otp.png')),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Please enter the 6 Digit code sent to ${widget.phoneNumber}",
                style: GoogleFonts.quicksand(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                validator: (s) {
                  smsCode = s!;
                  return null;
                },
                showCursor: false,
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  verifyOtp();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue,
                  ),
                  height: 50,
                  width: double.infinity,
                  child: Center(
                      child: isLoading? const CircularProgressIndicator(color: Colors.white,) :Text(
                    "Verify Code",
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
    );
  }
}
