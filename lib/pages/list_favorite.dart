import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/favorite_controller.dart';
import '../components/post_card.dart';
import '../controllers/post_controler.dart';
import 'detail_post.dart';

class FavoritePage extends GetView<FavoriteController> {
  final PostController postController = Get.put(PostController());

  FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF80EE98),
        automaticallyImplyLeading: false,
        title: Text(
          'Favorite Page',
          style: GoogleFonts.lexendDeca(
            color: Color(0xFF213A58),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.0,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchFavorites();
        },
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final favoritePosts = postController.posts
              .where((post) => controller.isFavorite(post.id))
              .toList();

          if (favoritePosts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No favorite posts yet.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Your favorite posts will be displayed here.",
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoritePosts.length,
            itemBuilder: (context, index) {
              final post = favoritePosts[index];
              return ListCarCard(
                post: post,
                onTap: () {
                  Get.to(() => DetailPage(post: post));
                },
                onUnfavorite: () => controller.removeFromFavorite(post.id),
                
              );
            },
          );
        }),
      ),
    );
  }
}

