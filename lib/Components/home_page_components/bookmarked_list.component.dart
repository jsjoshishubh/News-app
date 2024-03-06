import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/Shared%20Components/NoData_found.dart';
import 'package:newsapp/Styles/app_colors.dart';
import 'package:newsapp/Utils/utils.dart';
import 'package:newsapp/Views/HomePage/News_detail_page.dart';

class BookmarkedListComponent extends StatefulWidget {
  List? bookmarkedList;
  Function? isBookmarked;
  Function? onBookmarked;
  BookmarkedListComponent({super.key,this.bookmarkedList,this.isBookmarked,this.onBookmarked});

  @override
  State<BookmarkedListComponent> createState() => _BookmarkedListComponentState();
}

class _BookmarkedListComponentState extends State<BookmarkedListComponent> {
  @override
  Widget build(BuildContext context) {
    return widget.bookmarkedList!.length == 0 ? Expanded(child: Center(child: NoDataFound(title: 'No Bookmarks Available',))) : ListView.builder(
      shrinkWrap: true,
      itemCount: widget.bookmarkedList!.length,
      itemBuilder: (context,index){
        final item = widget.bookmarkedList![index];
          bool isBookmarked = widget.isBookmarked!(item);

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16,vertical: 6),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(item['urlToImage']),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: Get.width/1.5,
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                isThreeLine: true,
                                dense: true,
                                title: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${item['author'] != null ? item['author'] : 'Unknown'}",style: getTextStyle(fontWeight: FontWeight.w600),),
                                      Text("${item['publishedAt'] != null ? formatDate(dateParse(item['publishedAt']))  : 'Unknown'}",style: getTextStyle(size: 12,color: Colors.grey.shade600),maxLines: 2,),
                                    ],
                                  )),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top:8.0),
                                  child: Text(item['title'],style: getTextStyle(size: 12,color: primaryColor),maxLines: 3,),
                                ),
                              ),
                            ) 
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                 padding: const EdgeInsets.symmetric(horizontal:14.0,vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: ()=> showFullPageRoute(context: context,child: Container(child: NewsDetailsScreen(newsDetails: item,isBookMarked: isBookmarked),)),
                        child: Text('Read More..',style: getTextStyle(color: Colors.blue,size: 14),)),
                      Row(
                        children: [
                          InkWell(
                            onTap: ()=> launchInBrowser(Uri.parse(item!['url'].toString())),
                            child: Icon(Icons.link)),
                          SizedBox(width: 8,),
                          InkWell(
                            onTap: () => widget.onBookmarked!(item),
                            child: Icon(isBookmarked ? Icons.bookmark  :Icons.bookmark_border)),
                            
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
      );
  }
}