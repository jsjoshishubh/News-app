import 'dart:developer';

import 'package:get/get.dart';
import 'package:newsapp/Https%20Request/dioClient.dart';
import 'package:newsapp/Shared%20Components/dialoge_box.dart';
import 'package:newsapp/Utils/utils.dart';

DioClient dioClient = DioClient();

class HomePageController extends GetxController{
  final loading = false.obs;

  get isLoading => this.loading.value;

  void changeLoading(bool v) => this.loading.value = v;
  
  List allNewsList = [].obs;
  List bookmarkedList = [].obs;


onBookMarkItemOrRemove(item){
  final index = bookmarkedList.indexWhere((element) => element['title'] == item['title']);
  if(index == -1){
    bookmarkedList.add(item);
  }else{
    bookmarkedList.removeAt(index);
  }
  update();
}

isBookMarked(item){
  if (item != null) {
    return bookmarkedList.indexWhere((element) {return element['title'] == item['title'];}) !=-1;
  }
  return false;
}


  getAllNews()async{
    try {
      changeLoading(true);
      update();
      final url = 'top-headlines?country=in&apiKey=${apiKey}';
      final response  = await dioClient.getRequest(url);
      log('response  ---- ${response.data}');
      toastWidget('All News has been recived');
      allNewsList = response.data['articles'];
      changeLoading(false);
      update();
    } catch (e) {
      changeLoading(false);
      update();
      toastWidget('Something went wrong,please try again later',true);
    }
  }

}