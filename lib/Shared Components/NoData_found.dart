import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NoDataFound extends StatefulWidget {
  String? title;
  String? imageUrl;
  double? height;
  NoDataFound({super.key,this.height,this.imageUrl ='Assets/Images/nodata.png',this.title = ''});

  @override
  State<NoDataFound> createState() => _NoDataFoundState();
}

class _NoDataFoundState extends State<NoDataFound> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              height: widget.height == null ? 300 : Get.height * widget.height!,
              child: Image.asset(widget.imageUrl!,scale:1.3,),
              // color: Colors.red,
          ),
          SizedBox(height: 20,),
          ['',null].contains(widget.title!) ? SizedBox():Text(
            widget.title!,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
                fontSize: 15),
          )
        ],
      ),
    );
  }
}