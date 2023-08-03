import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout/auth/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;

  Future signUp() async{
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim());

      addDetails(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        int.parse(_ageController.text.trim()),
        _emailController.text.trim(),
      );
      setState(() {
        isLoading = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e){
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }
  Future addDetails(String firstName, String lastName, int age, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name' : firstName,
      'last name' : lastName,
      'age' : age,
      'email' : email,
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
              children: [
                SizedBox(
                    height: 200,
                    child: SvgPicture.asset('assets/sign_up.svg')),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Sign up",
                      style: GoogleFonts.quicksand(
                          fontSize: 34, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                    border: Border.all(width: 1,color: Colors.grey),
                  ),
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        hintText: 'First Name',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                    border: Border.all(width: 1,color: Colors.grey),
                  ),
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        hintText: 'Last Name',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                    border: Border.all(width: 1,color: Colors.grey),
                  ),
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      controller: _ageController,
                      decoration: const InputDecoration(
                        hintText: 'Age',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                    border: Border.all(width: 1,color: Colors.grey),
                  ),
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                    border: Border.all(width: 1,color: Colors.grey),
                  ),
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: (){
                    signUp();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.blue,
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Center(
                        child: isLoading? const CircularProgressIndicator(color: Colors.white,) :  Text(
                          "Continue",
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
