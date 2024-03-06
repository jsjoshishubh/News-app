
import 'package:flutter/material.dart';

class Dialogs {
  static Future<void> showLoadingDialog(BuildContext context, GlobalKey key,[String? text]) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: Dialog(
                  key: key,
                  backgroundColor: Colors.white,
                  elevation: 8,
                  insetAnimationCurve: Curves.easeInOut,
                  insetAnimationDuration: Duration(milliseconds: 100),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 80,
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const SizedBox(width: 8.0),
                            // ignore: prefer_const_constructors
                            Align(
                              alignment: Alignment.centerLeft,
                              // ignore: prefer_const_constructors
                              child: SizedBox(
                                width: 30.0,
                                height: 30.0,
                                child: CircularProgressIndicator(strokeWidth: 3,color: Colors.blueAccent,),
                              ),
                            ),
                            const SizedBox(width: 20.0),
                           Expanded(child: Text(text != null ? text:"Please Wait",style: TextStyle(color: Colors.blueAccent),)),
                            const SizedBox(width: 8.0)
                          ],
                        ),
                      ],
                    ),
                  ),
                  ));
        });
  }
}