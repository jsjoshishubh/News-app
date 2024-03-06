

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/Routes/routes.dart';
import 'package:url_launcher/url_launcher.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String isLOGGEDIN = "isLOGGEDIN";

String? apiKey = 'cea41f0f6d5041ed88a7c5f1767fb653';



 Future<void> signOut() async {
    await _auth.signOut();
    await googleSignIn.signOut();
  }

void onLocalSetup({data,startup,callback,type}) async {
  log('data ---- ${data}');
  try {
  final storage = GetStorage();
  final userId = data['_id'].toString();
  await storage.write('_id', userId);
  // final at = '${data['token']}';
  // await storage.write('token', at);
  await storage.write('image', data['image']);
  await storage.write('name', '${data['name']}');
  await storage.write('email', data['email']);
  await storage.write(isLOGGEDIN, true);
  // await CustomCacheManager().clearCache();
  if(callback is Function) callback();
   if(!['',null].contains(startup)){
    Get.offAndToNamed(Routes.MAINHOMEPAGE);
  }else{
     Get.offAndToNamed(Routes.MAINHOMEPAGE);
  }
  } catch (e) {
    log('Error  ---- ${e}');
  }
}

onClearLocalSetup({callback})async {
 try {
  final storage = GetStorage();
  final userId = storage.read('_id');
  await storage.remove('_id');
  await storage.remove('name'); 
  await storage.remove('email');
  // await storage.remove('image');
  await storage.write(isLOGGEDIN, false);
  
//  await CustomCacheManager().clearCache();
 if(callback is Function) callback();
 signOut();
  Get.offAllNamed(Routes.LOGIN);
 } catch (e) {
  log('e 00---- ${e}');
 }
}

getTextStyle({double? size, Color? color, bool? headline = false,FontWeight? fontWeight,bool? subTitle, bool? title,appBar}){
  if(appBar == true){
    return const TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 20);
  }else{
  return TextStyle(
    fontSize: subTitle == true ? 14: title == true? 18: headline == true? 22 : size == null ? 16 : size,
    color: subTitle == true ? Colors.grey.shade500 : color == null ? Colors.black : color,
    fontWeight: title == true ? FontWeight.w600 :  headline! ? FontWeight.w600 : fontWeight != null ? fontWeight : subTitle == true? FontWeight.w400 :FontWeight.w400,
    overflow: TextOverflow.ellipsis, 
    );
  }
}

toastWidget(msg,[hasError]) {
   return showSnackNotification(message: msg,hasError: hasError ?? false);
}


showSnackBar({title = null,message = 'Something went wrong, please try again.',isDismissible = true,duration = const Duration(seconds: 2),
    icon = const Icon(Icons.info_outline,color: Colors.red,),isError = false
  }){
    return showSnackNotification(title:title,message: message,toastDuration:duration,hasError:isError);
}

showSnackNotification({title = null,message = null,action,onActionPressed,toastDuration = const Duration(seconds: 2),hasError = false}){
    final isError = (['Something went wrong,please try again later','No internet available'].contains(message) || hasError) ? true:false;
    return showFlash(
      context: Get.context!,
      duration: toastDuration,
      builder: (_, controller) { 
        return Flash(
          controller: controller,
          backgroundColor:  Colors.black54,
          borderRadius: BorderRadius.circular(6),
          margin: const EdgeInsets.only(left:20,right: 20,top: 20,bottom: 20),
          behavior: FlashBehavior.floating,
          position: FlashPosition.bottom,
          child: FlashBar(
            shouldIconPulse: false,
            icon: isError ? const Icon(Icons.error,color: Colors.red,):const Icon(Icons.check_circle,color:Colors.green),
            indicatorColor: isError ? Colors.red:Colors.green,
            title: !['',null].contains(title) ? Text(title,style: const TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),):null,
            content: Text(message ?? '',style: const TextStyle(color: Colors.white),),
            primaryAction: IconButton(onPressed: (){controller.dismiss();}, icon: const Icon(Icons.close,color: Colors.white,))
            // // actions: action is Widget ? [
            // //     InkWellCustom(child: action is Widget ? action:null,onTap: (){
            // //       controller.dismiss();
            // //       if(onActionPressed is Function) onActionPressed();
            // //     },),
            //   ]:[],
          ),
        );
      },
    );
  }
  

commonLoader() {
  return Center(
    child: Container(child: CircularProgressIndicator(strokeWidth: 3,color: Colors.blueAccent,),height: 24,width: 24,),
  );
}

showFullPageRoute({context,child}) async {
  return Navigator.of(context).push(
      MaterialPageRoute( 
        builder: (BuildContext context) {
          return child;
        },
        fullscreenDialog: true,
      ),
    );
}

  dateParse(date){
    return DateTime.parse(date).toLocal();
  }

  String formatDateTime(String inputDate) {
  DateTime dateTime = DateTime.parse(inputDate);
  String formattedDate = formatDate(dateTime);
  return formattedDate;
}

String formatDate(DateTime dateTime) {
  // String daySuffix = getDaySuffix(dateTime.day);
  String formattedDate = DateFormat("d MMMM yyyy").format(dateTime);
  return formattedDate;
}

String getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

 Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

   onHandleError({error,onCallback = null,validationKey = null}){
      // log('statusCode -- ${error.message}');
      final message = error?.message;
      final statusCode = error?.statusCode;
      if(statusCode == 500) {
        if(onCallback != null && onCallback is Function) onCallback();
        showSnackNotification(message: message.toString().capitalizeFirst,hasError: true); 
      }else if(statusCode == 422){
           final err = error?.error;
           if(validationKey is List && err is Map){
             validationKey.forEach((validation) {
              if(err[validation] is List && err[validation].isNotEmpty) showSnackNotification(message: !['',null].contains(err[validation][0]) ? err[validation][0]:'Something went wrong,please try again later'.tr,hasError: true);
             });
           }else if(statusCode == 502){
              showSnackNotification(message: message.toString().capitalizeFirst ?? 'Server error, please try after some time'.tr,hasError: true);
              // onClearLocalSetup();
           }
           else{
            showSnackNotification(message: message is String ? message.toString().capitalizeFirst:'Something went wrong,Please try again later'.tr,hasError: true);
           }
      }else{
         showSnackNotification(message: message.toString().capitalizeFirst ?? 'Something went wrong,Please try again later'.tr,hasError: true);
      }
  }