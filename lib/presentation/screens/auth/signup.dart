import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mychat/core/common/coustom_button.dart';
import 'package:mychat/core/common/coustom_input_box.dart';
import 'package:mychat/logic/cubit/auth_cubit.dart';
import 'package:mychat/presentation/screens/auth/login.dart';
import 'package:mychat/routes/app_routor.dart';
import 'package:mychat/services/service_locator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  bool hidePassword = true;

  // all Controller
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordContoller = TextEditingController();
  // all focus nodes
  final _fullNameFocus = FocusNode();
  final _userNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneNumberFocus = FocusNode();
  final _passwordFocus = FocusNode();

  // all validators
  String? _fullNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a Full Name';
    }
    return null;
  }

  String? _userNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a User Name';
    }
    if (value.length < 3) {
      return 'User Name must be of minimum 3 characters';
    }
    return null;
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

  String? _phoneNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a Phone Number';
    }
    if (RegExp(r'[0-9]{10}$').hasMatch(value) == false) {
      return 'Invalid Phone Number';
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
  void dispose() {
    fullNameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordContoller.dispose();
    _fullNameFocus.dispose();
    _userNameFocus.dispose();
    _emailFocus.dispose();
    _phoneNumberFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> handleSignup() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      try {
        getIt<AuthCubit>().signUp(
          fullName: fullNameController.text,
          userName: userNameController.text,
          phoneNumber: phoneController.text,
          email: emailController.text,
          password: passwordContoller.text,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }else{
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Form Validation Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
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
                  controller: fullNameController,
                  hintText: "Full Name",
                  focusNode: _fullNameFocus,
                  validator: _fullNameValidator,
                  prefixIcon: Icon(Icons.person_outline),
                ),
                SizedBox(height: 10),
                InputBox(
                  controller: userNameController,
                  hintText: "Username",
                  focusNode: _userNameFocus,
                  validator: _userNameValidator,
                  prefixIcon: Icon(Icons.alternate_email),
                ),
                SizedBox(height: 10),
                InputBox(
                  controller: emailController,
                  hintText: "Email",
                  focusNode: _emailFocus,
                  validator: _emailValidator,
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                SizedBox(height: 10),
                InputBox(
                  controller: phoneController,
                  hintText: "Phone Number",
                  focusNode: _phoneNumberFocus,
                  validator: _phoneNumberValidator,
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                SizedBox(height: 10),
                InputBox(
                  controller: passwordContoller,
                  hintText: "Password",
                  focusNode: _passwordFocus,
                  validator: _passwordValidator,
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                  obscureText: hidePassword,
                ),
                SizedBox(height: 20),
                CoustomButton(onPressed: handleSignup, text: "Create Account"),
                SizedBox(height: 10),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      children: [
                        TextSpan(
                          text: "Login",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  getIt<AppRoutor>().push(LoginScreen());
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
