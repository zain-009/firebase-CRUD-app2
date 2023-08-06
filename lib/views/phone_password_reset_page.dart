import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PhonePasswordResetPage extends StatefulWidget {
  const PhonePasswordResetPage({super.key});

  @override
  State<PhonePasswordResetPage> createState() => _PhonePasswordResetPageState();
}

class _PhonePasswordResetPageState extends State<PhonePasswordResetPage> {
  final _passwordController = TextEditingController();
  bool isVisible = true;
  bool isLoading = false;


  Future<void> resetPassword () async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      "Reset\nPassword",
                      style: GoogleFonts.quicksand(
                          fontSize: 34, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Enter the new password for your account",
                  style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500]),
                ),
                const SizedBox(height: 30,),
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
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    resetPassword();
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
