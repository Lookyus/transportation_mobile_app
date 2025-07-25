import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:transportation_mobile_app/pages/add_vehicle/add_car_make.dart';
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

  Future<http.Response> login(username, password) async {

    try{
      final response = await http.post(
          Uri.parse(ApiEndpoints.baseUrl+ApiEndpoints.login),
          body: {'username': username, 'password': password}
      )
      .timeout(const Duration(seconds: 5));
      return response;
    } on TimeoutException{
      throw Exception("Server timeout");
    } on SocketException {
      throw Exception("Server unreachable");
    }
  }

  void onLoginPressed() async {

    final username = _usernameController.text.toString().trim();
    final password = _pwdController.text.toString().trim();

    setState(() {
      isLoading = true;
    });

    try{
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context)=> const VehiclesPage()),//const Main()),
              (route) => false
      );
      return;

      final response = await login(username, password);

      if(response.statusCode == 200){
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context)=> const VehiclesPage()),//const Main()),
                (route) => false
        );
        return;
      }

      setState(() {
        isLoading = false;
      });
      final snackbar = SnackBar(
          content: Text("${jsonDecode(response.body)['message']}"),
          duration: const Duration(milliseconds: 1000),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);

    }catch(e){
      setState(() {
        isLoading = false;
      });
      final snackbar = SnackBar(
          content: Text("$e"),
          duration: const Duration(milliseconds: 1000) ,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
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

  Color _userNameBorderColor = AppColors.borderColor;
  Color _passwordBorderColor = AppColors.borderColor;
  double _usernameBorderWidth = 1;
  double _passwordBorderWidth = 1;

  late List<TextEditingController> credentialsFieldList;


  @override
  void initState() {
    credentialsFieldList = [widget.usernameController, widget.pwdController];
  }

  void showEmptyUserNameError(){
    setState(() {
      _userNameBorderColor = AppColors.errorBorderColor;
      _usernameBorderWidth = 2;
    });
  }

  void showEmptyPasswordError(){
    setState(() {
      _passwordBorderColor = AppColors.errorBorderColor;
      _passwordBorderWidth = 2;
    });
  }

  void restoreBorders(){
    setState(() {
      _passwordBorderWidth = 1;
      _passwordBorderColor = AppColors.borderColor;
      _usernameBorderWidth = 1;
      _userNameBorderColor = AppColors.borderColor;
    });
  }

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
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: _userNameBorderColor, width: _usernameBorderWidth)
                        ),
                        focusedBorder:  OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: AppColors.primary, width: _usernameBorderWidth)
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
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
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: _passwordBorderColor, width: _passwordBorderWidth)
                        ),
                        focusedBorder:  OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: AppColors.primary, width: _passwordBorderWidth)
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
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
                                FocusScope.of(context).unfocus();

                                restoreBorders();

                                final username = widget.usernameController.text.trim();
                                final password = widget.pwdController.text.trim();

                                if(username.isEmpty){
                                  showEmptyUserNameError();
                                  return;
                                }

                                if(password.isEmpty){
                                  showEmptyPasswordError();
                                  return;
                                }

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