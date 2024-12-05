import 'package:get/get.dart';

import '../components/snackbar.dart';
import '../models/post_model.dart';
import '../service/post_service.dart';

class PostController extends GetxController {
  final PostService _postService = PostService();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxList<Post> posts = <Post>[].obs;
  final RxBool isAddingPost = false.obs;
  final RxString selectedImagePath = ''.obs;
  RxList<String> selectedImageList = <String>[].obs;
  Rx<String> error = ''.obs;

  // For single post
  final Rxn<Post> currentPost = Rxn<Post>();
  final RxBool isLoadingPost = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAllPosts();
  }

  Future<void> getAllPosts() async {
    try {
      isLoading.value = true;

      final postsList = await _postService.getAllPosts();

      if (postsList.isEmpty) {
      Snackbar.showError("Error", "List is empty!");
      } else {
        posts.assignAll(postsList);
      }
    } catch (e) {
      Snackbar.showError("Error", "Lost connection to server!");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPost({
    required String name,
    required String description,
    required int seat,
    required String rentLocation,
    required bool hasDriver,
    required double pricePerHour,
    required double pricePerDay,
    required bool gear,
    required String fuel,
    required double fuelConsumed,
    required int carTypeId,
    required int companyId,
    required List<int> amenitiesIds,
    required String imagePath,
    required List<String> imageList,
  }) async {
    try {
      isAddingPost.value = true;

      final success = await _postService.addPost(
        name: name,
        description: description,
        seat: seat,
        rentLocation: rentLocation,
        hasDriver: hasDriver,
        pricePerHour: pricePerHour,
        pricePerDay: pricePerDay,
        gear: gear,
        fuel: fuel,
        fuelConsumed: fuelConsumed,
        carTypeId: carTypeId,
        companyId: companyId,
        amenitiesIds: amenitiesIds,
        imagePath: imagePath,
        imagesList: imageList
      );

      if (success) {
        Snackbar.showSuccess('Success','Post added successfully');
        await refreshPosts();
      } else {
        Snackbar.showError('Error','Failed to add post');
      }
    } catch (e) {
      Snackbar.showError('Error','Failed to add post');
    } finally {
      isAddingPost.value = false;
    }
  }

  Future<void> getPersonalPost() async {
    try{
      isLoading.value = true;
      final postslist = await _postService.getAllPersonalPosts();
      if (postslist.isEmpty) {
        error.value = 'No posts found';
      } else {
        posts.assignAll(postslist);
      }

    } catch (e) {
      error.value = 'Failed to load posts: $e';
      Snackbar.showError(
        "Error",
        'Failed to load posts: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshPosts() async {
    posts.clear();
    await getAllPosts();
  }
}