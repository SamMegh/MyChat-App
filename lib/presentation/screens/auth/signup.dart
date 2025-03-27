import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mychat/core/common/coustom_button.dart';
import 'package:mychat/core/common/coustom_input_box.dart';
import 'package:mychat/presentation/screens/auth/login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {
  final TextEditingController FullNameController = TextEditingController();
  final TextEditingController UserNameController = TextEditingController();
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController PhoneController = TextEditingController();
  final TextEditingController PasswordContoller = TextEditingController();
  @override
  void dispose() {
    FullNameController.dispose();
    UserNameController.dispose();
    EmailController.dispose();
    PhoneController.dispose();
    PasswordContoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create an Account",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 5),
              Text(
                "Please fill the details to continue",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
              SizedBox(height: 30),
              InputBox(
                controller: FullNameController,
                hintText: "Full Name",
                prefixIcon: Icon(Icons.person_outline),
              ),
              SizedBox(height: 10),
              InputBox(
                controller: UserNameController,
                hintText: "Username",
                prefixIcon: Icon(Icons.alternate_email),
              ),
              SizedBox(height: 10),
              InputBox(
                controller: EmailController,
                hintText: "Email",
                prefixIcon: Icon(Icons.email_outlined),
              ),
              SizedBox(height: 10),
              InputBox(
                controller: PhoneController,
                hintText: "Phone Number",
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              SizedBox(height: 10),
              InputBox(
                controller: PasswordContoller,
                hintText: "Password",
                prefixIcon: Icon(Icons.lock_outline),
                suffixIcon: Icon(Icons.remove_red_eye_outlined),
                obscureText: true,
              ),
              SizedBox(height: 20),
              CoustomButton(onPressed: () {}, text: "Signup"),
              SizedBox(height: 10),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    children: [
                      TextSpan(
                        text: "Login",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold
                        ),
                        recognizer:
                           TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
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
    );
  }
}
