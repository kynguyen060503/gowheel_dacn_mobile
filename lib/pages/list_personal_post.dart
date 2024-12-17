import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/post_card.dart';
import '../controllers/post_controler.dart';
import 'detail_post.dart';

class PersonalPostsPage extends GetView<PostController> {
  const PersonalPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Call getPersonalPosts when the page is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getPersonalPosts();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF80EE98),
        title: Text(
          'Your Personal Posts',
          style: GoogleFonts.lexendDeca(
            color: const Color(0xFF213A58),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF213A58)),
            onPressed: () => controller.getPersonalPosts(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.getPersonalPosts(),
        child: Obx(() {
          if (controller.isLoadingPersonal.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.personalError.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to load posts',
                    style: GoogleFonts.lexendDeca(
                      color: Colors.red,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.getPersonalPosts(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (controller.personalPosts.isEmpty) {
            return Center(
              child: Text(
                'No posts available',
                style: GoogleFonts.lexendDeca(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.personalPosts.length,
            itemBuilder: (context, index) {
              final post = controller.personalPosts[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ListCarCard(
                  post: post,
                  onTap: () => Get.to(() => DetailPage(post: post)),
                  onUnfavorite: () {},
                  enableDismiss: false,
                ),
              );
            },
          );
        }),
      ),
    );
  }
}