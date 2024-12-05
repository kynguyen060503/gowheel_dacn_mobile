import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gowheel_flutterflow_ui/components/snackbar.dart';
import 'package:intl/intl.dart';

import '../controllers/user_promotion_controller.dart';
import 'add_promotion_user.dart';

class UserPromotionListScreen extends StatelessWidget {
  final UserPromotionController _controller = Get.put(UserPromotionController());

  UserPromotionListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF80EE98),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF213A58),
            size: 24,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Promotion List',
          style: GoogleFonts.lexendDeca(
            color: Color(0xFF213A58),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.0,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Get.to(() => AddUserPromotionScreen()),
            label: Text('Add',
             style: GoogleFonts.lexendDeca(
              color: Color(0xFF213A58),
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.0,
            ),
          ),
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            // Gọi phương thức fetch lại promotions
            await _controller.fetchUserPromotions();
          },
          child: _buildPromotionContent(),
        );
      }),
    );
  }

  Widget _buildPromotionContent() {
    if (_controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.userPromotions.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          await _controller.fetchUserPromotions();
        },
        child: const Center(
          child: Text(
            'No post promotion yet. Add one!',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(), // Quan trọng cho RefreshIndicator
      itemCount: _controller.userPromotions.length,
      itemBuilder: (context, index) {
        final promotion = _controller.userPromotions[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(
              promotion.content,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                promotion.discountValue < 1 ?
                Text(
                  'Giảm: ${(promotion.discountValue * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(color: Colors.green),
                )
                    :
                Text(
                  'Giảm: -${promotion.discountValue.toStringAsFixed(0)}k',
                  style: const TextStyle(color: Colors.green),
                )
                ,
                Text(
                  'Hết hạn ngày: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(promotion.expiredDate))}',
                  style: TextStyle(
                    color: DateTime.parse(promotion.expiredDate).isBefore(DateTime.now())
                        ? Colors.red
                        : Colors.black54,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _showDeleteConfirmationDialog(context, promotion.id);
              },
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int promotionId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Promotion'),
        content: const Text('Are you sure you want to delete this promotion?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: _controller.isLoading.value
                ? null
                : () async {
              // Gọi hàm xóa từ controller
              bool success = await _controller.deletePromotion(promotionId);

              // Đóng dialog
              Navigator.of(context).pop();

              // Hiển thị thông báo
              if (success) {
                Snackbar.showSuccess("Sucess", "Promotion Deleted Sucessfully");
              } else {
                Snackbar.showError("Error", "Cannot Deleted Promotion");
              }
            },
            child: _controller.isLoading.value
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Text('Delete'),
          )),
        ],
      ),
    );
  }
}