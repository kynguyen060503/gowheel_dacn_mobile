import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gowheel_flutterflow_ui/controllers/auth_controller.dart';
import 'package:gowheel_flutterflow_ui/controllers/user_controller.dart';
import 'package:gowheel_flutterflow_ui/pages/add_post.dart';
import 'package:gowheel_flutterflow_ui/pages/detail_profile.dart';
import 'package:gowheel_flutterflow_ui/pages/home_driver.dart';
import 'package:gowheel_flutterflow_ui/pages/list_booking.dart';
import 'package:gowheel_flutterflow_ui/pages/list_invoice.dart';
import 'package:gowheel_flutterflow_ui/pages/list_user_promotion.dart';
import 'package:gowheel_flutterflow_ui/pages/submit_driver_request.dart';
import 'package:gowheel_flutterflow_ui/url.dart';
import 'package:quickalert/quickalert.dart';


class MainProfileWidget extends StatefulWidget {
  const MainProfileWidget({super.key});

  @override
  State<MainProfileWidget> createState() => _MainProfileWidgetState();
}

class _MainProfileWidgetState extends State<MainProfileWidget> {

  final UserController userController = Get.put(UserController());
  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    userController.refreshUserData();
  });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Obx(() {
                // Show loading indicator while fetching data
                if (userController.isLoading.value) {
                  return Container(
                    height: 200,
                    color: const Color(0xFF80EE98),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  );
                }

                // Get the current user
                final user = userController.currentUser.value;

                // If no user data is available
                if (user == null) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: const Color(0xFF80EE98),
                    child: Center(
                      child: Text(
                        'Unable to load user information',
                        style: GoogleFonts.lexendDeca(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }

                // User data available - display profile
                return Container(
                  width: double.infinity,
                  height: 175,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('images/profile_background.jpg'),
                      fit: BoxFit.cover,
                    ),
                    color: const Color(0xFF80EE98).withOpacity(0.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            URL.imageUrl + (user.image ?? 'default_image.png'),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                'https://picsum.photos/seed/79/600',
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: GoogleFonts.lexendDeca(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                                Text(
                                  "<Email>",
                                  style: GoogleFonts.lexendDeca(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Text(
                                  "Birthday:${user.formattedBirthday}",
                                  style: GoogleFonts.lexendDeca(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              //master field
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Settings',
                      style: GoogleFonts.interTight(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ],
                ),
              ),

              //child field
              Material(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 50,
                  constraints: const BoxConstraints(
                    minWidth: double.infinity,
                  ),
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 0,
                        color: Color(0xFFE3E5E7),
                        offset: Offset(
                          0.0,
                          2,
                        ),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 4, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.person,
                          size: 24,
                        ),
                        Expanded(
                          child:
                          Text(
                            ' Personal Information',
                            style: GoogleFonts.interTight(
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 46.0,
                          icon: const Icon(
                            Icons.chevron_right_rounded,
                            color:Color(0xFF95A1AC),
                            size: 25.0,
                          ),
                          onPressed: () {
                            Get.to(() => const DetailProfile());
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

              //driver request
              Material(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 50,
                  constraints: const BoxConstraints(
                    minWidth: double.infinity,
                  ),
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 0,
                        color: Color(0xFFE3E5E7),
                        offset: Offset(
                          0.0,
                          2,
                        ),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 4, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.person_add,
                          size: 24,
                        ),
                        Expanded(
                          child:
                          Text(
                            ' Request to become Driver',
                            style: GoogleFonts.interTight(
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 46.0,
                          icon: const Icon(
                            Icons.chevron_right_rounded,
                            color:Color(0xFF95A1AC),
                            size: 25.0,
                          ),
                          onPressed: () {
                            Get.to(() => const DriverRequest());
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

              Material(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 50,
                  constraints: const BoxConstraints(
                    minWidth: double.infinity,
                  ),
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 0,
                        color: Color(0xFFE3E5E7),
                        offset: Offset(
                          0.0,
                          2,
                        ),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 4, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.bookmark_outline,
                          size: 24,
                        ),
                        Expanded(
                          child:
                          Text(
                            'Your Booking',
                            style: GoogleFonts.interTight(
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 46.0,
                          icon: const Icon(
                            Icons.chevron_right_rounded,
                            color:Color(0xFF95A1AC),
                            size: 25.0,
                          ),
                          onPressed: () {
                            Get.to(() => const BookingScreen());
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

              Material(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 50,
                  constraints: const BoxConstraints(
                    minWidth: double.infinity,
                  ),
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 0,
                        color: Color(0xFFE3E5E7),
                        offset: Offset(
                          0.0,
                          2,
                        ),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 4, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.lock_clock,
                          size: 24,
                        ),
                        Expanded(
                          child:
                          Text(
                            'Your Invoice',
                            style: GoogleFonts.interTight(
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 46.0,
                          icon: const Icon(
                            Icons.chevron_right_rounded,
                            color:Color(0xFF95A1AC),
                            size: 25.0,
                          ),
                          onPressed: () {
                            Get.to(() => const InvoiceScreen());
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

              //masterfield
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rentail Service Management',
                      style: GoogleFonts.interTight(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ],
                ),
              ),

              //your rental car
              Material(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 50,
                  constraints: const BoxConstraints(
                    minWidth: double.infinity,
                  ),
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 0,
                        color: Color(0xFFE3E5E7),
                        offset: Offset(
                          0.0,
                          2,
                        ),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 4, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.car_rental,
                          size: 24,
                        ),
                        Expanded(
                          child:
                          Text(
                            ' Your Vehicles for Rent',
                            style: GoogleFonts.interTight(
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 46.0,
                          icon: const Icon(
                            Icons.chevron_right_rounded,
                            color:Color(0xFF95A1AC),
                            size: 25.0,
                          ),
                          onPressed: () {
                            Get.to(() => const DetailProfile());
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

              //add rental car
              Material(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 50,
                  constraints: const BoxConstraints(
                    minWidth: double.infinity,
                  ),
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 0,
                        color: Color(0xFFE3E5E7),
                        offset: Offset(
                          0.0,
                          2,
                        ),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 4, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.plus_one,
                          size: 24,
                        ),
                        Expanded(
                          child:
                          Text(
                            ' Post Your Car for Rent',
                            style: GoogleFonts.interTight(
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 46.0,
                          icon: const Icon(
                            Icons.chevron_right_rounded,
                            color:Color(0xFF95A1AC),
                            size: 25.0,
                          ),
                          onPressed: () {
                            Get.to(() => AddPostScreen());
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

              //add promotion for post
              Material(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 50,
                  constraints: const BoxConstraints(
                    minWidth: double.infinity,
                  ),
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 0,
                        color: Color(0xFFE3E5E7),
                        offset: Offset(
                          0.0,
                          2,
                        ),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 4, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.discount,
                          size: 24,
                        ),
                        Expanded(
                          child:
                          Text(
                            ' Add Promotion to your Car',
                            style: GoogleFonts.interTight(
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 46.0,
                          icon: const Icon(
                            Icons.chevron_right_rounded,
                            color:Color(0xFF95A1AC),
                            size: 25.0,
                          ),
                          onPressed: () {
                            Get.to(() => UserPromotionListScreen());
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              colors: [
                                Color(0xFF213A58),
                                Color(0xFF80EE98),
                              ],
                            ).createShader(bounds);
                          },
                          child:
                    Text(
                      'Driver Management',
                      style: GoogleFonts.interTight(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.0,
                      ),
                    ),
                    )
                  ],
                ),
              ),

              Material(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 50,
                  constraints: const BoxConstraints(
                    minWidth: double.infinity,
                  ),
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 0,
                        color: Color(0xFFE3E5E7),
                        offset: Offset(
                          0.0,
                          2,
                        ),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 4, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.list_alt,
                          size: 24,
                        ),
                        Expanded(
                          child:
                          Text(
                            ' Driver Booking List',
                            style: GoogleFonts.interTight(
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 46.0,
                          icon: const Icon(
                            Icons.chevron_right_rounded,
                            color:Color(0xFF95A1AC),
                            size: 25.0,
                          ),
                          onPressed: () {
                            Get.to(() => LocationTrackingPage());
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
          
              //Logout button
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 20),
                child: ElevatedButton(
                  onPressed: () async {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.confirm,
                        text: 'Do you want to logout',
                        confirmBtnText: 'Yes',
                        cancelBtnText: 'No',
                        confirmBtnColor: Colors.green,
                        onConfirmBtnTap:  authController.logout
                      );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.red, // Text color
                    backgroundColor: Colors.white, // Background color
                    minimumSize: const Size(110, 50), // Width and height
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                      side: const BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      fontFamily: 'Lexend Deca',
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.0,
                    ),
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
