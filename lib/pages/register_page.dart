import 'package:first/components/my_button.dart';
import 'package:first/components/my_text_field.dart';
import 'package:first/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confirmpasswordcontroler = TextEditingController();
  void signUp() async {
    if (passwordcontroller.text != confirmpasswordcontroler.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match!"),
        ),
      );
      return;
    }
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWithEmailandPassword(
        emailcontroller.text,
        passwordcontroller.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Icon(
                  Icons.message,
                  size: 80,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Let's create an account",
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  height: 30,
                ),
                MyTextField(
                    controller: emailcontroller,
                    hintText: "Email",
                    obscureText: false),
                const SizedBox(
                  height: 20,
                ),
                MyTextField(
                    controller: passwordcontroller,
                    hintText: "Password",
                    obscureText: true),
                const SizedBox(
                  height: 20,
                ),
                MyTextField(
                    controller: confirmpasswordcontroler,
                    hintText: "Confirm password",
                    obscureText: true),
                const SizedBox(
                  height: 20,
                ),
                MyButton(onTap: signUp, text: "Sign Up"),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already a member?"),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Login now!",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
