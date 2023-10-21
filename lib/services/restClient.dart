import 'package:cb_flutter_template/config/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter_feathersjs/flutter_feathersjs.dart';

FlutterFeathersjs restClient = FlutterFeathersjs();

final BASE_URL = env['backend'];

Dio dio = Dio(BaseOptions(baseUrl: BASE_URL));

client(){
return restClient.configure(FlutterFeathersjs.restClient(dio));
}

