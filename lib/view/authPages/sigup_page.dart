import 'package:avodha_interview_test/model/userModel/userModel.dart';
import 'package:avodha_interview_test/view/authPages/login_page.dart';
import 'package:avodha_interview_test/view/customWidget/textUtil.dart';
import 'package:avodha_interview_test/viewmodel/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  late AnimationController _controller;
  late Animation<double> _fade;

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String? selectedDepartment;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fade,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const TextUtil(
                        "Create Shopify Account",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Sign up to continue",
                        style: TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _nameController,
                        decoration: _decoration(
                          Icons.person,
                          "Full Name",
                          Colors.red,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter your name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _emailController,
                        decoration: _decoration(
                          Icons.email,
                          "Email",
                          Colors.red,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter your email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: _decoration(
                          Icons.phone,
                          "Phone Number",
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
                        obscureText: !_showPassword,
                        decoration:
                            _decoration(
                              Icons.lock,
                              "Password",
                              Colors.blue,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                              ),
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

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_showConfirmPassword,
                        decoration:
                            _decoration(
                              Icons.lock_outline,
                              "Confirm Password",
                              Colors.red,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showConfirmPassword =
                                        !_showConfirmPassword;
                                  });
                                },
                              ),
                            ),
                        onChanged: (_) => setState(() {}),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm password";
                          }
                          if (value != _passwordController.text) {
                            return "Passwords do not match";
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
                                    highlightColor: Colors.redAccent.shade100,
                                    child: Container(
                                      width: double.infinity,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  UserModel userModel = UserModel(
                                    name: _nameController.text.trim(),
                                    phoneNo: int.parse(_phoneController.text),
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  );

                                  BlocProvider.of<AuthBloc>(
                                    context,
                                  ).add(SignUpUser(userModel: userModel));
                                }
                              },
                              child: const TextUtil(
                                "Sign Up",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const TextUtil(
                            "Already have a Shopyfy account?",
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          TextButton(
                            onPressed: () async {
                              _scaleController.reverse();
                              await _controller.reverse();
                              if (mounted) {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  e,
                                ) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LoginPage(),
                                    ),
                                  );
                                });
                              }
                            },
                            child: const TextUtil(
                              "Login",
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
    );
  }
}
