import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:newsapp/Https%20Request/server_config.dart';
import 'package:newsapp/Utils/utils.dart';

final xApiKey = 'qwertyuiop12345zxcvbnmkjh:U2FsdGVkX1/NsFV/wfHncKBib6chJ7JGhfJyt9aSv/ltg0s/P/NaMtyNM7tSiB78clryjyNDUxlNwLeS/O5AlSXoL3x+rVxpetSQJYyjoiA9miQ99RKT7VaRhJBUFDXk+DfeyvsUNpUr6jw0sMZwyANc429j3cRp+Ow7QsLp2Uq33GxJJ2MYzd1hFrg7sfDDRGHLiZaR3V2eXryzqj0GSA==';

class DioClient {
  static final baseUrl = ApibaseUrl;
  // static final baseUrl = 'https://387d-27-7-24-213.ngrok-free.app/api/';
  static BaseOptions opts = BaseOptions(
    baseUrl: baseUrl,
    responseType: ResponseType.json,
    connectTimeout: Duration(seconds: 60),
    receiveTimeout: Duration(seconds: 60),
    contentType: 'application/json',
    
  );

  static Dio addInterceptors(Dio dio) {
    final storage = GetStorage();
    bool isllogedin = true;
    Map<String, dynamic> map = {
      'contentType': 'application/json',
      'Accept': 'application/xml'
    };
    if (isllogedin) {
      final jwtToken = storage.read('token');
      map.update('Authorization', (v) => jwtToken, ifAbsent: () => jwtToken);
      // log('Map ---- ${map}');
    }
    opts.headers = map;
    Dio dio = new Dio(opts);
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) => true;
    //   return client;
    // };

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          return handler.next(response); // continue
        },
        onError: (DioError e, handler) async {
          print('dio client err - ${e.type} -- ${e.response} - ${e.response?.statusCode} -- ${dio.options.baseUrl} -- ${dio.options.queryParameters}');
          handler.next(e);
        },
      ),
    );
    return dio;
  }

  static final dio = Dio(opts);

  Future<Response> getRequest(String url, [dynamic params]) async {
    try {
      await checkNetworkConnetion();
      final baseRequest = addInterceptors(dio);
            log('get url -- ${url} -- ${params} ---- ${baseRequest}');

      Response response = await baseRequest.get(url, queryParameters: params);
      return response;
    } on DioError catch (e) {
      // Handle error
      return Future.error(e is CustomResponse ? e:getFormattedResponse(e));
    }
  }

  Future<Response> postRequest(String url, [dynamic data]) async {
    try {
      await checkNetworkConnetion();
      final baseRequest = addInterceptors(dio);
            print('post url -- ${url} -- ${data}');
      Response response = await baseRequest.post(url, data: data);
      return response;
    } catch (e) {
      print('eee -- ${e}');
      // Handle error
      return Future.error(e is CustomResponse ? e:getFormattedResponse(e));
    }
  }

  Future<Response> patchRequest(String url, [dynamic data]) async {
    try {
      await checkNetworkConnetion();
      final baseRequest = addInterceptors(dio);
            print('patch url -- ${url} -- ${data}');
      Response response = await baseRequest.patch(url, data: data);
      return response;
    } on DioError catch (e) {
      // Handle error
      return Future.error(e is CustomResponse ? e:getFormattedResponse(e));
    }
  }

  Future<Response> putRequest(String url, [dynamic data]) async {
    try {
      await checkNetworkConnetion();
      final baseRequest = addInterceptors(dio);
      print('put url -- ${url} -- ${data}');
      Response response = await baseRequest.put(url, data: data);
      return response;
    } on DioError catch (e) {
      // Handle error
      return Future.error(e is CustomResponse ? e:getFormattedResponse(e));
    }
  }

  Future<Response> deleteRequest(String url, [dynamic data]) async {
    try {
      await checkNetworkConnetion();
      final baseRequest = addInterceptors(dio);
      log('base requestt ----- ${baseRequest}');
       print('delete url -- ${url} -- ${data}');
      Response response = await baseRequest.delete(url, data: data);
      return response;
    } on DioError catch (e) {
      // Handle error
      return Future.error(e is CustomResponse ? e:getFormattedResponse(e));
    }
  }
}

class CustomResponse {
  int? statusCode;
  dynamic? message;
  dynamic? error;
  CustomResponse({this.statusCode,this.message,this.error});
  
  factory CustomResponse.fromJson(Map<String,dynamic> json) => CustomResponse(statusCode: json['code'],message: json['errorMessage'],error: json['error']);
}

networkErrorResponse(){
  return new CustomResponse.fromJson({'code': 502, 'errorMessage': 'no_network'.tr, 'error': 'no_network'.tr});
}

getFormattedResponse(res){
 try{
   final response = res.response;
  final statusCode = response?.statusCode;
  if(statusCode == 401){
    showSnackBar(message: 'Authorization Denied, please login again.',isError: true);
    // onClearLocalSetup();
    return CustomResponse.fromJson(response.data);
  }else if(statusCode == 422){
    return CustomResponse.fromJson({'code': 422, 'errorMessage': response.data['errorMessage'], 'error': response.data['error'] ?? 'server error, please try again'});
  }else if([DioErrorType.receiveTimeout].contains(res.type)){
     return CustomResponse.fromJson({'code': 422, 'errorMessage': 'connection timeout, please try again', 'error': 'connection timeout, please try again'});
  }
  final  v =  CustomResponse.fromJson(response.data);
  return CustomResponse.fromJson(response.data);
 }catch(er){
  print('e -- ${er}');
 }
}

checkNetworkConnetion() async{
    final isOnline = true;
    // if(!isOnline){
    //   final cc = networkErrorResponse();
    //   return Future.error(cc);
    // }
}
