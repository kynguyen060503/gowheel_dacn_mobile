import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gowheel_flutterflow_ui/pages/detail_post.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/favorite_controller.dart';
import '../controllers/post_controler.dart';
import '../models/post_model.dart';
import '../url.dart';

class PostList extends StatelessWidget {
  final PostController postController = Get.find<PostController>();
  final FavoriteController favoriteController = Get.find<FavoriteController>();

  PostList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (postController.isLoading.value) {
        return _buildSkeletonLoader();
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: postController.posts
                .asMap()
                .map((index, post) => MapEntry(
                index, _buildCarCard(context, post, index)))
                .values
                .toList(),
          ),
        ),
      );
    });
  }

  Widget _buildSkeletonLoader() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: List.generate(3, (index) => _buildSkeletonCarCard()),
        ),
      ),
    );
  }

  Widget _buildSkeletonCarCard() {
    return Skeletonizer(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          border: Border.all(  
            color: Colors.grey,
            width: 3.0,       
          ),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(right: 16),
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Rating and Location Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: const Text('Location'),
                ),
                const Row(
                  children: [
                    Text('4.5'),
                    Icon(Icons.star),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Car Image Placeholder
            Container(
              height: 120,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            // Car Type and Company
            const Text('Car Name'),
            const SizedBox(height: 8),
            const Text('Car Type - Company'),
            // Price Row
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price VND'),
                    Text('per hour'),
                  ],
                ),
                Icon(Icons.favorite_border),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarCard(BuildContext context, Post post, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(post: post),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          border: Border.all(  
            color: Colors.grey,
            width: 3.0,       
          ),
        ),
        padding: const EdgeInsets.all(16),
        margin: EdgeInsets.only(
          right: 16,
          left: index == 0 ? 16 : 0,
        ),
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Rating and Location Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    post.rentLocation,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${post.avgRating?.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.amber,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Car Image
            Container(
              height: 120,
              child: Center(
                child: Image.network(
                  URL.imageUrl + post.image,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'images/car_demo_item.jpg',
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Car name
            Text(
              post.name,
              style: GoogleFonts.lexendDeca(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1,
                letterSpacing: 0.0,
                color: const Color(0xFF213A58),
              ),
            ),

            const SizedBox(height: 8),
            // Car company-cartype
            Text(
              "${post.carTypeName} - ${post.companyName}",
              style: GoogleFonts.urbanist(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
                letterSpacing: 0.2,
              ),
            ),

            // Price Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${post.pricePerHour.toStringAsFixed(0)} VND",
                      style: GoogleFonts.lexendDeca(
                        color: Colors.red,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                      ),
                    ),
                    Text(
                      "per hour",
                      style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                          letterSpacing: 0.2,
                        ),
                    ),
                  ],
                ),
                Obx(() => IconButton(
                  icon: Icon(
                    favoriteController.isFavorite(post.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: favoriteController.isFavorite(post.id)
                        ? Colors.red
                        : null,
                  ),
                  onPressed: favoriteController.isLoading.value
                      ? null
                      : () async {
                    if (favoriteController.isFavorite(post.id)) {
                      await favoriteController
                          .removeFromFavorite(post.id);
                    } else {
                      await favoriteController.addToFavorite(post.id);
                    }
                  },
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}