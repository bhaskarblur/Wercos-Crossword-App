import 'dart:convert';
import 'dart:io';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'app_config/app_details.dart';
import 'widget/navigator.dart';
import 'widget/sahared_prefs.dart';
import 'widget/widgets.dart';

class ApiServices {
  Future<dynamic> get(
      {required BuildContext context,
      required String endpoint,
      bool progressBar = true,
      bool internetCheck = true}) async {
    var response = 'null';
    bool connected = await connectedOrNot(context);
    debugPrint(endpoint);

    String? token = await Prefs.getToken();
    debugPrint(token);

    if (connected) {
      if (progressBar) {
        loader(context);
      }
      var res = await http.get(Uri.parse(baseUrl + endpoint),
          headers: {"Authorization": "Bearer $token"});
      if (progressBar) {
        Nav.pop(context);
      }
      debugPrint(endpoint + res.body);
      response = res.body;
    }
    return jsonDecode(response);
  }

  Future<dynamic> post(
      {required BuildContext context,
      required String endpoint,
      var body,
      bool progressBar = true,
      bool internetCheck = true}) async {
    var response = 'null';

    bool connected = await connectedOrNot(context, show: internetCheck);
    String? token = await Prefs.getToken();

    debugPrint(endpoint + body.toString());
    debugPrint(token);

    if (connected) {
      if (progressBar) {
        loader(context);
      }

      var res = await http.post(Uri.parse(baseUrl + endpoint), body: body);
      if (progressBar) {
        Nav.pop(context);
      }

      debugPrint(endpoint + res.body);
      response = res.body;
    }
    dynamic json;
    try {
      json = jsonDecode(response);
    } catch (e) {
      print(e);
    }
    return json;
  }

  Future<dynamic> patch(
      {required BuildContext context,
      required String endpoint,
      var body}) async {
    var response = 'null';

    bool connected = await connectedOrNot(context);

    String? token = await Prefs.getToken();

    debugPrint(body.toString());

    if (connected) {
      if (context.mounted) {
        loader(context);
      }
      var res = await http.patch(Uri.parse(baseUrl + endpoint),
          headers: {"Authorization": "Bearer $token"}, body: body);
      if (context.mounted) {
        Nav.pop(context);
      }

      debugPrint(res.body);

      response = res.body;
    }

    return jsonDecode(response);
  }

  Future<dynamic> delete(
      {required BuildContext context, required String endpoint}) async {
    var response = 'null';

    bool connected = await connectedOrNot(context);
    String? token = await Prefs.getToken();

    print(endpoint);
    print(token);

    if (connected) {
      if (context.mounted) {
        loader(context);
      }
      var res = await http.post(Uri.parse(baseUrl + endpoint),
          headers: {"Authorization": "Bearer $token"});
      if (context.mounted) {
        Nav.pop(context);
      }

      debugPrint(res.body);

      response = res.body;
    }

    return jsonDecode(response);
  }

  // Future<bool> connectedOrNot(BuildContext context, {bool show = true}) async {
  //   try {
  //     final result = await InternetAddress.lookup('www.google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       return true;
  //     } else {
  //       if (context.mounted) {
  //         internetBanner(context, 'No Internet Connection!', () {
  //           Nav.pop(context);
  //         });
  //       }
  //       return false;
  //     }
  //   } on SocketException catch (_) {
  //     if (show) {
  //       internetBanner(context, 'No Internet Connection!', () {
  //         Nav.pop(context);
  //       });
  //     }
  //     return false;
  //   }
  // }

  Future<bool> connectedOrNot(BuildContext context, {bool show = true}) async {
    try {
      final result = await http.get(Uri.parse('http://www.google.com'));
      if(result.statusCode==200){
        return true;
      }
      else{
        return false;
      }
    }
    on SocketException catch (_) {
      return false;
    }
  }

  Future<bool> imageUpload(BuildContext context, File file, String uploadUrl,
      {bool update = false}) async {
    loader(context);
    print(uploadUrl);
    final prefs = await SharedPreferences.getInstance();
    debugPrint(file.path.split('/')[file.path.split('/').length - 1]);

    bool ck = false;
    final url = Uri.parse(uploadUrl);
    var request = http.MultipartRequest(update ? 'PATCH' : 'POST', url);
    var pic = await http.MultipartFile.fromPath("image", file.path);
    request.headers['Authorization'] = 'Bearer ${prefs.getString('token')!}';

    request.files.add(pic);
    var response = await request.send();

    debugPrint(response.stream.toString());
    debugPrint(response.statusCode.toString());

    var dt = await response.stream.bytesToString();

    debugPrint(dt);

    if (response.statusCode == 200) {
      ck = true;
    } else {
      ck = false;
    }
    Nav.pop(context);
    return ck;
  }

  // Future<bool> multiplIemageUpload(
  //     FilePickerResult file, String uploadUrl) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   // debugPrint(file.path.split('/')[file.path.split('/').length - 1]);

  //   bool ck = false;
  //   final url = Uri.parse(uploadUrl);
  //   var request = http.MultipartRequest('POST', url);
  //   request.headers['Authorization'] = 'Bearer ${prefs.getString('token')!}';

  //   for (int i = 0; i < file.files.length; i++) {
  //     var pic = await http.MultipartFile.fromPath("image", file.files[i].path!);
  //     request.files.add(pic);
  //   }

  //   var response = await request.send();

  //   debugPrint(response.stream.toString());
  //   debugPrint(response.statusCode.toString());

  //   var dt = await response.stream.bytesToString();

  //   debugPrint(dt);

  //   if (response.statusCode == 200) {
  //     ck = true;
  //   } else {
  //     ck = false;
  //   }
  //   return ck;
  // }
}
