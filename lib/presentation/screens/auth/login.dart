import 'package:flutter/material.dart';
import 'package:mychat/core/common/coustom_button.dart';
import 'package:mychat/core/common/input_box.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Text(
                "Welcome Back!",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "login to continue",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              SizedBox(height: 30),
              InputBox(
                controller: emailcontroller,
                hintText: "Email",
                prefixIcon: Icon(Icons.email_outlined),
              ),
              SizedBox(height: 10),
              InputBox(controller: passwordcontroller,
              hintText: "Password",
              prefixIcon: Icon(Icons.lock_outline_rounded),
              suffixIcon: Icon(Icons.remove_red_eye_outlined),
              obscureText:true),
              SizedBox(height: 10,),
              Text("Forget Password", style:TextStyle(
                color: Theme.of(context).primaryColor,
                
              ),),
              Center(child: CoustomButton(
                text: "Login",
                onPressed: (){},
              ),
              ),
             RichText(
              text: TextSpan(
                text: "Need an account! ",
                children: [TextSpan(
                  text: "Signup",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  )
                )]
              ),
             ),
            
            ],
          ),
        ),
      ),
    );
  }
}
