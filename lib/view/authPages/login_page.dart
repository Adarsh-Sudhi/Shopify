import 'package:avodha_interview_test/model/userModel/userModel.dart';
import 'package:avodha_interview_test/view/authPages/sigup_page.dart';
import 'package:avodha_interview_test/view/customWidget/textUtil.dart';
import 'package:avodha_interview_test/view/pages/homepage/home.dart';
import 'package:avodha_interview_test/viewmodel/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  late AnimationController _controller;
  late Animation<double> _fade;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation =
        Tween<double>(
          begin: 0, // top-left
          end: 1,
        ).animate(
          CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
        );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(_controller);

    _scaleController.forward();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scaleController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(IconData icon, String hint, Color color) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: color),
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthGranted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomePage()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const TextUtil(
                            "Shopify",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            "Login to continue",
                            style: TextStyle(color: Colors.grey),
                          ),

                          const SizedBox(height: 30),

                          TextFormField(
                            controller: _nameController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _decoration(
                              Icons.email,
                              "Email",
                              Colors.blue,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter phone number";
                              }
                              if (value.length < 10) {
                                return "Enter valid phone number";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: _decoration(
                              Icons.lock,
                              "Password",
                              Colors.red,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter password";
                              }
                              if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 30),

                      
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                if (state is AuthLoading) {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Shimmer.fromColors(
                                        baseColor: Colors.redAccent,
                                        highlightColor:
                                            Colors.redAccent.shade100,
                                        child: Container(
                                          width: double.infinity,
                                          height: 52,
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      UserModel userModel = UserModel(
                                        name: "test",
                                        phoneNo: 000000000,
                                        email: _nameController.text.trim(),
                                        password: _passwordController.text
                                            .trim(),
                                      );

                                      BlocProvider.of<AuthBloc>(
                                        context,
                                      ).add(LogInUser(userModel: userModel));
                                    }
                                  },
                                  child: const TextUtil(
                                    "Login",
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                         
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const TextUtil(
                                "Don’t have a student account?",
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              TextButton(
                                onPressed: () async {
                                  _scaleController.reverse();
                                  await _controller.reverse();

                                  if (mounted) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((e) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => SignUpPage(),
                                            ),
                                          );
                                        });
                                  }
                                },
                                child: const TextUtil(
                                  "Sign Up",
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
