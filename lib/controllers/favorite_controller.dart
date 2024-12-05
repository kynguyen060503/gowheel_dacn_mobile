import 'package:get/get.dart';
import 'package:gowheel_flutterflow_ui/components/snackbar.dart';

import '../service/favorite_service.dart';

class FavoriteController extends GetxController {
  final FavoriteService _favoriteService = FavoriteService();
  final isLoading = false.obs;
  final favoriteMap = <int, int>{}.obs;

  Future<void> fetchFavorites() async {
    try {
      final favorites = await _favoriteService.getFavorites();
      favoriteMap.value = favorites;
    } catch (e) {
    }
  }

  Future<void> addToFavorite(int postId) async {
    try {
      isLoading.value = true;
      final result = await _favoriteService.addToFavorite(postId);
      if (result) {
        await fetchFavorites();
        Snackbar.showSuccess('Success', 'Added to favorites');
      } else {
        Snackbar.showError('Error', 'Failed to add favorite');
      }
    } catch (e) {
      print('Error adding favorite: $e');
      Snackbar.showError('Error', 'Failed to add favorite');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFromFavorite(int postId) async {
    try {
      isLoading.value = true;
      final favoriteId = favoriteMap[postId];
      if (favoriteId != null) {
        final result = await _favoriteService.removeFromFavorite(favoriteId);
        if (result) {
          favoriteMap.remove(postId);
          Snackbar.showSuccess('Success', 'Removed from favorites');
        } else {
          Snackbar.showError('Error', 'Failed to remove favorite');
        }
      }
    } catch (e) {
      print('Error removing favorite: $e');
      Snackbar.showError('Error', 'Failed to remove favorite');
    } finally {
      isLoading.value = false;
    }
  }

  bool isFavorite(int postId) {
    return favoriteMap.containsKey(postId);
  }
}