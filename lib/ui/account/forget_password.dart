import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app_flutter/ui/custom/custom_textfield.dart';
import 'sign_in.dart';
import 'sign_up.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = "";
  TextEditingController mailcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showMessage('Password Reset Email has been sent !', context);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        showMessage('No user found for this email', context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Forgot Password",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Password Recovery",
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          Text(
            "Enter your mail",
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20.0),
          Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Email';
                        } else if (!isEmailValid(value)) {
                          return 'Email is not available';
                        }
                        return null;
                      },
                      controller: mailcontroller,
                      hintText: "Email",
                      labelText: 'Email',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.onError,
                        size: 30.0,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    MyTextButton(
                        title: 'Send Email',
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              email = mailcontroller.text;
                            });
                            await resetPassword();
                          }
                        }),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUp(),
                                ));
                          },
                          child: Text(
                            "Create",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
