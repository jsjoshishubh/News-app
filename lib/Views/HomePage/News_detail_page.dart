import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/Commons/Image_component.dart';
import 'package:newsapp/Utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';


class NewsDetailsScreen extends StatefulWidget {
  Map<String,dynamic>? newsDetails;
  bool? isBookMarked;
  NewsDetailsScreen({super.key,this.newsDetails,this.isBookMarked = false});

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    log('widget.isBookMarked! --- ${widget.isBookMarked!}');
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.2,
        title: Text('News Details'),
        actions: [
          IconButton(onPressed: () => launchInBrowser(Uri.parse(widget.newsDetails!['url'].toString())), icon: Icon(Icons.link)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: Get.height /2.1,
              width: Get.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
              ),
              child: ClipRRect(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),

                child:  Image.network(
                      widget.newsDetails!['urlToImage'].toString(),
                      fit: BoxFit.cover,
                      width: Get.width,
                      height: Get.height / 2.3,
                    ),
              ),
            //   Stack(
            //     children: [
            //       ClipRRect(
            //         borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            //         child: ShaderMask(
            //         shaderCallback: (Rect bounds) {
            //           return  LinearGradient(
            //             begin: Alignment.topCenter,
            //             end: Alignment.center,
            //             colors: [Colors.transparent, Colors.black],
            //           ).createShader(bounds);
            //         },
            //         blendMode: BlendMode.dstIn,
            //         child: Image.network(
            //           widget.newsDetails!['urlToImage'].toString(),
            //           fit: BoxFit.cover,
            //           width: Get.width,
            //           height: Get.height / 2.3,
            //         ),
            //       ),
            //     ),
            //   ],
            // )
            ),
            SizedBox(height: 20,),
            Container(
              child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Container(
                      child: Row(
                        children: [
                          ClipRRect(
                            child: Image.network(widget.newsDetails!['urlToImage'],height: 30,width: 30,),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(widget.newsDetails!['author'] == null ? 'Unknown' : widget.newsDetails!['author'],style: getTextStyle(size: 14,fontWeight: FontWeight.w500),),
                                      Icon(widget.isBookMarked! ? Icons.bookmark :Icons.bookmark_border)
                          
                                    ],
                                  )),
                                   Container(
                                    child: Text("${widget.newsDetails!['publishedAt'] != null ? formatDate(dateParse(widget.newsDetails!['publishedAt']))  : '-'}",style: getTextStyle(size: 12,color: Colors.grey,fontWeight: FontWeight.w700),maxLines: 2,),
                                  ),
                                ],
                              )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(widget.newsDetails!['title'].toString() ?? '-',style: getTextStyle(fontWeight: FontWeight.w700,size: 16),maxLines: 6,),
                    SizedBox(height: 20,),
                    Text(widget.newsDetails!['description'] == null ? '' :widget.newsDetails!['description'],style: getTextStyle(size: 13,fontWeight: FontWeight.w500,color: Colors.grey),maxLines: 10,textAlign: TextAlign.justify,),
                    SizedBox(height: 20,),
                    Text(widget.newsDetails!['content'] == null ? '': widget.newsDetails!['content'],style: getTextStyle(size: 13,fontWeight: FontWeight.w400,color: Colors.grey),maxLines: 100,textAlign: TextAlign.justify,),
                    SizedBox(height: 20,),

                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}