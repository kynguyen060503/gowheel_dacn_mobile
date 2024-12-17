import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gowheel_flutterflow_ui/components/notification_icon.dart';
import 'package:gowheel_flutterflow_ui/components/post_list.dart';
import 'package:gowheel_flutterflow_ui/pages/list_search.dart';

import '../controllers/favorite_controller.dart';
import '../controllers/post_controler.dart';
import 'list_post.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final PostController postController = Get.put(PostController());
  final FavoriteController favoriteController = Get.put(FavoriteController());

   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    postController.refreshPosts();
    _loadFavorites();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      postController.refreshPosts();
      _loadFavorites();
    }
  }

  Future<void> _loadFavorites() async {
    await favoriteController.fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF80EE98),
        automaticallyImplyLeading: false,
        title: Text(
          'Home Page',
          style: GoogleFonts.lexendDeca(
            color: Color(0xFF213A58),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.0,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: NotificationIcon(),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            GestureDetector(
              onTap: () => Get.to(() => CarFilterScreen()),
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      width: size.width * .9,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, color: Colors.black.withOpacity(.6)),
                          Expanded(
                            child: Text("Find your ideal car")
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.filter_list),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Available car for you",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => const AvailableCarsPage());
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            PostList(),
          ],
        ),
      ),
    );
  }
}