import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/Https%20Request/dioClient.dart';
import 'package:newsapp/Shared%20Components/NoData_found.dart';
import 'package:newsapp/Styles/app_colors.dart';
import 'package:newsapp/Utils/utils.dart';
import 'package:newsapp/Views/HomePage/News_detail_page.dart';

DioClient dioClient = DioClient();

class CustomSearchDelegate extends SearchDelegate {
  String? type;
  List? item;

  CustomSearchDelegate({this.item,this.type});

  @override
  String get searchFieldLabel => 'Search'; // Placeholder text for the search field

    



  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
      backgroundColor:Colors.white,
        // brightness: theme.brightness,
        elevation: 0,
        foregroundColor: Colors.black
      ),
      // ignore: prefer_const_constructors
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: Colors.black),
          isDense: true,
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        ),
      textTheme: theme.textTheme.copyWith(
        headline6: const TextStyle(fontSize: 18.0),
      ),
    );

  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        // close(context, null);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  
  }

  String searchText = '';

   onSearch(query) {
    searchText = query;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
 if(query != null){
    return FutureBuilder(
      future: searchItems(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  Center(
            child:commonLoader(),
          );
        }else if(!snapshot.hasData){
          return  ListView.builder(
              itemCount: 3,
              itemBuilder: (context,index){
                final result = item![index];
                return InkWell(
                  onTap: () => showFullPageRoute(context: context,child: Container(child: NewsDetailsScreen(isBookMarked: false,newsDetails: result),)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      margin: EdgeInsets.all(6),
                      child: ListTile(
                        title: Text(result['source']['name']),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(result['urlToImage']),
                          
                        ),
                        subtitle: Text(result['title'],maxLines: 2,),
                      ),
                    ),
                  ),
                );
            });
        }
         else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final results = snapshot.data;
          log('resultb---- ${results}');
          return results!.length == 0 ? NoDataFound(title: 'No Result Found',) : ListView.builder(
            itemCount: results!.length,
            itemBuilder: (context, index) {
              final v = results[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child:Text(v.toString())
                ),
              );
            },
          );
        }
      },
    );
    }else{
      return NoDataFound(title: 'No Search Result Found',);
    }
  }

  Future<List<dynamic>> searchItems(String query) async {
    final date  = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final url = 'everything?q=${query}&from=${date}&sortBy=popularity&apiKey=${apiKey}'; // Replace with the actual API endpoint
    try {
      final respose  = await dioClient.getRequest(url);
      log('response --- ${respose.data['articles']}');
      final item = respose.data['articles'];
      return item;
    } catch (e) {
      onHandleError(error: e);
    }

    return [];
  }
}
