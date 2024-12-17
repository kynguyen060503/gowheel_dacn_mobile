import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/post_card.dart';
import '../controllers/post_controler.dart';
import 'detail_post.dart';

class AvailableCarsPage extends GetView<PostController> {
  const AvailableCarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF80EE98),
        title: Text(
          'Available Cars',
          style: GoogleFonts.lexendDeca(
            color: const Color(0xFF213A58),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            // Check if we've reached the bottom of the list
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              // Only load more if we have more posts
              if (controller.hasMorePosts.value) {
                controller.loadMorePost();
              }
            }
            return false;
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.posts.length + 
                      (controller.hasMorePosts.value ? 1 : 0),
            itemBuilder: (context, index) {
              // If we've reached the last item and have more posts, show a loading indicator
              if (index == controller.posts.length) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final post = controller.posts[index];
              return ListCarCard(
                post: post,
                onTap: () {
                  Get.to(() => DetailPage(post: post));
                },
                onUnfavorite: () {},
                enableDismiss: false,
              );
            },
          ),
        );
      }),
    );
  }
}