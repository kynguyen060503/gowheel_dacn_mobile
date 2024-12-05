import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../components/snackbar.dart';
import '../controllers/user_promotion_controller.dart';
import 'list_user_promotion.dart';

class AddUserPromotionScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final _discountController = TextEditingController();
  final Rx<DateTime> _expiredDate = DateTime.now().add(const Duration(days: 7)).obs;

  AddUserPromotionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserPromotionController());

    return Scaffold(
      appBar:  AppBar(
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
          'Add Promotion',
          style: GoogleFonts.lexendDeca(
            color: Color(0xFF213A58),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.0,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(
            () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.error.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            controller.error.value,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      Text("Promotion content",
                        style:  GoogleFonts.urbanist(
                          color: const Color(0xFF213A58),
                          fontSize: 20,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _contentController,
                        decoration: InputDecoration(
                          hintText: "Ex: NewUser...",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: const OutlineInputBorder()
                        ),
                        validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                      ),

                      const SizedBox(height: 10),
                      Text("Discount value (each 0.1 equal 10% or 1000 for -1k in total)",
                        style:  GoogleFonts.urbanist(
                          color: const Color(0xFF213A58),
                          fontSize: 20,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _discountController,
                        decoration: InputDecoration(
                          hintText: "Ex: 0.1 or 10000.....",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: const OutlineInputBorder()
                        ),
                        validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                      ),

                      const SizedBox(height: 10),
                      Text("Expired date",
                        style:  GoogleFonts.urbanist(
                          color: const Color(0xFF213A58),
                          fontSize: 20,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF213A58), width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            title: Text(
                              'Expired date',
                              style: GoogleFonts.urbanist(
                                color: const Color(0xFF213A58),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              DateFormat('yyyy-MM-dd').format(_expiredDate.value),
                              style: TextStyle(color: Colors.black87),
                            ),
                            trailing: const Icon(Icons.calendar_today, color: Color(0xFF213A58)),
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _expiredDate.value,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Color(0xFF80EE98),
                                        onPrimary: Color(0xFF213A58),
                                        surface: Colors.white,
                                        onSurface: Color(0xFF213A58),
                                      ),
                                      dialogBackgroundColor: Colors.white,
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                _expiredDate.value = picked;
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Choose post to apply promotion:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: const Color(0xFF213A58), width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Obx(() => ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              leading: Checkbox(
                                value: controller.selectedPostIds.length == controller.userPosts.length,
                                onChanged: (bool? value) {
                                  controller.toggleSelectAll();
                                },
                              ),
                              title: Text(
                                'Apply to all',
                                style: GoogleFonts.urbanist(
                                  color: const Color(0xFF213A58),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )),
                            const Divider(height: 1),
                            Obx(() => ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.userPosts.length,
                                itemBuilder: (context, index) {
                                  final post = controller.userPosts[index];
                                  return ListTile(
                                    leading:Obx(() => Checkbox(
                                      value: controller.selectedPostIds.contains(post.id),
                                      onChanged: (bool? value) {
                                        controller.togglePostSelection(post.id);
                                      },
                                    ),
                                    ),
                                    title: Text(post.name),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Price per hour: ${post.pricePerHour.toStringAsFixed(0)}\đ'),
                                        Text(
                                            'Price per day: ${post.pricePerDay.toStringAsFixed(0)}\đ'),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Obx(
                        () => ElevatedButton(
                      onPressed: controller.selectedPostIds.isEmpty
                          ? null
                          : () => _submitPromotion(context, controller),
                      child: const Text('Add Promotion'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitPromotion(
      BuildContext context, UserPromotionController controller) async {
    if (_formKey.currentState!.validate()) {
      final success = await controller.submitPromotion(
        content: _contentController.text,
        discountValue: double.parse(_discountController.text),
        expiredDate: _expiredDate.value,
      );
      controller.fetchUserPromotions();
      if (success) {
        Snackbar.showSuccess(
          'Success',
          'Promotion added successfully'
        );
        Get.to(()=>UserPromotionListScreen());
      }
    }
  }
}