import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gowheel_flutterflow_ui/pages/sign_in.dart';

import '../controllers/auth_controller.dart';

class SignupWidget extends StatefulWidget {
  const SignupWidget({super.key});

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  final _formField = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();
  bool _passwordVisible = false;
  Timer? _debounce;

  @override
  void dispose() {
    super.dispose();
  }

  void _onTextChanged(VoidCallback callback) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), callback);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
            child: Form(
              key: _formField,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.max,
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
                        'Sign Up',
                        style: GoogleFonts.urbanist(
                          color: Colors.white, // Must be white for gradient to show
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Wellcome, new custommer!',
                    style: GoogleFonts.urbanist(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        onChanged: (_) => _onTextChanged(() {
                          if (_formField.currentState!.validate()) {
                          }
                        }),
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
                  ),

                  // Password field
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscureText: !_passwordVisible,
                        onChanged: (_) => _onTextChanged(() {
                          if (_formField.currentState!.validate()) {
                          }
                        }),
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
                  ),

                // Confirm password field
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocusNode,
                        obscureText: !_passwordVisible,
                        onChanged: (_) => _onTextChanged(() {
                          if (_formField.currentState!.validate()) {
                          }
                        }),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password is required!";
                          } else if (value != _passwordController.text) {
                            return 'Passwords do not match!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: GoogleFonts.urbanist(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                          hintText: 'Enter your password here again...',
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
                  ),


                  //Username field
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _usernameController,
                        focusNode: _usernameFocusNode,
                        onChanged: (_) => _onTextChanged(() {
                          if (_formField.currentState!.validate()) {
                          }
                        }),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Username is required!";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: GoogleFonts.urbanist(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                          hintText: 'Enter your username here...',
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
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 10),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formField.currentState?.validate() ?? false) {
                            _authController.signup(
                              _emailController.text,
                              _usernameController.text,
                              _passwordController.text,
                            );
                            _emailController.clear();
                            _passwordController.clear();
                            _confirmPasswordController.clear();
                            _usernameController.clear();
                            _emailFocusNode.unfocus();
                            _passwordFocusNode.unfocus();
                            _confirmPasswordFocusNode.unfocus();
                            _usernameFocusNode.unfocus();
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
                          'Create Account',
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Already have account field => SignupWidget
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: GoogleFonts.lexendDeca(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                              Get.offAll(() => const SignInWidget(),
                                  transition: Transition.size,
                                  duration: const Duration(seconds: 1));
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF39D2C0),
                            padding: EdgeInsets.zero,
                          ),
                          child:ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: [
                                  Color(0xFF80EE98),
                                  Color(0xFF213A58),
                                ],
                              ).createShader(bounds);
                            },
                            child: Text(
                              'Login',
                              style: GoogleFonts.urbanist(
                                color: Colors.white,
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
      ),
    );
  }
}
