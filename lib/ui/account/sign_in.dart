import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../src/firebase_auth.dart';
import '../custom/custom_textfield.dart';
import '../home/home_tab.dart';
import 'forget_password.dart';
import 'sign_up.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SingInPageState();
}

class _SingInPageState extends State<SignInPage> {
  final emailCtl = TextEditingController();
  final passwordCtl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool obscurePass = true;
  IconData iconPassword = CupertinoIcons.eye_fill;

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MyHomePage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showMessage('No user found for this email', context);
      } else if (e.code == 'wrong-password') {
        showMessage('Wrong password! Try agian', context);
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.headset_mic_outlined,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Text(
                  "Wellcome to",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  "Music App",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            Text("Sign In",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MyTextField(
                      controller: emailCtl,
                      hintText: 'Email',
                      obscureText: false,
                      labelText: 'Email',
                      validator: (emailVali) {
                        if (emailVali == null || emailVali.isEmpty) {
                          return 'Please Enter Email';
                        } else if (!isEmailValid(emailVali)) {
                          return 'Please Enter Valid Email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    MyTextField(
                      controller: passwordCtl,
                      hintText: 'Password',
                      obscureText: obscurePass,
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePass = !obscurePass;
                            if (obscurePass) {
                              iconPassword = CupertinoIcons.eye_fill;
                            } else {
                              iconPassword = CupertinoIcons.eye_slash_fill;
                            }
                          });
                        },
                        icon: Icon(iconPassword),
                      ),
                      validator: (passVali) {
                        if (passVali == null || passVali.isEmpty) {
                          return 'Please Enter Password';
                        }
                        return null;
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgotPassword()));
                      },
                      child: Text("Forgot Password?",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 18.0,
                          )),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            MyTextButton(
              title: 'Sign In',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    email = emailCtl.text;
                    password = passwordCtl.text;
                  });
                }
                userLogin();
              },
            ),
            const SizedBox(height: 20.0),
            Text(
              "or LogIn with",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 22.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    AuthMethods().signInWithGoogle(context);
                  },
                  child: Image.asset(
                    "assets/google.png",
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 15.0),
              ],
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(width: 5.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUp()));
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

bool isEmailValid(String value) {
  String pattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}
