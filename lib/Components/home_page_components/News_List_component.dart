import 'package:flutter/material.dart';
import 'package:newsapp/Commons/Image_component.dart';
import 'package:newsapp/Shared%20Components/NoData_found.dart';
import 'package:newsapp/Styles/app_colors.dart';
import 'package:newsapp/Utils/utils.dart';
import 'package:newsapp/Views/HomePage/News_detail_page.dart';

class NewsFeedListComponent extends StatefulWidget {
  List? allNews;
  Function? isBookmarked;
  Function? onBookMark;
  NewsFeedListComponent({super.key,this.allNews,this.isBookmarked,this.onBookMark});

  @override
  State<NewsFeedListComponent> createState() => _NewsFeedListComponentState();
}

class _NewsFeedListComponentState extends State<NewsFeedListComponent> {
  ScrollController _scrollController = ScrollController();
  
  List _data = List.generate(20, (index) => index); // Initial data

@override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreData);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  void _loadMoreData() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // User has reached the end of the list
      // Load more data or trigger pagination in flutter
      setState(() {
        _data.addAll(List.generate(10, (index) => _data.length + index));
      });
    }
  }


  @override
  Widget build(BuildContext context) {
   return widget.allNews!.length == 0 ? Expanded(child: Center(child: NoDataFound(title: 'No News Available!!',))) : Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: widget.allNews!.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          final item = widget.allNews![index];
          bool isBookmarked = widget.isBookmarked!(item);
          return Container(
            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                  color: Colors.grey.shade500,
                  blurRadius: 1,
                  spreadRadius: 0.5,
                ),
              ]),
            margin: EdgeInsets.symmetric(horizontal:20,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(6),topRight:Radius.circular(6) ),
                    child: ImageComponent(
                      pleceHolderImageScal: 4,
                      url: item['urlToImage'].toString(),
                      urlImageScal: 0.9, 
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:14.0,vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Author : ${item['author'] != null ? item['author'] : 'Unknown'}",style: getTextStyle(size: 12,fontWeight: FontWeight.w500,color: Colors.grey.shade600),maxLines: 2,),
                      Container(
                        child: Row(
                          children: [
                            Icon(Icons.watch_later_outlined,size: 12,color: Colors.grey.shade500,),
                            SizedBox(width: 3,),
                            Text("${item['publishedAt'] != null ? formatDate(dateParse(item['publishedAt']))  : 'Unknown'}",style: getTextStyle(size: 12,color: Colors.grey.shade600),maxLines: 2,),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:14.0,vertical: 10),
                  child: Text(item['title'] ?? '-',style: getTextStyle(size: 15,fontWeight: FontWeight.w600,color: primaryColor),maxLines: 2,),
                ),
                
                Container(
                 padding: const EdgeInsets.symmetric(horizontal:14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: ()=>  showFullPageRoute(context: context,child: Container(child: NewsDetailsScreen(newsDetails: item,isBookMarked: isBookmarked),)),
                        child: Container(child: Text('Read More..',style: getTextStyle(color: Colors.blue,size: 14),))),
                      InkWell(
                        onTap: () => widget.onBookMark!(item),
                        child: Icon(isBookmarked ? Icons.bookmark  :Icons.bookmark_border))
                    ],
                  ),
                ),
                SizedBox(height: 10,),

              ],
            ),
          );
      }),
    );
  }
}