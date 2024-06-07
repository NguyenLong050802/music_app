import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../src/firebase_service.dart';
import '../custom/custom_textfield.dart';
import '../home/home_tab.dart';
import 'sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "";
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController rePassCtl = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    try {
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? userDetails = result.user;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          content: Text(
            "Registered Successfully",
            style: Theme.of(context).textTheme.bodyLarge,
          )));
      Map<String, dynamic> userInfoMap = {
        "email": userDetails!.email,
        "name": userDetails.displayName,
        "imgUrl": userDetails.photoURL,
        "id": userDetails.uid
      };
      await FireBaseService()
          .addUser(userDetails.uid, userInfoMap)
          .then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MyHomePage()));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showMessage('Password Provided is too Weak', context);
      } else if (e.code == "email-already-in-use") {
        showMessage('Email is already in use', context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Sign Up",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  MyTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Email';
                      } else if (!isEmailValid(value)) {
                        return ' Email is not available';
                      }
                      return null;
                    },
                    controller: mailcontroller,
                    hintText: "Email",
                    obscureText: false,
                    labelText: "Email",
                  ),
                  const SizedBox(height: 20.0),
                  MyTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                    controller: passwordcontroller,
                    hintText: "Password",
                    obscureText: false,
                    labelText: "Password",
                  ),
                  const SizedBox(height: 20.0),
                  MyTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Re-enter Password';
                      } else if (value != passwordcontroller.text) {
                        return 'Password does not match';
                      }
                      return null;
                    },
                    controller: rePassCtl,
                    hintText: "Re-enter Password",
                    obscureText: false,
                    labelText: "Re-enter Password",
                  ),
                  const SizedBox(height: 20.0),
                  MyTextButton(
                    title: "Sign Up",
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          email = mailcontroller.text;
                          password = passwordcontroller.text;
                        });
                      }
                      registration();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            "or LogIn with",
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 22.0,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/google.png",
                height: 45,
                width: 45,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 0.0),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account?",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500)),
              const SizedBox(
                width: 5.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
                },
                child: Text(
                  "Sign In",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
