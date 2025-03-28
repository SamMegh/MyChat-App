import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mychat/core/common/coustom_button.dart';
import 'package:mychat/core/common/coustom_input_box.dart';
import 'package:mychat/presentation/screens/auth/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
bool hidePassword = true;
  
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a Email';
    }
    if (RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
        ).hasMatch(value) ==
        false) {
      return 'Enter a valid email';
    }

    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a Password';
    }
    if (value.length < 6) {
      return 'Password should be atleast of 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Text(
                  "Welcome Back!",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "login to continue",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
                SizedBox(height: 30),
                InputBox(
                  controller: emailcontroller,
                  hintText: "Email",
                  focusNode: _emailFocus,
                  validator: _emailValidator,
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                SizedBox(height: 10),
                InputBox(
                  controller: passwordcontroller,
                  hintText: "Password",
                  focusNode: _passwordFocus,
                  validator: _passwordValidator,
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                   suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: Icon(hidePassword?Icons.visibility_off_outlined:Icons.visibility_outlined),
                    ),
                    obscureText: hidePassword,
                ),
                SizedBox(height: 10),
                Text(
                  "Forget Password",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                Center(child: CoustomButton(text: "Login", onPressed: () {
                  FocusScope.of(context).unfocus();
                    if (_formKey.currentState?.validate() ?? false) {}
                })),
                SizedBox(height: 20),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Need an account! ",
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "Signup",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignupScreen(),
                                    ),
                                  );
                                },
                        ),
                      ],
                    ),
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
