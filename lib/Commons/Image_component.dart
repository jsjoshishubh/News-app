
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageComponent extends StatelessWidget {
  String? url;
  double? pleceHolderImageScal;
  double? urlImageScal;
  double? errorImageScal;
  double? height;
  double? width;

  ImageComponent({super.key,this.errorImageScal,this.pleceHolderImageScal,this.url,this.urlImageScal,this.height,this.width});

  @override
  Widget build(BuildContext context) {
    log('url ---- ${url}');
    return CachedNetworkImage(
      fadeInDuration: Duration(milliseconds: 800),
      imageUrl: url.toString() ?? '' ,fit: BoxFit.fill,height: height != null? height : 200,width: width != null ? width : Get.width,
      placeholder: (context, url) =>  Image.asset('Assets/Images/news_logo.png',
      scale: pleceHolderImageScal,
      color: Color.fromRGBO(255, 255, 255, 90),
      colorBlendMode: BlendMode.modulate),
      errorWidget: (context, url, error)  => Image.asset('Assets/Images/news_logo.png',
      scale: errorImageScal,
      color: Color.fromRGBO(255, 255, 255, 90),
      colorBlendMode: BlendMode.modulate
    ));
  }
}