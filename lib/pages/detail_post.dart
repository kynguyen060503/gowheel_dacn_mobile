import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gowheel_flutterflow_ui/components/snackbar.dart';
import 'package:gowheel_flutterflow_ui/url.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/favorite_controller.dart';
import '../components/comment_section.dart';
import '../components/datetime_range_picker.dart';
import '../components/map_picker.dart';
import '../components/promotion_selector.dart';
import '../components/report_bottom_sheet.dart';
import '../controllers/user_controller.dart';
import '../models/booking_request_model.dart';
import '../models/post_model.dart';
import '../models/promotion_model.dart';
import '../service/comment_service.dart';

class DetailPage extends StatefulWidget {
  final Post post;

  const DetailPage({super.key, required this.post});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  Promotion? selectedPromotion;
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool isOwner = false;
  Rx<bool> isRequestDriver = false.obs;
  int _currentImageIndex = 0;
  LatLng? _pickedLocation;
  String _pickedAddress = 'No location selected';

  final FavoriteController _favoriteController = Get.put(FavoriteController());
  final BookingController _bookingController = Get.put(BookingController());
  // ignore: unused_field
  final CommentService _commentService = Get.put(CommentService());

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _checkIfOwner();
  }

  void _pickLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPickerScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        _pickedLocation = result['location'];
        _pickedAddress = result['address'];
      });
    }
  }

  Future<void> _checkIfOwner() async {
    try {
      final userController = Get.find<UserController>();
      final currentUserId = userController.currentUser.value?.id;
      final postUserId = widget.post.user?.id;

      setState(() {
        isOwner = currentUserId != null &&
            postUserId != null &&
            currentUserId == postUserId;
      });
    } catch (e) {
      setState(() {
        isOwner = false;
      });
    }
  }

  Future<void> _loadFavorites() async {
    await _favoriteController.fetchFavorites();
  }

  Future<void> handleBooking() async {

    if (_pickedLocation == null) {
      Snackbar.showError(
        'Error',
        'Please choose ',
      );
      return;
    }

    final start = DateTime(
      startDate!.year,
      startDate!.month,
      startDate!.day,
      startTime!.hour,
      startTime!.minute,
    );

    final end = DateTime(
      endDate!.year,
      endDate!.month,
      endDate!.day,
      endTime!.hour,
      endTime!.minute,
    );

    final request = BookingRequest(
      prePayment: calculatedPrepayPrice() ?? 0,
      total: calculateTotalPrice(),
      finalValue: calculateFinalPrice() ?? 0,
      recieveOn: start,
      returnOn: end,
      isRequireDriver: isRequestDriver.value,
      postId: widget.post.id,
      promotionId: selectedPromotion?.id,
      discountValue: selectedPromotion?.discountValue ?? 0,
      longitude: _pickedLocation?.longitude.toString() ?? '', // Truyền longitude
      latitude: _pickedLocation?.latitude.toString() ?? '',   // Truyền latitude
    );

    final result = await _bookingController.createBooking(request);

    if (result) {
      Snackbar.showSuccess(
        'Success',
        'Booking successfully!\n ',
      );
    } else {
      Snackbar.showError(
        'Error',
        'Booking failed!'
      );
    }
  }

  double get numberOfHours {
    if (startDate == null || endDate == null || startTime == null || endTime == null) {
      return 0;
    }
    final start = DateTime(
      startDate!.year,
      startDate!.month,
      startDate!.day,
      startTime!.hour,
      startTime!.minute,
    );
    final end = DateTime(
      endDate!.year,
      endDate!.month,
      endDate!.day,
      endTime!.hour,
      endTime!.minute,
    );
    return end.difference(start).inHours.toDouble();
  }
  double calculateTotalPrice(){
    if (startDate == null || endDate == null || startTime == null || endTime == null) {
      return 0;
    }
    double totalPrice;
    if (numberOfHours % 24 == 0) {
      // Nếu số giờ là bội số của 24 (đủ ngày) thì tính theo ngày
      int numberOfDays = (numberOfHours / 24).toInt();
      totalPrice = widget.post.pricePerDay * numberOfDays;
    } else {
      // Nếu không phải bội số của 24 thì tính theo giờ
      totalPrice = widget.post.pricePerHour * numberOfHours;
    }
    return totalPrice;
  }

  double? calculateFinalPrice() {
    if (selectedPromotion != null) {
      if (selectedPromotion!.discountValue < 1) {
        // Giảm giá theo phần trăm
        double discount = calculateTotalPrice() * selectedPromotion!.discountValue;
        return calculateTotalPrice() - discount;
      } else {
        // Giảm giá theo số tiền cố định
        return calculateTotalPrice() - selectedPromotion!.discountValue;
      }
    }
    return calculateTotalPrice();
  }

  double? calculatedPrepayPrice(){
    return calculateTotalPrice() * 0.5;
  }

  Widget _buildImageCarousel() {
    List<String> allImages = [widget.post.image];
    if (widget.post.images != null) {
      allImages.addAll(widget.post.images!);
    }

    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: allImages.length,
          itemBuilder: (context, index, realIndex) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: Image.network(
                URL.imageUrl+ allImages[index],
                fit: BoxFit.cover,
              ),
            );
          },
          options: CarouselOptions(
            height: 250,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            enableInfiniteScroll: allImages.length > 1,
            onPageChanged: (index, reason) {
              setState(() {
                _currentImageIndex = index;
              });
            },
          ),
        ),
        // Indicators
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: allImages.asMap().entries.map((entry) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(
                    _currentImageIndex == entry.key ? 0.9 : 0.4,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
      FocusScope.of(context).unfocus();
    },
      child: Scaffold(
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
          widget.post.name,
          style: GoogleFonts.lexendDeca(
            color: const Color(0xFF213A58),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.0,
          ),
        ),
          actions: [
            Obx(() => IconButton(
              icon: Icon(
                _favoriteController.isFavorite(widget.post.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: _favoriteController.isFavorite(widget.post.id)
                    ? Colors.red
                    : null,
              ),
              onPressed: _favoriteController.isLoading.value
                  ? null
                  : () async {
                if (_favoriteController.isFavorite(widget.post.id)) {
                  await _favoriteController.removeFromFavorite(widget.post.id);
                } else {
                  await _favoriteController.addToFavorite(widget.post.id);
                }
              },
            )),
          ],
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ảnh xe
              _buildImageCarousel(),
              // Thông tin chi tiết
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên và giá
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.post.name,
                                style: GoogleFonts.lexendDeca(
                                  color: const Color(0xFF213A58),
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.0,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                              Text(
                                '${widget.post.companyName}-${widget.post.carTypeName}',
                                style:GoogleFonts.lexendDeca(
                                  color: const Color(0xFF213A58),
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ],
                          ),
                        ),
      
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${widget.post.pricePerHour.toStringAsFixed(0)}VND/hour",
                                style: GoogleFonts.lexendDeca(
                                  color: Colors.red,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.0,
                                ),
                            ),
                            Text(
                              "Or\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t",
                              style: GoogleFonts.lexendDeca(
                                  color: const Color(0xFF213A58),
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.0,
                                ),
                            ),
                            Text(
                              "${widget.post.pricePerDay.toStringAsFixed(0)}VND/day",
                              style: GoogleFonts.lexendDeca(
                                  color: Colors.red,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.0,
                                ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    // Mô ta
                    Text(
                      "Description",
                      style: GoogleFonts.urbanist(
                        color: const Color(0xFF213A58),
                        fontSize: 20,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(widget.post.description,style: GoogleFonts.urbanist(
                      color: Colors.red,
                      fontSize: 20,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),),
                    const Divider(),
                    Text(
                      "Detailed Information of the Car:",
                      style: GoogleFonts.urbanist(
                          color: const Color(0xFF213A58),
                          fontSize: 20,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                    ),
                    const Divider(),
                    // Thông số kỹ thuật
                    Text(
                      "Specifications",
                      style: GoogleFonts.urbanist(
                          color: const Color(0xFF213A58),
                          fontSize: 20,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                    ),
                    const SizedBox(height: 8),
                    _buildSpecItem("Gear", widget.post.gear ? 'Manual' : "Automatic"),
                    _buildSpecItem("Seating Capacity", "${widget.post.seat} seats"),
                    _buildSpecItem("Fuel", widget.post.fuel),
                    _buildSpecItem("Fuel Consumption", "${widget.post.fuelConsumed} L/100km"),
                    _buildSpecItem("Number of Rides Rented", '${widget.post.rideNumber}'),
                    const Divider(),
      
                    Text(
                      "Rental Type: ${widget.post.hasDriver ? "Car rental with a driver provided" : "Self-drive or hire an external driver"}", 
                      style: GoogleFonts.urbanist(
                          color: const Color(0xFF213A58),
                          fontSize: 20,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                    ),

                    const Divider(),
      
                    if (widget.post.user != null) ...[
                      Text(
                        "Car Owner",
                        style: GoogleFonts.urbanist(
                          color: const Color(0xFF213A58),
                          fontSize: 20,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: widget.post.user?.image != null
                                ? NetworkImage(URL.imageUrl + "${widget.post.user?.image}")
                                : const AssetImage('assets/images/default_avartar.png'),
                          ),
      
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post.user!.name,
                                  style: GoogleFonts.urbanist(
                                    color: const Color(0xFF213A58),
                                    fontSize: 20,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    if(!isOwner)...[
                    const Divider(),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF80EE98).withOpacity(.3),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF80EE98).withOpacity(.3), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DateTimeRangePickerWidget(
                            startDate: startDate,
                            endDate: endDate,
                            startTime: startTime,
                            endTime: endTime,
                            numberOfDays: numberOfHours > 0 ? (numberOfHours / 24)
                                .ceil() : 0,
                            onDateTimeRangeSelected: (start, end, pickStartTime,
                                pickEndTime) {
                              setState(() {
                                startDate = start;
                                endDate = end;
                                startTime = pickStartTime;
                                endTime = pickEndTime;
                              });
                            },
                          ),
                          Divider(color: Colors.blue[100]),
                          PromotionSelector(
                            postPromotions: widget.post.postPromotion,
                            onPromotionSelected: (promotion) {
                              setState(() {
                                selectedPromotion = promotion;
                              });
                            },
                          ),
                          if(widget.post.hasDriver == false)
                            Divider(color: Colors.blue[100]),
                          if(!widget.post.hasDriver == false)
                            Obx(() => SwitchListTile(
                              title: const Text('Want to rent Driver?'),
                              value: isRequestDriver.value,
                              onChanged: (bool value) {
                                isRequestDriver.value = value;
                              },
                              activeColor: Colors.blue,
                            )),
                            Text(
                              'Pick-up Location',
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF213A58), // You can adjust the color if needed
                              ),
                            ),
                            GestureDetector(
                              onTap: _pickLocation,
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _pickedAddress,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            if (_pickedLocation != null) ...[
                              SizedBox(height: 16),
                              Text(
                                'Coordinates: (${_pickedLocation?.latitude}, ${_pickedLocation?.longitude})',
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                        ],
                      ),
                    )
                  ]
                  else
                    const Divider(),
      
                    if(!isOwner)...[
                    // Comment section
                    const Divider(),
                    CommentSectionWidget(postId: widget.post.id),
                    // Report Section
                    const Divider(),
                    Row(
                      children: [
                        Text("Post in violation?",style: GoogleFonts.urbanist(
                          color: const Color(0xFF213A58),
                          fontSize: 20,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),),
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => ReportBottomSheet(postId: widget.post.id),
                            );
                          },
                          icon: const Icon(Icons.report_problem, color: Colors.red),
                        )
                      ],
                    )
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      
        //BottomNavBar
        bottomNavigationBar: Obx(() => Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (numberOfHours > 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rental Duration:',
                      style: GoogleFonts.urbanist(fontSize: 16),
                    ),
                    Text(
                      numberOfHours % 24 == 0
                          ? '${(numberOfHours / 24).toInt()} days'  // Display in days if exact
                          : '${numberOfHours.toStringAsFixed(1)} hour',  // Display in hours if not exact
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Estimated Price:',
                      style: GoogleFonts.urbanist(fontSize: 16),
                    ),
                    Text(
                      numberOfHours % 24 == 0
                          ? '${((numberOfHours / 24) * widget.post.pricePerDay).toStringAsFixed(0)}đ'
                          : '${(widget.post.pricePerHour * numberOfHours).toStringAsFixed(0)}đ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
              if (selectedPromotion != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Discount Code: ${selectedPromotion!.content}',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selectedPromotion!.discountValue < 1
                        ? Text(
                            '-${selectedPromotion!.discountValue * 100}%',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            '-${selectedPromotion!.discountValue.toStringAsFixed(0)}k',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ],
                ),
              ],
              if (isRequestDriver.value == true) ...[
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Car requires a driver",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              if (numberOfHours > 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: GoogleFonts.urbanist(fontSize: 16),
                    ),
                    Text(
                      '${calculateFinalPrice()?.toStringAsFixed(0) ?? 0}đ', // Use calculateFinalPrice method
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Deposit:',
                      style: GoogleFonts.urbanist(fontSize: 16),
                    ),
                    Text(
                      '${calculatedPrepayPrice()?.toStringAsFixed(0) ?? 0}đ', // Use calculateFinalPrice method
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 18),
                    ),
                  ],
                ),
              ],
              if (isOwner) ...[
                ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    "Edit Rental Post",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: numberOfHours > 0 ? handleBooking : null,
                  child: Obx(() => _bookingController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          numberOfHours > 0 ? "Book Now" : "Please select rental time",
                          style: const TextStyle(fontSize: 18),
                        ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                ),
              ],
            ],
          ),
        ),
      )
      ),
    );
  }

  Widget _buildSpecItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: GoogleFonts.urbanist(
                    color: const Color(0xFF213A58),
                    fontSize: 15,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                  ),
          ),
          Text(value,
          style: GoogleFonts.urbanist(
            color: Colors.red,
            fontSize: 20,
            letterSpacing: 0.0,
            fontWeight: FontWeight.bold,
          ),),
        ],
      ),
    );
  }

}