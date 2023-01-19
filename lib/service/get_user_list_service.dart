import 'package:dio/dio.dart';

class GetUserListService {
  final dio = Dio(BaseOptions(responseType: ResponseType.json));
  Future<Response> getUserList() async {
    try {
      Response response = await dio.get('https://reqres.in/api/users?');

      return response;
    } on DioError catch (e) {
      print(e.message);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
