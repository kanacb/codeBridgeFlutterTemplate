import 'dart:convert';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import '../../Utils/Globals.dart' as globals;
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/SharedPreferences.dart';
import '../Users/User.dart';
import 'UploadFile.dart';

class UploaderService {
  Logger logger = globals.logger;

  Future<Response> uploadFile({
    required List<File> files,
    required String id,
    required String serviceName,
  }) async {
    final User user = User.fromJson(jsonDecode(await getPref("user") ?? ""));

    var uri = Uri.parse('${globals.api}/s3uploader');
    var request = http.MultipartRequest('POST', uri);
    for (var file in files) {
      request.files.add(
        await http.MultipartFile.fromPath('files', file.path),
      );
    }
    request.fields['tableId'] = id.isNotEmpty ? id : 'tempId';
    request.fields['tableName'] = serviceName;
    request.fields['user'] = jsonEncode(user ?? {});

    var streamedResponse = await request.send();
    var fullResponse = await http.Response.fromStream(streamedResponse);

    if (fullResponse.statusCode == 200) {
      // todo send local notification
      logger.i(
          " file uploaded! - data: ${fullResponse.body}, statusCode : ${fullResponse.statusCode}");
      return Response(
          msg: "file uploaded",
          data: fullResponse.body,
          error: null,
          statusCode: fullResponse.statusCode);
    } else {
      logger.i(
          "fullResponse: ${fullResponse.reasonPhrase}, statusCode : ${fullResponse.statusCode}");
    }
    return Response(
        msg: "failed to upload",
        data: fullResponse.body,
        error: fullResponse.reasonPhrase,
        statusCode: fullResponse.statusCode);
  }
}
