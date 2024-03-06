import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newsapp/Shared%20Components/dialoge_box.dart';
import 'package:newsapp/Styles/app_colors.dart';
import 'package:newsapp/Utils/utils.dart';
import 'package:newsapp/Views/HomePage/Bookmark_page.dart';
import 'package:newsapp/Views/HomePage/News_feeds_page.dart';


class MainHomePageView extends StatefulWidget {
  const MainHomePageView({super.key});

  @override
  State<MainHomePageView> createState() => _MainHomePageViewState();
}


class _MainHomePageViewState extends State<MainHomePageView> {


PageController _pageController = PageController();
int _currentIndex = 0;


void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
}



 Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.white,spreadRadius: 2,blurRadius: 3,offset: Offset(0, -1),),
        ],
      ),
      child: BottomNavigationBar(
        elevation: 5,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: [
          _buildNavigationBarItem(_currentIndex == 0 ?Icons.home : Icons.home_outlined, 'News Feeds',0,_currentIndex),
          _buildNavigationBarItem(_currentIndex == 1 ? Icons.bookmark : Icons.bookmark_border , 'Bookmark',1,_currentIndex),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem(IconData icon, String label,index,currentIndex) {
    return BottomNavigationBarItem(
      icon: Icon(icon,color:  currentIndex == index ? Colors.black : Colors.black,),
      label: label,
    );
  }

  getPages(index){
    switch (index) {
      case 0:
        return NewsFeedsPage();
      case 1 :
        return BookMarkPage();
      default:
    }
  }

int? _lastTimeBackButtonWasTapped;

  Future<bool> onWillPop() {
    final _currentTime = DateTime.now().millisecondsSinceEpoch;
    if (_lastTimeBackButtonWasTapped != null && (_currentTime - _lastTimeBackButtonWasTapped!) < 2000) {
      Fluttertoast.cancel();
      Future.delayed(Duration(seconds: 2));
      return Future.value(true);
    } else {
      _lastTimeBackButtonWasTapped = DateTime.now().millisecondsSinceEpoch;
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: 'Press BACK to exit app',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          fontSize: 14.0);
      return Future.value(false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#F7F7F7'),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: PageView.builder(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 2,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return Center(
              child: getPages(index),
            );
          },
        ),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
           highlightColor: Colors.transparent,
        ),
        child: _buildBottomNavigationBar()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}