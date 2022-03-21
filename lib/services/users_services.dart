import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/models/users_response.dart';
import 'package:http/http.dart' as http;

class UsersServices {
  Future<List<User>> getUsers() async {
    try {
      final token = await AuthService.getToken();
      // print(token);
      final url = Uri.parse('${Environment.apiUrl}/users');
      final res = await http.get(url,
          headers: {'Content-Type': 'application/json', 'x-token': '$token'});

      final usersResponse = usersResponseFromJson(res.body);

      return usersResponse.users;
    } catch (e) {
      return [];
    }
  }
}
