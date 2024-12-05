import 'package:get/get.dart';

import '../models/post_model.dart';
import '../models/promotion_model.dart';
import '../service/post_service.dart';
import '../service/user_promotion_service.dart';

class UserPromotionController extends GetxController {
  final PostService _postService = PostService();
  final UserPromotionService _promotionService = UserPromotionService();

  final RxList<Post> userPosts = <Post>[].obs;
  final RxList<Promotion> userPromotions = <Promotion>[].obs;
  final RxList<int> selectedPostIds = <int>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserPosts();
    fetchUserPromotions();
  }

  Future<void> loadUserPosts() async {
    try {
      isLoading(true);
      error('');
      final posts = await _postService.getAllPersonalPosts();
      userPosts.assignAll(posts);
    } catch (e) {
      error('Failed to load posts: $e');
      print('Error loading posts: $e');
    } finally {
      isLoading(false);
    }
  }

  void togglePostSelection(int postId) {
    if (selectedPostIds.contains(postId)) {
      selectedPostIds.remove(postId);
    } else {
      selectedPostIds.add(postId);
    }
  }

  void toggleSelectAll() {
    if (selectedPostIds.length == userPosts.length) {
      selectedPostIds.clear();
    } else {
      selectedPostIds.value = userPosts.map((post) => post.id).toList();
    }
  }

  Future<bool> submitPromotion({
    required String content,
    required double discountValue,
    required DateTime expiredDate,
  }) async {
    try {
      isLoading(true);
      error('');

      final success = await _promotionService.addPromotion(
        content: content,
        discountValue: discountValue,
        expiredDate: expiredDate,
        postIds: selectedPostIds.toList(),
      );

      if (success) {
        selectedPostIds.clear();
        return true;
      } else {
        error('Failed to add promotion');
        return false;
      }
    } catch (e) {
      error('Error adding promotion: $e');
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchUserPromotions() async {
    try {
      isLoading.value = true;
      userPromotions.value = await _promotionService.getAllUserPromotions();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deletePromotion(int promotionId) async {
    try {
      isLoading(true);
      error('');

      final success = await _promotionService.deletePromotion(promotionId);

      if (success) {
        userPromotions.removeWhere((promo) => promo.id == promotionId);
        return true;
      } else {
        error('Failed to delete promotion');
        return false;
      }
    } catch (e) {
      error('Error deleting promotion: $e');
      return false;
    } finally {
      isLoading(false);
    }
  }
}