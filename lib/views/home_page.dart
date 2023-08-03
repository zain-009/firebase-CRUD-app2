import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout/views/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSigningOut = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.grey[50],
        leading: null,
        actions: [
          IconButton(
              onPressed: () async {
                setState(() {
                  isSigningOut = true;
                });
                try {
                  await FirebaseAuth.instance.signOut();
                  setState(() {
                    isSigningOut = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.grey[700],
                    content:
                    Center(child: Text("Logout Successful",style: GoogleFonts.quicksand(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    ),),
                    duration: const Duration(seconds: 2),
                  ));
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                } catch (e){
                  setState(() {
                    isSigningOut = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.grey[700],
                    content:
                    Center(child: Text(e.toString(),style: GoogleFonts.quicksand(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    ),),
                    duration: const Duration(seconds: 2),
                  ));
                }
              },
              icon: isSigningOut? const CircularProgressIndicator(color: Colors.black,) : const Icon(Icons.logout,color: Colors.black,)),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("HomePage"),
          ],
        ),
      ),
    );
  }
}
