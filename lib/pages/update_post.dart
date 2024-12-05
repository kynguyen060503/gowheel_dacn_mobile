import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../components/snackbar.dart';
import '../controllers/post_controler.dart';
import '../models/post_model.dart';

class EditPostScreen extends StatelessWidget {
  final Post post;
  final PostController controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  EditPostScreen({super.key, required this.post}) {
    _initializeControllers();
  }

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final seatController = TextEditingController();
  final locationController = TextEditingController();
  final priceHourController = TextEditingController();
  final priceDayController = TextEditingController();
  final fuelController = TextEditingController();
  final fuelConsumeController = TextEditingController();
  final carTypeIdController = TextEditingController();
  final companyIdController = TextEditingController();
  
  final hasDriver = false.obs;
  final gear = false.obs;
  final selectedAmenities = <int>[].obs;

  void _initializeControllers() {
    nameController.text = post.name;
    descriptionController.text = post.description;
    seatController.text = post.seat.toString();
    locationController.text = post.rentLocation;
    priceHourController.text = post.pricePerHour.toString();
    priceDayController.text = post.pricePerDay.toString();
    fuelController.text = post.fuel;
    fuelConsumeController.text = post.fuelConsumed.toString();
    hasDriver.value = post.hasDriver;
    gear.value = post.gear;
    //selectedAmenities.value = post.amenitiesIds;
    controller.selectedImagePath.value = post.image;
    controller.selectedImageList.value = post.images!;
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
        title: Text('Edit Car Rental Post',
          style: GoogleFonts.lexendDeca(
            color: const Color(0xFF213A58),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF213A58)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageSection(
                title: "Cover Image",
                imagePath: controller.selectedImagePath,
                onPick: () async {
                  await pickImage();
                },
              ),
              
              ImageListSection(
                title: "Detail Images (3 Required)",
                images: controller.selectedImageList,
                onPick: () async {
                  await pickListImages();
                },
              ),

              InputField(
                title: "Car Name",
                controller: nameController,
                hint: "Ex: Toyota Camry 2024",
              ),

              InputField(
                title: "Description",
                controller: descriptionController,
                hint: "Enter car details",
                maxLines: 3,
              ),

              InputField(
                title: "Number of Seats",
                controller: seatController,
                hint: "Ex: 4",
                keyboardType: TextInputType.number,
              ),

              InputField(
                title: "Location",
                controller: locationController,
                hint: "Ex: Ho Chi Minh City",
              ),

              InputField(
                title: "Price per Hour (VND)",
                controller: priceHourController,
                hint: "Ex: 200000",
                keyboardType: TextInputType.number,
              ),

              InputField(
                title: "Price per Day (VND)", 
                controller: priceDayController,
                hint: "Ex: 1500000",
                keyboardType: TextInputType.number,
              ),

              FuelTypeDropdown(
                controller: fuelController,
                initialValue: post.fuel,
              ),

              InputField(
                title: "Fuel Consumption (L/100km)",
                controller: fuelConsumeController,
                hint: "Ex: 7.5",
                keyboardType: TextInputType.number,
              ),

              // AmenitySelector(
              //   selectedIds: selectedAmenities,
              //   initialAmenities: post.amenities,
              // ),

              SwitchRow(
                title: "Driver Available",
                value: hasDriver,
              ),

              SwitchRow(
                title: "Automatic Transmission",
                value: gear,
              ),

              const SizedBox(height: 20),

              // SaveButton(
              //   onPressed: () async {
              //     if (_formKey.currentState!.validate()) {
              //       await controller.updatePost(
              //         post.id,
              //         name: nameController.text,
              //         description: descriptionController.text,
              //         seat: int.parse(seatController.text),
              //         location: locationController.text,
              //         priceHour: double.parse(priceHourController.text),
              //         priceDay: double.parse(priceDayController.text),
              //         fuel: fuelController.text,
              //         fuelConsume: double.parse(fuelConsumeController.text),
              //         hasDriver: hasDriver.value,
              //         gear: gear.value,
              //         amenities: selectedAmenities,
              //         coverImage: controller.selectedImagePath.value,
              //         images: controller.selectedImageList,
              //       );
              //       Get.back();
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  final String title;
  final RxString imagePath;
  final VoidCallback onPick;

  const ImageSection({
    required this.title,
    required this.imagePath,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
          style: GoogleFonts.urbanist(
            fontSize: 20,
            color: const Color(0xFF213A58),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Obx(() => Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Center(
                child: imagePath.isEmpty
                    ? const Icon(Icons.image, size: 50)
                    : Image.file(File(imagePath.value), fit: BoxFit.cover),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: FloatingActionButton.small(
                  onPressed: onPick,
                  backgroundColor: const Color(0xFF80EE98),
                  child: const Icon(Icons.camera_alt),
                ),
              ),
            ],
          ),
        )),
        const SizedBox(height: 16),
      ],
    );
  }
}

class ImageListSection extends StatelessWidget {
  final String title;
  final RxList<String> images;
  final VoidCallback onPick;

  const ImageListSection({
    required this.title,
    required this.images,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
          style: GoogleFonts.urbanist(
            fontSize: 20,
            color: const Color(0xFF213A58),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Obx(() => Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              images.isEmpty
                  ? const Center(child: Icon(Icons.collections, size: 50))
                  : PageView.builder(
                      itemCount: images.length,
                      itemBuilder: (context, index) => 
                        Image.file(File(images[index]), fit: BoxFit.cover),
                    ),
              Positioned(
                right: 8,
                bottom: 8,
                child: FloatingActionButton.small(
                  onPressed: onPick,
                  backgroundColor: const Color(0xFF80EE98),
                  child: const Icon(Icons.camera_alt),
                ),
              ),
            ],
          ),
        )),
        const SizedBox(height: 16),
      ],
    );
  }
}

class InputField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;

  const InputField({
    required this.title,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override 
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
          style: GoogleFonts.urbanist(
            fontSize: 20,
            color: const Color(0xFF213A58),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class FuelTypeDropdown extends StatelessWidget {
  final TextEditingController controller;
  final String initialValue;

  const FuelTypeDropdown({
    required this.controller,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Fuel Type",
          style: GoogleFonts.urbanist(
            fontSize: 20,
            color: const Color(0xFF213A58),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: initialValue,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: [
            "Gasoline",
            "Diesel",
            "Electric",
            "Hybrid",
            "Other"
          ].map((type) => DropdownMenuItem(
            value: type,
            child: Text(type),
          )).toList(),
          onChanged: (value) {
            if (value != null) controller.text = value;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class SwitchRow extends StatelessWidget {
  final String title;
  final RxBool value;

  const SwitchRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => SwitchListTile(
      title: Text(title,
        style: GoogleFonts.urbanist(
          fontSize: 20,
          color: const Color(0xFF213A58),
          fontWeight: FontWeight.w500,
        ),
      ),
      value: value.value,
      onChanged: (val) => value.value = val,
    ));
  }
}

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF80EE98),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text("Save Changes",
          style: GoogleFonts.lexendDeca(
            color: const Color(0xFF213A58),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}