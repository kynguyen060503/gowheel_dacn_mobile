import 'package:get/get.dart';
import 'package:gowheel_flutterflow_ui/models/amenity_model.dart';

import '../service/amenity_service.dart';

class AmenityController extends GetxController {
  final AmenityService _service = AmenityService();

  final RxList<Amenity> amenities = <Amenity>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadAmenities();
  }

  Future<void> loadAmenities() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      amenities.value = await _service.fetchAmenities();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
    }
  }
}