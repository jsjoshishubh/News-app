import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:newsapp/Components/home_page_components/News_List_component.dart';
import 'package:newsapp/Controllers/home_page_controller.dart';
import 'package:newsapp/Shared%20Components/dialoge_box.dart';
import 'package:newsapp/Shared%20Components/search_deligate.dart';
import 'package:newsapp/Styles/app_colors.dart';
import 'package:newsapp/Utils/utils.dart';


class NewsFeedsPage extends StatefulWidget {
  const NewsFeedsPage({super.key});

  @override
  State<NewsFeedsPage> createState() => _NewsFeedsPageState();
}

class _NewsFeedsPageState extends State<NewsFeedsPage> {
  
final GlobalKey<State> _keyLoader = new GlobalKey<State>();

HomePageController homePageController = Get.put(HomePageController());

final storage = GetStorage();
String? imageUrl = '';
String? userName = '';
String userEmail = '';



@override
void initState(){
  super.initState();
  onInitSetup();
}

onInitSetup()async{

setState(() {
  imageUrl = storage.read('image');
  userName = storage.read('name');
  userEmail = storage.read('email');
});
await homePageController.getAllNews();
}

onLogout()async{
  await Future.delayed(Duration(milliseconds: 100));
  Dialogs.showLoadingDialog(context, _keyLoader, 'Please wait');
  await Future.delayed(Duration(milliseconds: 200));
   onClearLocalSetup(callback: (){
    Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text('News Feeds'),
        titleSpacing: 0.2,

        actions: [
          IconButton(onPressed: (){
            showSearch(
                context: context,
                delegate: CustomSearchDelegate(
                  item: homePageController.allNewsList
                ),
              );
          }, icon: Icon(Icons.search)),
          IconButton(onPressed: onLogout, icon: Icon(Icons.logout_outlined)),

        ],
      ),
      body: GetBuilder(
        init: homePageController,
        builder: (controller){
        return  Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.blueAccent,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(imageUrl.toString()),
                  ),
                ),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('👋 Welcome ',style: getTextStyle(color: Colors.grey.shade600,size: 16,fontWeight: FontWeight.w500),),
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:8.0),
                      child: Text(userName.toString() != null ? userName.toString().capitalizeFirst.toString() : '-',style: getTextStyle(size: 20,fontWeight: FontWeight.w500,color: primaryColor),),
                    ),
                  ],
                ),
              ],
            ),
          ),
          controller.isLoading ? Expanded(
            child: Container(
              child: commonLoader(),
            ),
          ) : Container(
            child: NewsFeedListComponent(
              allNews: controller.allNewsList,
              onBookMark: (v) => controller.onBookMarkItemOrRemove(v),
              isBookmarked: (v) => controller.isBookMarked(v),
              ),
          )
        ],
      );
      })
      
    );
  }
}