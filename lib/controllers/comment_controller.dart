import 'package:get/get.dart';

import '../components/snackbar.dart';
import '../models/comment_model.dart';
import '../service/comment_service.dart';

class CommentController extends GetxController {
  final CommentService _commentService = Get.find<CommentService>();

  final RxList<Comment> comments = <Comment>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> fetchComments(int postId) async {
    try {
      isLoading.value = true;

      final fetchedComments = await _commentService.getComments(postId);

      comments.assignAll(fetchedComments);
    } catch (e) {
      Snackbar.showError('Error','Failed to load comments');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addComment(int postId, String content, int point) async {
    if (content.isEmpty) return;

    try {
      isLoading.value = true;
      final success = await _commentService.addComment(postId, content, point);

      if (success) {
        await fetchComments(postId);
        Snackbar.showSuccess('Success','Comment added!');
      } else {
        Snackbar.showError("Error", "Failed to upload your comment!");
      }
    } catch (e) {
      Snackbar.showError("Error", "Failed to upload your comment!");
    } finally {
      isLoading.value = false;
    }
  }

  void clearComments() {
    comments.clear();
  }

  void sortCommentsByDate() {
    comments.sort((a, b) => b.createdOn.compareTo(a.createdOn));
    comments.refresh();
  }

  void sortCommentsByRating() {
    comments.sort((a, b) => b.point.compareTo(a.point));
    comments.refresh();
  }

  @override
  void onClose() {
    clearComments();
    super.onClose();
  }
}