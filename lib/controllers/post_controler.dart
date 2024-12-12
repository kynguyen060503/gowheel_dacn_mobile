import 'package:flutter/material.dart';
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
      error.value = ''; // Reset error

      final postsList = await _postService.getAllPosts();

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (postsList.isEmpty) {
          Snackbar.showError("Error", "No posts found!");
        } else {
          posts.assignAll(postsList);
        }
      });Future<void> addPost({
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
      
          await Future.delayed(const Duration(milliseconds: 100)); // Delay the execution of the callback
      
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (success) {
              Snackbar.showSuccess('Success','Post added successfully');
              refreshPosts();
            } else {
              Snackbar.showError('Error','Failed to add post');
            }
          });
        } catch (e) {
          error.value = 'Failed to add post: $e';
          
          await Future.delayed(const Duration(milliseconds: 100)); // Delay the execution of the callback
      
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Snackbar.showError("Error", "Lost connection to server!");
          });
        }
      }
    } catch (e) {
      error.value = 'Failed to load posts: $e';
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 100));
        Snackbar.showError("Error", "Lost connection to server!");
      });
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

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (success) {
          refreshPosts();
        } else {
          Snackbar.showError('Error','Failed to add post');
        }
      });
    } catch (e) {
      error.value = 'Failed to add post: $e';
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Snackbar.showError('Error','Failed to add post');
      });
    } finally {
      isAddingPost.value = false;
    }
  }

  Future<void> getPersonalPost() async {
    try {
      isLoading.value = true;
      error.value = ''; // Reset error

      final postsList = await _postService.getAllPersonalPosts();

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (postsList.isEmpty) {
          Snackbar.showError("Error", "No personal posts found");
          error.value = 'No posts found';
        } else {
          posts.assignAll(postsList);
        }
      });
    } catch (e) {
      error.value = 'Failed to load posts: $e';
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Snackbar.showError("Error", 'Failed to load posts: $e');
      });
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshPosts() async {
    posts.clear();
    await getAllPosts();
  }
}