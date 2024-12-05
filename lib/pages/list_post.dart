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

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.posts.length,
          itemBuilder: (context, index) {
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
        );
      }),
    );
  }
}