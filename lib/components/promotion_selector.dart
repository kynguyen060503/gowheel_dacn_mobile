import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/admin_promotion_controller.dart';
import '../models/promotion_model.dart';

class PromotionSelector extends StatefulWidget {
  final List<Promotion> postPromotions;
  final Function(Promotion?) onPromotionSelected;
  final bool showExpired;

  const PromotionSelector({
    super.key,
    required this.postPromotions,
    required this.onPromotionSelected,
    this.showExpired = false,
  });

  @override
  _AdvancedPromotionSelectorState createState() => _AdvancedPromotionSelectorState();
}

class _AdvancedPromotionSelectorState extends State<PromotionSelector> {
  Promotion? _selectedPromotion;
  late PromotionController promotionController;
  final RxBool _showExpired = false.obs;

  @override
  void initState() {
    super.initState();
    promotionController = Get.put(PromotionController());
    _showExpired.value = widget.showExpired;
  }

  bool isPromotionExpired(Promotion promo) {
    final expiryDate = DateTime.parse(promo.expiredDate);
    return expiryDate.isBefore(DateTime.now());
  }

  bool isPromotionValid(Promotion promo) {
    return !promo.isDeleted && !isPromotionExpired(promo);
  }

  List<Promotion> filterPromotions(List<Promotion> promotions, bool showExpired) {
    if (showExpired) {
      return promotions.where((promo) =>
        !promo.isDeleted && isPromotionExpired(promo)
      ).toList();
    } else {
      return promotions.where((promo) => isPromotionValid(promo)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Promotions',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF213A58),
          ),
        ),
        Row(
          children: [
            Obx(() => Switch(
              value: _showExpired.value,
              onChanged: (value) {
                _showExpired.value = value;
                setState(() {
                  _selectedPromotion = null;
                });
                widget.onPromotionSelected(null);
              },
            )),
            Text(
              _showExpired.value ? 'Show expired promotions' : 'Show active promotions',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                color: const Color(0xFF213A58),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (promotionController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (promotionController.error.value.isNotEmpty) {
            return Text(
              'Error: ${promotionController.error.value}',
              style: const TextStyle(color: Colors.red),
            );
          }

          final filteredAdminPromotions = filterPromotions(
              promotionController.promotions,
              _showExpired.value
          );

          return _buildPromotionSection(
            _showExpired.value ? 'Expired Admin Promotions' : 'Active Admin Promotions',
            filteredAdminPromotions,
          );
        }),
        const SizedBox(height: 8),
        Obx(() {
          final filteredPostPromotions = filterPromotions(
              widget.postPromotions,
              _showExpired.value
          );

          return _buildPromotionSection(
            _showExpired.value ? 'Expired Post Owner Promotions' : 'Active Post Owner Promotions',
            filteredPostPromotions,
          );
        }),
      ],
    );
  }

  Widget _buildPromotionSection(String title, List<Promotion> promotions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF213A58),
          ),
        ),
        if (promotions.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              _showExpired.value
                  ? 'No expired promotions'
                  : 'No active promotions',
              style: GoogleFonts.urbanist(
                color: Colors.grey,
              ),
            ),
          )
        else
          ...promotions.map((promotion) {
            final bool isSelected = _selectedPromotion == promotion;
            final bool isExpired = isPromotionExpired(promotion);

            return RadioListTile<Promotion>(
              title: promotion.discountValue < 1
                  ? Text(
                      '${promotion.content} (Discount ${promotion.discountValue * 100}%)',
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.black,
                        decoration: isExpired ? TextDecoration.lineThrough : null,
                      ),
                    )
                  : Text(
                      '${promotion.content} (Discount ${promotion.discountValue.toStringAsFixed(0)}k)',
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.black,
                        decoration: isExpired ? TextDecoration.lineThrough : null,
                      ),
                    ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expires: ${_formatExpiryDate(promotion.expiredDate)}',
                    style: TextStyle(
                      color: isSelected ? Colors.blue[300] : Colors.grey,
                    ),
                  ),
                  if (isExpired)
                    const Text(
                      'Expired',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
              value: promotion,
              groupValue: _selectedPromotion,
              onChanged: isExpired ? null : (Promotion? selected) {
                setState(() {
                  _selectedPromotion = selected;
                });
                widget.onPromotionSelected(_selectedPromotion);
              },
            );
          }).toList(),
      ],
    );
  }

  String _formatExpiryDate(String dateString) {
    final DateTime expiryDate = DateTime.parse(dateString);
    return '${expiryDate.day}/${expiryDate.month}/${expiryDate.year}';
  }
}
