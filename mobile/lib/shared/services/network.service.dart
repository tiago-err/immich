import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:immich_mobile/constants/hive_box.dart';
import 'package:immich_mobile/utils/dio_http_interceptor.dart';

class NetworkService {
  Future<dynamic> deleteRequest({required String url, dynamic data}) async {
    try {
      var dio = Dio();
      dio.interceptors.add(AuthenticatedRequestInterceptor());

      var savedEndpoint = Hive.box(userInfoBox).get(serverEndpointKey);
      Response res = await dio.delete('$savedEndpoint/$url', data: data);

      if (res.statusCode == 200) {
        return res;
      }
    } on DioError catch (e) {
      debugPrint("DioError: ${e.response}");
    } catch (e) {
      debugPrint("ERROR getRequest: ${e.toString()}");
    }
  }

  Future<dynamic> getRequest({required String url}) async {
    try {
      var dio = Dio();
      dio.interceptors.add(AuthenticatedRequestInterceptor());

      var savedEndpoint = Hive.box(userInfoBox).get(serverEndpointKey);
      Response res = await dio.get('$savedEndpoint/$url');

      if (res.statusCode == 200) {
        return res;
      }
    } on DioError catch (e) {
      debugPrint("DioError: ${e.response}");
    } catch (e) {
      debugPrint("ERROR getRequest: ${e.toString()}");
    }
  }

  Future<dynamic> postRequest({required String url, dynamic data}) async {
    try {
      var dio = Dio();
      dio.interceptors.add(AuthenticatedRequestInterceptor());

      var savedEndpoint = Hive.box(userInfoBox).get(serverEndpointKey);
      String validUrl = Uri.parse('$savedEndpoint/$url').toString();
      Response res = await dio.post(validUrl, data: data);

      return res;
    } on DioError catch (e) {
      debugPrint("DioError: ${e.response}");
      return false;
    } catch (e) {
      debugPrint("ERROR BackupService: $e");
    }
  }

  Future<dynamic> patchRequest({required String url, dynamic data}) async {
    try {
      var dio = Dio();
      dio.interceptors.add(AuthenticatedRequestInterceptor());

      var savedEndpoint = Hive.box(userInfoBox).get(serverEndpointKey);

      String validUrl = Uri.parse('$savedEndpoint/$url').toString();
      Response res = await dio.patch(validUrl, data: data);

      return res;
    } on DioError catch (e) {
      debugPrint("DioError: ${e.response}");
    } catch (e) {
      debugPrint("ERROR BackupService: $e");
    }
  }

  Future<bool> pingServer() async {
    try {
      var dio = Dio();

      var savedEndpoint = Hive.box(userInfoBox).get(serverEndpointKey);

      String validUrl = Uri.parse('$savedEndpoint/server-info/ping').toString();

      debugPrint("pint server at url $validUrl");
      Response res = await dio.get(validUrl);
      var jsonRespsonse = jsonDecode(res.toString());

      if (jsonRespsonse["res"] == "pong") {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      debugPrint("[PING SERVER] DioError: ${e.response} - $e");
      return false;
    } catch (e) {
      debugPrint("ERROR BackupService: $e");
      return false;
    }
  }
}
