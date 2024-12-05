import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gowheel_flutterflow_ui/models/amenity_model.dart';
import 'package:gowheel_flutterflow_ui/root.dart';
import 'package:image_picker/image_picker.dart';

import '../components/amenity_selector.dart';
import '../components/snackbar.dart';
import '../controllers/amenity_controller.dart';
import '../controllers/post_controler.dart';

class AddPostScreen extends StatelessWidget {
  final PostController controller = Get.put(PostController());
  final AmenityController amenityController = Get.put(AmenityController());
  final _formKey = GlobalKey<FormState>();

  // Existing controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final seatController = TextEditingController();
  final rentLocationController = TextEditingController();
  final pricePerHourController = TextEditingController();
  final pricePerDayController = TextEditingController();
  final fuelController = TextEditingController();
  final fuelConsumedController = TextEditingController();

  // Form values
  final hasDriver = false.obs;
  final gear = false.obs;
  final RxList<int> selectedAmenityIds = <int>[].obs;
  final RxList<Amenity> selectedAmenities = <Amenity>[].obs;
  final selectedCarTypeId = 1;
  final selectedCompanyId = 1;

  AddPostScreen({super.key}) {
    amenityController.loadAmenities();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      controller.selectedImagePath.value = image.path;
    }
  }

  Future<void> pickListImages() async {
    final ImagePicker picker = ImagePicker();
    List<String> images = [];
    final data = await picker.pickMultiImage();
    if (data.isEmpty) {
      return;
    }
    else {
      if (data.length > 3) {
        Snackbar.showWarning("Warring","Must pick 3 image!");
      }
      else {
        for (var e in data) {
          images.add(e.path.toString());
        }
        controller.selectedImageList.value = images;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Post New Car For Rent',
          style: GoogleFonts.lexendDeca(
            color: const Color(0xFF213A58),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.0,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image picker
              Text("Cover Image",
                style:  GoogleFonts.urbanist(
                  color: const Color(0xFF213A58),
                  fontSize: 20,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              // For the cover image
              Obx(() => Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: controller.selectedImagePath.isEmpty
                            ? const Center(child: Icon(Icons.upload_file, size: 50))
                            : Image.file(
                                File(controller.selectedImagePath.value),
                                fit: BoxFit.contain,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: FloatingActionButton.small(
                        heroTag: null,
                        onPressed: pickImage,
                        child: const Icon(Icons.camera_alt),
                        backgroundColor: const Color(0xFF80EE98),
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 10),
              // For the detail images
              Text("Detail Images(3-picture)",
                style:  GoogleFonts.urbanist(
                  color: const Color(0xFF213A58),
                  fontSize: 20,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 10),

              Obx(() => Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: controller.selectedImageList.isEmpty
                            ? const Center(child: Icon(Icons.upload_file, size: 50))
                            : PageView.builder(
                                itemCount: controller.selectedImageList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Image.file(
                                    File(controller.selectedImageList[index]),
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                    height: double.infinity,
                                  );
                                },
                              ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: FloatingActionButton.small(
                        heroTag: null,
                        onPressed: pickListImages,
                        child: const Icon(Icons.camera_alt),
                        backgroundColor: const Color(0xFF80EE98),
                      ),
                    ),
                  ],
                ),
              )),

              //name
              const SizedBox(height: 10),
              Text("Car Name",
                style:  GoogleFonts.urbanist(
                  color: const Color(0xFF213A58),
                  fontSize: 20,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Ex: Lamboghini Aventador....",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  border: const OutlineInputBorder()
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),

              //Description
              const SizedBox(height: 10),
              Text("Description",
                style:  GoogleFonts.urbanist(
                  color: const Color(0xFF213A58),
                  fontSize: 20,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: "Ex: Super model car can run so fast....",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  border: const OutlineInputBorder()
                ),
                maxLines: 3,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),

              //Numofseat
              const SizedBox(height: 10),
              Text("Number of seat",
                style:  GoogleFonts.urbanist(
                  color: const Color(0xFF213A58),
                  fontSize: 20,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: seatController,
                decoration: InputDecoration(
                  hintText: "Ex: 4...",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  border: const OutlineInputBorder()
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),

              //Location
              const SizedBox(height: 10),
              Text("Location",
                style:  GoogleFonts.urbanist(
                  color: const Color(0xFF213A58),
                  fontSize: 20,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: rentLocationController,
                decoration: InputDecoration(
                  hintText: "Ex: HCM...",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  border: const OutlineInputBorder()
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              //priceperhour
              const SizedBox(height: 10),
              Text("Price per hour(VND)",
                style:  GoogleFonts.urbanist(
                  color: const Color(0xFF213A58),
                  fontSize: 20,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: pricePerHourController,
                decoration: InputDecoration(
                  hintText: "Ex: 40000..",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  border: const OutlineInputBorder()
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              //priceperday
              const SizedBox(height: 10),
              Text("Price per day(VND)",
                style:  GoogleFonts.urbanist(
                  color: const Color(0xFF213A58),
                  fontSize: 20,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: pricePerDayController,
                decoration: InputDecoration(
                  hintText: "Ex: 400000...",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  border: const OutlineInputBorder()
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              //Fueltype
              const SizedBox(height: 10),
              Text(
                "Fuel Type",
                style: GoogleFonts.urbanist(
                  color: const Color(0xFF213A58),
                  fontSize: 20,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
                hint: Text(
                  "Select Fuel Type",
                  style: TextStyle(color: Colors.grey.shade400),
                ),
                items: [
                  "Gasoline (Petrol)",
                  "Diesel",
                  "Electricity",
                  "Hybrid (Gasoline + Electricity)",
                  "Plug-in Hybrid (PHEV)",
                  "Compressed Natural Gas (CNG)",
                  "Liquefied Petroleum Gas (LPG)",
                  "Ethanol (E85)",
                  "Hydrogen Fuel Cell",
                  "Biodiesel",
                  "Flex-Fuel (Flexible-Fuel Vehicle)",
                ]
                    .map((fuelType) => DropdownMenuItem<String>(
                          value: fuelType,
                          child: Text(fuelType),
                        ))
                    .toList(),
                onChanged: (value) {
                  fuelController.text = value!;
                },
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              //fuelconsume
              const SizedBox(height: 10),
              Text("Fuel Consume (per 100km)",
                style:  GoogleFonts.urbanist(
                  color: const Color(0xFF213A58),
                  fontSize: 20,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: fuelConsumedController,
                decoration: InputDecoration(
                  hintText: "Ex: 6...",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  border: const OutlineInputBorder()
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),

              //amenitypicker
              const SizedBox(height: 10),
              AmenitySelectionWidget(
                selectedAmenities: selectedAmenities,
                selectedAmenityIds: selectedAmenityIds,
              ),

              //other
              const SizedBox(height: 10),
              Text("Others",
                style:  GoogleFonts.urbanist(
                  color: const Color(0xFF213A58),
                  fontSize: 20,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Obx(() => SwitchListTile(
                title: Text("Has driver",
                  style: GoogleFonts.urbanist(
                    color: const Color(0xFF213A58),
                    fontSize: 20,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                value: hasDriver.value,
                onChanged: (value) => hasDriver.value = value,
              )),
              Obx(() => SwitchListTile(
                title: Text("Gear type (Manual/Auto)",
                  style: GoogleFonts.urbanist(
                    color: const Color(0xFF213A58),
                    fontSize: 20,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                value: gear.value,
                onChanged: (value) => gear.value = value,
              )),

              const SizedBox(height: 10,),
              // Submit button
              Obx(() => ElevatedButton(
              onPressed: controller.isAddingPost.value
                  ? null
                  : () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (controller.selectedImagePath.isEmpty) {
                          Snackbar.showError('Error', 'Must chose at least one image');
                          return;
                        }
                        
                        // Gửi dữ liệu bài đăng
                        await controller.addPost(
                          name: nameController.text,
                          description: descriptionController.text,
                          seat: int.parse(seatController.text),
                          rentLocation: rentLocationController.text,
                          hasDriver: hasDriver.value,
                          pricePerHour: double.parse(pricePerHourController.text),
                          pricePerDay: double.parse(pricePerDayController.text),
                          gear: gear.value,
                          fuel: fuelController.text,
                          fuelConsumed: double.parse(fuelConsumedController.text),
                          amenitiesIds: selectedAmenityIds,
                          imagePath: controller.selectedImagePath.value,
                          imageList: controller.selectedImageList,
                          carTypeId: selectedCarTypeId,
                          companyId: selectedCompanyId,
                        );
                        
                        // Reset các trường dữ liệu
                        nameController.clear();
                        descriptionController.clear();
                        seatController.clear();
                        rentLocationController.clear();
                        pricePerHourController.clear();
                        pricePerDayController.clear();
                        fuelController.clear();
                        fuelConsumedController.clear();
                        hasDriver.value = false;
                        gear.value = false;
                        controller.selectedImagePath.value = '';
                        controller.selectedImageList.value = [];
                        selectedAmenityIds.clear();
                        selectedAmenities.clear();
                        
                        // Quay lại trang chủ
                        Get.to(() => const RootPage());
                      }
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: const Color(0xFF80EE98),
              ),
              child: controller.isAddingPost.value
                  ? const SizedBox(
                      height: 20,
                      width: 44,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Add Post',
                      style: GoogleFonts.lexendDeca(
                        color: const Color(0xFF213A58),
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                      ),
                    ),
            )),
            ],
          ),
        ),
      ),
    );
  }
}