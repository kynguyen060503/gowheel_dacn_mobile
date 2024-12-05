
import 'package:get/get.dart';

import '../models/promotion_model.dart';
import '../service/admin_promotion_service.dart';

class PromotionController extends GetxController {
  final AdminPromotionService _promotionService = AdminPromotionService();

  // Observable variables
  final RxList<Promotion> promotions = <Promotion>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getAllPromotions();
  }

  Future<void> getAllPromotions() async {
    try {
      isLoading.value = true;
      error.value = '';
      final fetchedPromotions = await _promotionService.getAllAdminPromotion();
      promotions.value = fetchedPromotions!;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  // Refresh data
  Future<void> refreshPromotions() async {
    await getAllPromotions();
  }
}