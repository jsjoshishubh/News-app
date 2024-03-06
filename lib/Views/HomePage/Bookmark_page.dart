import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/Components/home_page_components/bookmarked_list.component.dart';
import 'package:newsapp/Controllers/home_page_controller.dart';

class BookMarkPage extends StatefulWidget {
  const BookMarkPage({super.key});

  @override
  State<BookMarkPage> createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  HomePageController homePageController = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarked News'),
        leading: Icon(Icons.menu),
        titleSpacing: 0.2,

      ),
      body: GetBuilder(
        init: homePageController,
        builder: ((controller) {
          return Column(
            children: [
              Container(
                child: BookmarkedListComponent(
                  bookmarkedList: controller.bookmarkedList!,
                  isBookmarked: (v)=> controller.isBookMarked(v),
                  onBookmarked: (v)=> controller.onBookMarkItemOrRemove(v),
                ),
              )
            ],
          );
        }
        ),
    ));
  }
}