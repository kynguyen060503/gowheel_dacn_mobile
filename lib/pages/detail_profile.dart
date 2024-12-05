import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gowheel_flutterflow_ui/components/snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../controllers/user_controller.dart';
import '../components/image_upload.dart';
class DetailProfile extends StatefulWidget {
  const DetailProfile({super.key});

  @override
  State<DetailProfile> createState() => _DetailProfileState();
}

class _DetailProfileState extends State<DetailProfile> {
  final UserController _controller = Get.find<UserController>();
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = _controller.currentUser.value?.name ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source, String type) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        File imageFile = File(image.path);
        switch (type) {
          case 'profile':
            _controller.setProfileImage(imageFile);
            break;
          case 'cic':
            _controller.setCICImage(imageFile);
            break;
          case 'license':
            _controller.setLicenseImage(imageFile);
            break;
        }
      }
    } catch (e) {
      Snackbar.showError('Error', 'Failed to pick image: $e');
    }
  }

  void _showImagePicker(String type) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                blurRadius: 7,
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  width: 80,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Select Image',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF213A58),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.gallery, type);
                  },
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Pick from Gallery'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFF213A58),
                    backgroundColor: const Color(0xFF80EE98),
                    side: const BorderSide(color: Colors.grey, width: 1),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.camera, type);
                  },
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: const Text('Take Photo'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFF213A58),
                    backgroundColor: const Color(0xFF80EE98),
                    side: const BorderSide(color: Colors.grey, width: 1),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFF213A58),
                    backgroundColor: Colors.red.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF80EE98),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF213A58),
            size: 24,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Profile Page',
          style: GoogleFonts.lexendDeca(
            color: Color(0xFF213A58),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.0,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                if (_controller.currentUser.value != null) {
                  _controller.currentUser.value!.name = _nameController.text;
                  await _controller.updateProfile();
                  Get.back();
                }
              }
            },
            icon: const Icon(Icons.save, color: Color(0xFF213A58)),
            label: Text('Save',
             style: GoogleFonts.lexendDeca(
              color: Color(0xFF213A58),
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.0,
            ),
          ),
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        final user = _controller.currentUser.value;
        if (user == null) {
          return const Center(child: Text('No user data available'));
        }

        return Form(
          key: _formKey,
          child: ListView(
            children: [
              // Profile Image Section
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDBE2E7),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          width: 90,
                          height: 90,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Builder(
                            builder: (context) {
                              if (_controller.newProfileImage.value != null) {
                                return Image.file(
                                  _controller.newProfileImage.value!,
                                  fit: BoxFit.cover,
                                );
                              } else if (user.fullImageUrl != null) {
                                return Image.network(
                                  user.fullImageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const
                                  Icon(Icons.person, size: 40),
                                );
                              } else {
                                return const Icon(Icons.person, size: 40);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _showImagePicker('profile'),
                      child: Text('Change Photo',style: GoogleFonts.lexendDeca(
                        color: Color(0xFF213A58),
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                        ),),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        backgroundColor: Color(0xFF80EE98),
                      ),
                    ),
                  ],
                ),
              ),
            
              // Form Fields
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Your full name...',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF213A58),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF213A58),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        contentPadding: const EdgeInsets.fromLTRB(20, 24, 0, 24),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Phone Field
                    TextFormField(
                      enabled: false,
                      initialValue: user.phoneNumber ?? 'Not set',
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF213A58),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF213A58),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        contentPadding: const EdgeInsets.fromLTRB(20, 24, 0, 24),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Birthday Field
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF213A58),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: const Text('Birthday'),
                        subtitle: Text(user.formattedBirthday),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: user.birthday ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            _controller.updateBirthday(date);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Documents Section
                    const Divider(),
                    Text(
                      'Identity Documents',
                      style: GoogleFonts.lexendDeca(
                        color: const Color(0xFF213A58),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // CIC Image
                    Text(
                      '<Citizen ID Card>',
                      style: GoogleFonts.lexendDeca(
                        color: const Color(0xFF213A58),
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DocumentUpload(
                      imageUrl: user.fullCICUrl,
                      newImage: _controller.newCICImage.value,
                      type: 'cic',
                      onPickImage: () => _showImagePicker('cic'),
                    ),
                    const SizedBox(height: 16),

                    // License Image
                    Text(
                      '<Driver\'s License>',
                      style: GoogleFonts.lexendDeca(
                        color: const Color(0xFF213A58),
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DocumentUpload(
                      imageUrl: user.fullLicenseUrl,
                      newImage: _controller.newLicenseImage.value,
                      type: 'license',
                      onPickImage: () => _showImagePicker('license'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}