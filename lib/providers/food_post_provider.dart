import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oasis/models/model.dart';
import 'package:oasis/services/food_api_service.dart';

enum FoodPostState {initial, loading, success, error}

class FoodPostProvider extends ChangeNotifier {
  final FoodApiService _foodApi =FoodApiService();

  List<FoodPostForBoard> _posts = [];
  List<FoodPostForBoard> get posts => _posts;

  FoodPost? _post;
  FoodPost? get post => _post;

  FoodPostState _state = FoodPostState.initial;
  FoodPostState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> getFoodPosts() async {
    _state = FoodPostState.loading;
    notifyListeners();
    try {
      _posts = await _foodApi.getFoodPosts();
      _state = FoodPostState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = FoodPostState.error;
    }
    notifyListeners();
  }

  Future<CreatedPost> createFoodPost(
      String title,
      String author,
      String description,
      List<XFile> imgFiles,
      DateTime expirationDate) async {
    _state = FoodPostState.loading;
    notifyListeners();
    try {
      final resData = await _foodApi.createFoodPost(title, author, description, imgFiles, expirationDate);
      _state = FoodPostState.success;
      return resData;
    } catch (e) {
      // print('error in Provider, $e');
      _errorMessage = e.toString();
      _state = FoodPostState.error;
      return CreatedPost(id: null, success: false);
    } finally {
      notifyListeners();
    }
  }

  Future<void> getFoodPost(int postId) async {
    _state = FoodPostState.loading;
    notifyListeners();
    try {
      final FoodPost postInfo  = await _foodApi.getFoodPost(postId);
      _post = postInfo;
      _state = FoodPostState.success;
    } catch (e) {
      _post=null;
      _errorMessage = e.toString();
      _state = FoodPostState.error;
    } finally {
      notifyListeners();
    }
}
}