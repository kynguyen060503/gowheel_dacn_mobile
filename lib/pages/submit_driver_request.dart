import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gowheel_flutterflow_ui/components/snackbar.dart';

import '../controllers/user_controller.dart';

class DriverRequest extends StatefulWidget {
  const DriverRequest({super.key});

  @override
  State<DriverRequest> createState() => _DriverRequestState();
}

class _DriverRequestState extends State<DriverRequest> {
  final UserController _userController = UserController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _agreed = false;

  void _handleSubmit() async {
    if (_agreed) {
      await _userController.sendDriverRequest();
      Get.back();
    } else {
      Snackbar.showError('Error', 'Please accept our privacy and policy!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF80EE98),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 30,
          ),
            splashRadius: 30,
        ),

        title: Text(
          'Request to become Driver',
          style: GoogleFonts.lexendDeca(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.0,
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF213A58),
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                  child: Text(
                    "To become a driver, you must provide us with a valid ID card and an official, valid driver's license. Once reviewed, we will approve your request. In case of any issues, the company's decision will be final.",
                    style: GoogleFonts.urbanist(
                      textStyle: Theme.of(context).textTheme.headlineMedium,
                      letterSpacing: 0.0, 
                      fontSize: 16,
                    )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 24),
                child: Theme(
                  data: ThemeData(
                    checkboxTheme: CheckboxThemeData(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    unselectedWidgetColor: const Color(0xFF213A58),
                  ),
                  child: CheckboxListTile(
                    value: _agreed,
                    onChanged: (newValue) async {
                      setState(() => _agreed = newValue!);
                    },
                    title: Text(
                      'I accept all policy and privacy',
                      style: GoogleFonts.urbanist(
                        fontSize: 20,
                        letterSpacing: 0.0, 
                      )
                    ),
                    activeColor: const Color(0xFF80EE98),
                    checkColor: const Color(0xFF213A58),
                    dense: false,
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, 0),
                child: ElevatedButton(
                  onPressed: _agreed ? _handleSubmit : null ,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _agreed
                        ? const Color(0xFF80EE98)
                        : const Color(0xFF213A58),
                    disabledBackgroundColor: const Color(0xFF80EE98),
                    padding: EdgeInsets.zero,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                    ),
                  ),
                  child: SizedBox(
                    width: 340,
                    height: 60,
                    child: Center(
                      child: Text(
                        'Send Request',
                        style: GoogleFonts.lexendDeca(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
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