import 'package:flutter/scheduler.dart';
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
  final RxList<String> selectedImageList = <String>[].obs;
  final RxString error = ''.obs;
  final pageIndex = 2.obs;
  final int pageSize = 8; 
  final RxBool isLoadingMore = false.obs;

  // For single post
  final Rxn<Post> currentPost = Rxn<Post>();
  final RxBool isLoadingPost = false.obs;
  final RxBool hasMorePosts = true.obs;

  // Add new observable for personal posts
  final RxList<Post> personalPosts = <Post>[].obs;
  final RxBool isLoadingPersonal = false.obs;
  final RxString personalError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getAllPosts();
  }

  Future<void> getAllPosts() async {
    try {
      isLoading.value = true;
      error.value = ''; // Reset error

      final postsList = await _postService.getAllPosts();

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (postsList.isEmpty) {
          Snackbar.showError("Error", "No posts found!");
        } else {
          posts.assignAll(postsList);
        }
      });
    } catch (e) {
      error.value = 'Failed to load posts: $e';
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
      error.value = ''; // Reset error

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
          refreshPosts();
          Snackbar.showSuccess('Success','Post added successfully');
        } else {
          Snackbar.showError('Error','Failed to add post');
        }
    } catch (e) {
      error.value = 'Failed to add post: $e';
        Snackbar.showError('Error','Failed to add post');
    } finally {
      isAddingPost.value = false;
    }
  }

  Future<void> getPersonalPosts() async {
    try {
      isLoadingPersonal.value = true;
      personalError.value = ''; // Reset error

      final postsList = await _postService.getAllPersonalPosts();
      
      if (postsList.isEmpty) {
        Snackbar.showError("Notice", "No personal posts found");
      } else {
        personalPosts.assignAll(postsList);
      }
    } catch (e) {
      personalError.value = 'Failed to load personal posts: $e';
      Snackbar.showError("Error", 'Failed to load personal posts');
    } finally {
      isLoadingPersonal.value = false;
    }
  }

  Future<void> loadMorePost() async {
  if (isLoadingMore.value || !hasMorePosts.value) return;

  try {
    isLoadingMore.value = true;
    print("Loading posts for page: ${pageIndex.value}");

    final newPosts = await _postService.loadMorePosts(pageIndex.value);
    print("Loaded ${newPosts.length} posts for page ${pageIndex.value}");

    if (newPosts.isEmpty) {
      hasMorePosts.value = false;
      return;
    }

    final uniquePosts = newPosts.where((post) => 
        !posts.any((existingPost) => existingPost.id == post.id)).toList();

    posts.addAll(uniquePosts);
    print("Added ${uniquePosts.length} unique posts for page ${pageIndex.value}");

    // Tăng chỉ số trang
    pageIndex.value++;
  } catch (e) {
    Snackbar.showError("Error", "Failed to load more posts");
    hasMorePosts.value = false;
  } finally {
    isLoadingMore.value = false;
  }
}


  void resetPageIndex() {
    pageIndex.value = 2;
    posts.clear();
    hasMorePosts.value = true;
  }

  Future<void> refreshPosts() async {
    await getAllPosts();
  }
}