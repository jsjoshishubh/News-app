
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/Styles/app_colors.dart';

class SearchableBar extends StatefulWidget implements PreferredSizeWidget {
  String? title;
  String? placeholder;
  Function? onSearch;
  List<Widget>? actions;
  Widget? titleWidget;
  VoidCallback? onBack;
  Icon? backIcon;
  bool? showBackButton;
  bool? changeAppBarColor; 
  SearchableBar({this.changeAppBarColor =false,this.title = 'Title',this.onSearch, this.actions = const [],this.placeholder,this.titleWidget = null,this.onBack,this.backIcon = const Icon(Icons.close, color: Colors.black),this.showBackButton = true});
 
  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  _SearchableBarState createState() => _SearchableBarState();
}

class _SearchableBarState extends State<SearchableBar> with SingleTickerProviderStateMixin {
  double? rippleStartX, rippleStartY;
  AnimationController? _controller;
  Animation? _animation;
  bool isInSearchMode = false;
  GlobalKey appBarKey = GlobalKey();
  @override
  initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller!);
    _controller!.addStatusListener(animationStatusListener);
  }

  animationStatusListener(AnimationStatus animationStatus) {
    if (animationStatus == AnimationStatus.completed) {
      setState(() {
       isInSearchMode = true; 
      });
    }
  }

  void onSearchTapUp(TapUpDetails details) {
    setState(() {
      rippleStartX = details.globalPosition.dx;
      rippleStartY = details.globalPosition.dy;
    });

    _controller!.forward();
  }

  cancelSearch() {
    setState(() {
      isInSearchMode = false;
    });

    widget.onSearch!('');
    _controller!.reverse();
  }

  getActions(){
    List<Widget> actions = [
            SizedBox(width: 5,),
            GestureDetector(
              // ignore: sort_child_properties_last
              child: Icon(
                  Icons.search,
                  color: widget.changeAppBarColor!? Colors.white: Colors.black,
              ),
              onTapUp: onSearchTapUp,
            ),
            SizedBox(width: 10,)
      ];
    if(actions.isNotEmpty){
      actions.addAll(widget.actions!);
    }
    return actions;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final keyContext = appBarKey.currentContext;
    return Stack(
      key: appBarKey,
      children: [
        AppBar(
          leading: widget.showBackButton! ? IconButton(
            icon: widget.backIcon!,
            onPressed: (){
             if(widget.onBack != null){
              widget.onBack!();
             }else{ 
              Navigator.of(context).pop();
             }
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ):SizedBox(),
          centerTitle:false,
          titleSpacing: 4,
          title: widget.titleWidget != null ? widget.titleWidget:Text(widget.title!,style: TextStyle(color: widget.changeAppBarColor! ?Colors.white: Colors.grey[900],fontSize: 16,fontWeight: FontWeight.w600),),
          actions: getActions(),
          backgroundColor: widget.changeAppBarColor!  ? primaryColor : Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: widget.changeAppBarColor!?Colors.white : Colors.black),
          toolbarHeight: 55,
        ),

       keyContext != null ? AnimatedBuilder(
          animation: _animation!,
          builder: (context, child) {
          return CustomPaint(
              painter: MyPainter(
                containerHeight: widget.preferredSize.height,
                center: Offset(rippleStartX ?? 0, rippleStartY ?? 0),
                radius: _animation!.value * screenWidth,
                context: context,
                screenWidth: 50
              ),
            );
          },
        ):SizedBox(),

        isInSearchMode ? (
          SearchBar(
            onCancelSearch: cancelSearch,
            onSearchQueryChanged:(v)=> widget.onSearch!(v),
            placeholder: widget.placeholder!
          )
        ) : (
          Container()
        )
      ]
    );
  }
}

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  String? placeholder;
  SearchBar({
    Key? key,
    @required this.onCancelSearch,
    @required this.onSearchQueryChanged,
    this.placeholder = 'search'
  }) : super(key: key);

  VoidCallback? onCancelSearch;
  Function(String)? onSearchQueryChanged;

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> with SingleTickerProviderStateMixin {
  String searchQuery = '';
  TextEditingController _searchFieldController = TextEditingController();

  clearSearchQuery() {
    _searchFieldController.clear();
    widget.onSearchQueryChanged!('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      alignment: Alignment.topCenter,
        decoration: BoxDecoration( borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // IconButton(
                //   icon: Icon(Icons.arrow_back, color: Colors.black),
                //   // onPressed: widget.onCancelSearch,
                //   onPressed: (){},
                // ),
                // SizedBox(width: 22,),
                Container(child: Icon(Icons.search_outlined, color: Colors.black),width: 40,margin: EdgeInsets.only(right: 8,left: 8),),
                Expanded(
                  child: Container(height: 40,
                  child: TextField(
                    controller: _searchFieldController,
                    cursorColor: Colors.black,
                    autofocus:true,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: widget.placeholder,
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                    onChanged:(v) => widget.onSearchQueryChanged!(v),
                  ),
                )),
                 IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  icon: Icon(Icons.close, color: Colors.black),
                  // onPressed: clearSearchQuery,
                  onPressed: widget.onCancelSearch,
                ),
                SizedBox(width: 20,)
              ],
            ),
          ],
        ),
    );
  }
}


class MyPainter extends CustomPainter {
  final Offset? center;
  final double? radius, containerHeight;
  final BuildContext? context;

  Color? color;
  double? statusBarHeight, screenWidth;

  MyPainter({this.context, this.containerHeight, this.center, this.radius,this.screenWidth}) {
    color = Colors.white;
    statusBarHeight = MediaQuery.of(context!).padding.top;
    screenWidth = screenWidth ?? MediaQuery.of(context!).size.width;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePainter = Paint();

    circlePainter.color = color!;
    canvas.clipRect(Rect.fromLTWH(20, 20, screenWidth!, containerHeight! + statusBarHeight!));
    canvas.drawCircle(center!, radius!, circlePainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
