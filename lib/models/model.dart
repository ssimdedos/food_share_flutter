
import 'package:flutter/material.dart';
// =================== 게시글 model ====================
class FoodPost {
  final int id;
  final String title;
  final List<String> imageUrl;
  final String author;
  final String description;
  final DateTime expirationDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FoodPost({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.author,
    required this.description,
    required this.expirationDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FoodPost.fromJson(Map<String, dynamic> json) {
    // 개발 시에만~!!!!!!!!
    final dynamic rawImageUrls = json['imageUrl'];
    List<String> parsedImageUrls;
    if (rawImageUrls == null) {
      parsedImageUrls = [];
    } else if (rawImageUrls is String) {
      if (rawImageUrls.isEmpty) {
        parsedImageUrls = [];
      } else {
        parsedImageUrls = rawImageUrls.split(',').map((url) {
          final String processedUrl = url.contains('localhost') ? url.replaceFirst('localhost', '10.0.2.2') : url;
          return processedUrl;
        }).toList();
      }
    } else if (rawImageUrls is List) {
      parsedImageUrls = rawImageUrls.map((item) {
        String urlString = item.toString();
        final String processedUrl = urlString.contains('localhost') ? urlString.replaceFirst('localhost', '10.0.2.2') : urlString;
        return processedUrl;
      }).toList();
    } else {
      print("Error: Unexpected type for imageUrl field: ${rawImageUrls.runtimeType}. Value: $rawImageUrls");
      parsedImageUrls = [];
    }

    // 배포시
    // json['imageUrl'].split(',') as List<String>,
    return FoodPost(
      id: json['id'] as int,
      title: json['title'] as String,
      imageUrl: parsedImageUrls,
      author: json['author'] as String,
      description: json['description'] as String,
      expirationDate: DateTime.parse(json['expirationDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
// =================== 게시글 model end ====================


// =================== 게시글 목록 ====================
class FoodPostForBoard {
  final int id;
  final String title;
  final String thumbnailUrl;
  final DateTime createdAt;

  const FoodPostForBoard ({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.createdAt
  });

  factory FoodPostForBoard.fromJson(Map<String, dynamic> json) {
    // 개발 시에만!!!!!!!!!!!!
    json['thumbnailUrl'] = json['thumbnailUrl'].contains('localhost')
        ? json['thumbnailUrl'].replaceFirst('localhost', '10.0.2.2')
        : json['thumbnailUrl'] ;
    return FoodPostForBoard(
        id: json['id'] as int,
        title: json['title'] as String,
        thumbnailUrl: json['thumbnailUrl'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String)
    );
  }

}
// =================== 게시글 목록 end ====================


// =================== 게시글 생성 응답 ====================
class CreatedPost {
  final int? id;
  final bool success;

  CreatedPost({required this.id, required this.success});

  factory CreatedPost.fromJson(Map<String,dynamic> json) {
    return CreatedPost(id: json['id'] as int, success: json['success'] as bool);
  }
}
// =================== 게시글 생성 응답 end ====================


// =================== 네비게이션 model ====================
class NavItem {
  final int index;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;

  const NavItem({
    required this.index,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,

  });
}
// =================== 네비게이션 model end ====================


// =================== User model ====================
class User {
  final int id;
  final String username;
  final String email;

  User({
    required this.id,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
    );
  }
}
// =================== User model end ====================
