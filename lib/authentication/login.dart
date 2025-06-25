import 'dart:io';

import 'package:flutter/material.dart';
import 'package:transportation_mobile_app/main.dart';
import 'package:transportation_mobile_app/resources/constants/colors.dart';
import 'package:transportation_mobile_app/resources/constants/endpoints.dart';
import 'package:transportation_mobile_app/resources/constants/images.dart';
import 'package:transportation_mobile_app/resources/constants/strings.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Login(),
    );
  }
}


class Login extends StatefulWidget {

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  late TextEditingController _usernameController;
  late TextEditingController _pwdController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _pwdController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  Future<int> login() async {
    String username = _usernameController.text.trim();
    String password = _pwdController.text.trim();

    if(username == null || password == null){
      return 0;
    }

    final response = await http.post(
        Uri.parse(ApiEndpoints.baseUrl+ApiEndpoints.login),
        body: {'username': username, 'password': password}
    );

    return response.statusCode;
  }

  void onLoginPressed() async {

    setState(() {
      isLoading = true;
    });

    final success = await login();

    setState(() {
      isLoading = false;
    });

    if(success == 0){
      const snackbar = SnackBar(content: Text("Please fill in required fields"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return;
    }

    if(success == 404){
      const snackbar = SnackBar(content: Text("User does not exist"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return;
    }

    if(success == 401){
      const snackbar = SnackBar(content: Text("Email not confirmed"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return;
    }

    if(success == 402){
      const snackbar = SnackBar(content: Text("Wrong password"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return;
    }

    if(success == 200){
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context)=> const Main()),
              (route) => false
      );
      return;
    }

    const snackbar = SnackBar(content: Text("Unknown error!"));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: isLoading ?

        Stack(
          children:[
            LoginForm(pwdController: _pwdController,
              usernameController: _usernameController,
              onLoginPressed: onLoginPressed,
            ),
            ModalBarrier(
              dismissible: false,
              color: Colors.black54.withOpacity(0.2),
            ),
            const Center(child:
              SizedBox(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    color: AppColors.secondary,
                    strokeWidth: 5,
                    backgroundColor: AppColors.primary,
                  )
              ),
            )
          ]
        ):
        LoginForm(usernameController: _usernameController,
            pwdController: _pwdController,
            onLoginPressed: onLoginPressed
        )
    );
  }
}


class LoginForm extends StatefulWidget {

  final TextEditingController usernameController;
  final TextEditingController pwdController;
  void Function() onLoginPressed;

  LoginForm({
    super.key,
    required this.usernameController,
    required this.pwdController,
    required this.onLoginPressed
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 120,
                      width: 250,
                      child: Image.asset(AppImages.appLogo),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      AppStrings.singIn,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(AppStrings.username),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: widget.usernameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(AppStrings.password),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: widget.pwdController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                      ),
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(AppColors.transparent),
                            splashFactory: NoSplash.splashFactory,
                            overlayColor: MaterialStatePropertyAll(AppColors.transparent),
                          ),
                          child: const Text(
                            AppStrings.forgotPassword,
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                widget.onLoginPressed();
                              },
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(AppColors.primary),
                                foregroundColor: MaterialStatePropertyAll(Colors.white),
                              ),
                              child: const Text(AppStrings.logIn),
                            )
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.7,
                            color: Colors.grey,
                            indent: 10,
                            endIndent: 10,
                          ),
                        ),
                        Text(
                          AppStrings.orSingInWith,
                          style: TextStyle(color: Colors.grey),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.7,
                            color: Colors.grey,
                            indent: 10,
                            endIndent: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(AppColors.transparent),
                      ),
                      child: const Text(
                        AppStrings.singInWithGoogle,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(), // Pushes content up if more space available
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(AppStrings.dontHaveAnAccount),
                        TextButton(
                          onPressed: () {},
                          style: const ButtonStyle(
                            splashFactory: NoSplash.splashFactory,
                            overlayColor: MaterialStatePropertyAll(AppColors.transparent),
                          ),
                          child: const Text(
                            AppStrings.register,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}