
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart'; // MediaType
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:oasis/models/model.dart';
import 'package:oasis/utils/dio_client.dart';

class FoodApiService {
  final Dio _dio = dio;

  Future<List<FoodPostForBoard>> getFoodPosts() async {
    try {
      final res = await _dio.get('/foodPosts');
      if (res.statusCode == 200) {
        List<dynamic> data = res.data;
        return data.map((item) => FoodPostForBoard.fromJson(item)).toList();
      } else {
        throw Exception('서버로부터 데이터를 가져오지 못함');
      }
    } catch (e) {
      throw Exception('게시글 가져오기 실패: $e');
    }
  }

  Future<CreatedPost> createFoodPost(
      String title,
      String author,
      String description,
      List<XFile> imgFiles,
      DateTime expirationDate) async {
    try {
      List<MultipartFile> futures = [];

      for (int i = 0; i < imgFiles.length; i++) {
        XFile imgFile = imgFiles[i];
        print('XFile ${imgFile.name} (path: ${imgFile.path}) 바이트 읽기 시도...');
        String fileName = imgFile.name;
        String? mimeType = lookupMimeType(imgFile.path);

        final bytes = await imgFile.readAsBytes();
        print('XFile ${imgFile.name} 바이트 읽기 성공: ${bytes.length} bytes');
        futures.add(
          MultipartFile.fromBytes(bytes, filename: fileName, contentType: mimeType != null ? MediaType.parse(mimeType) : null),
        );
      }

      FormData formData = FormData.fromMap({
        "title": title,
        "author": author,
        "description": description,
        "images": futures,
        "expirationDate": expirationDate.toIso8601String()
      });
      final res = await _dio.post('/foodPosts', data: formData);
      if (res.statusCode == 201) {
        return CreatedPost(id: res.data?['id'], success: true);
      } else {
        throw Exception('게시글 등록 실패: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('게시글 등록 실패: $e');
    }
  }

  Future<FoodPost> getFoodPost (int postId) async {
    try {
      final res = await _dio.get('/foodPosts/post/$postId');
      if (res.statusCode == 200) {
        return FoodPost.fromJson(res.data);
      } else {
        throw Exception('게시글 가져오기 실패: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('게시글 가져오기 실패 (ID:$postId): $e');
    }
  }
 }