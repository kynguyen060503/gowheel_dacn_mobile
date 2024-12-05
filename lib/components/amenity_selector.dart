import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gowheel_flutterflow_ui/models/amenity_model.dart';
import '../controllers/amenity_controller.dart';

class AmenitySelectionWidget extends StatelessWidget {
  final AmenityController amenityController = Get.find<AmenityController>();
  final RxList<Amenity> selectedAmenities;
  final RxList<int> selectedAmenityIds;

  AmenitySelectionWidget({
    Key? key,
    required this.selectedAmenities,
    required this.selectedAmenityIds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Amenities",
          style: GoogleFonts.urbanist(
            color: const Color(0xFF213A58),
            fontSize: 20,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _showAmenitySelectionBottomSheet(context),
          style: ElevatedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF213A58)),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: Colors.grey.shade400),
            ),
          ),
          child: Text(
            'Select Amenities',
            style: const TextStyle(color: Color(0xFF213A58)),
          ),
        ),
        const SizedBox(height: 10),
        Obx(() => Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: selectedAmenities.map((amenity) {
            return Chip(
              label: Text(amenity.name),
              onDeleted: () {
                selectedAmenities.remove(amenity);
                selectedAmenityIds.remove(amenity.id);
              },
            );
          }).toList(),
        )),
      ],
    );
  }

  void _showAmenitySelectionBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Obx(() {
              if (amenityController.isLoading.value) {
                return Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (amenityController.errorMessage.value != null) {
                return Expanded(
                  child: Center(
                    child: Text('Error: ${amenityController.errorMessage.value}'),
                  ),
                );
              }

              return Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Select Amenities',
                        style: GoogleFonts.urbanist(
                          color: const Color(0xFF213A58),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: amenityController.amenities.length,
                        itemBuilder: (context, index) {
                          final amenity = amenityController.amenities[index];
                          return Obx(() => CheckboxListTile(
                            title: Text(amenity.name),
                            value: selectedAmenityIds.contains(amenity.id),
                            onChanged: (bool? value) {
                              if (value == true) {
                                if (!selectedAmenityIds.contains(amenity.id)) {
                                  selectedAmenities.add(amenity);
                                  selectedAmenityIds.add(amenity.id);
                                }
                              } else {
                                selectedAmenities.removeWhere((e) => e.id == amenity.id);
                                selectedAmenityIds.remove(amenity.id);
                              }
                            },
                          ));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 45),
                        ),
                        child: Text('Confirm'),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}