import 'dart:convert';

import 'model/user/user.dart';
import 'package:http/http.dart' as http;

class UserFunc{

  Future<User?> getUser() async {
    final response = await http.get(Uri.parse('http://3.91.247.53:10000/getUserName'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      // Assuming the JSON response has a 'username' field
     final User user = User.fromJson(jsonData);
      return user;
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }


  }
}