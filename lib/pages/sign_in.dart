import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gowheel_flutterflow_ui/pages/sign_up.dart';

import '../controllers/auth_controller.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({super.key});

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final _formField = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Form(
            key: _formField,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 50, 0, 15),
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              colors: [
                                Color(0xFF213A58),
                                Color(0xFF80EE98),
                              ],
                            ).createShader(bounds);
                          },
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Welcome back,',
                        style: GoogleFonts.urbanist(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Email field
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required!";
                            } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                              return "Email invalid!";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: GoogleFonts.urbanist(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                            hintText: 'Enter your email here...',
                            hintStyle: GoogleFonts.urbanist(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.error,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            errorStyle: GoogleFonts.urbanist(),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.error,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                            contentPadding: const EdgeInsets.fromLTRB(16, 24, 0, 24),
                          ),
                          style: GoogleFonts.interTight(),
                          cursorColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),

                      //Password field
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          obscureText: !_passwordVisible,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password is required!";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: GoogleFonts.urbanist(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                            hintText: 'Enter your password here...',
                            hintStyle: GoogleFonts.urbanist(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.error,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            errorStyle: GoogleFonts.urbanist(),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.error,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                            contentPadding: const EdgeInsets.fromLTRB(16, 24, 0, 24),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                size: 22,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          style: GoogleFonts.interTight(),
                          cursorColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Login button
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formField.currentState?.validate() ?? false) {
                        _authController.login(
                          _emailController.text,
                          _passwordController.text,
                        );
                        _emailController.clear();
                        _passwordController.clear();
                        _emailFocusNode.unfocus();
                        _passwordFocusNode.unfocus();
                        _formField.currentState?.reset();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.onSecondary,
                      minimumSize: const Size(300, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      'Login',
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),


                //Forget password
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 40, 10),
                    child: TextButton(
                      onPressed: () {
                        
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onBackground,
                      ),
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                // Or
                Padding(
                  padding: EdgeInsets.zero,
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [
                          Color(0xFF213A58),
                          Color(0xFF80EE98),
                        ],
                      ).createShader(bounds);
                    },
                  child:
                      Text('OR',
                          style: GoogleFonts.urbanist(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ))

                  ),
                ),

                // Google sign in
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formField.currentState!.validate()) {
                        _authController.login(
                          _emailController.text,
                          _passwordController.text,
                        );
                        _emailController.clear();
                        _passwordController.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.onSecondary,
                      minimumSize: const Size(300, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 3,
                    ),
                    label: Text(
                      'Continue with Google',
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    icon: const FaIcon(
                      FontAwesomeIcons.google,
                      size: 20,
                    ),
                  ),
                ),

                // Don't have an account => SignupWidget
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 70, 0, 24),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: GoogleFonts.lexendDeca(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.offAll(()=> const SignupWidget(),
                          transition: Transition.size,
                          duration: Duration(seconds: 1));
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF39D2C0),
                          padding: EdgeInsets.zero,
                        ),
                        child:ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: [
                                  Color(0xFF213A58),
                                  Color(0xFF80EE98),
                                ],
                              ).createShader(bounds);
                            },
                            child: Text(
                              'Create Account',
                              style: GoogleFonts.lexendDeca(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ),
                      ),
                    ],
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