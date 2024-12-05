import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/comment_controller.dart';
import 'comment_item.dart';

class CommentSectionWidget extends StatelessWidget {
  final int postId;
  final CommentController controller = Get.put(CommentController());
  final TextEditingController commentController = TextEditingController();
  final RxInt rating = 5.obs;

  CommentSectionWidget({
    Key? key,
    required this.postId,
  }) : super(key: key) {
    controller.fetchComments(postId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Comments",
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Obx(() => Text(
                '(${controller.comments.length})',
                style: GoogleFonts.urbanist(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              )),
            ],
          ),
          Row(
            children: [
              Text('Rating: ', style: GoogleFonts.urbanist()),
              Obx(() => Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating.value ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () => rating.value = index + 1,
                      );
                    }),
                  )),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    hintStyle: GoogleFonts.urbanist(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  maxLines: null,
                ),
              ),
              SizedBox(width: 8),
              Obx(() => controller.isLoading.value
                  ? Container(
                      width: 40,
                      height: 40,
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: Icon(Icons.send),
                      color: Theme.of(context).primaryColor,
                      onPressed: () async {
                        if (commentController.text.trim().isNotEmpty) {
                          await controller.addComment(
                            postId,
                            commentController.text.trim(),
                            rating.value,
                          );
                          commentController.clear();
                          rating.value = 5; // Reset rating after submitting
                        }
                      },
                    )),
            ],
          ),
          SizedBox(height: 8),
          // Comments list
          Text(
            "Comment List",
            style: GoogleFonts.urbanist(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Obx(() => controller.comments.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'No comments yet',
                      style: GoogleFonts.urbanist(color: Colors.grey),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.comments.length,
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    final comment = controller.comments[index];
                    return CommentItem(comment: comment);
                  },
                )),
        ],
      ),
    );
  }
}
