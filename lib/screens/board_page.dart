import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oasis/providers/food_post_provider.dart';
import 'package:provider/provider.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});
  
  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodPostProvider>().getFoodPosts();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FoodPostProvider>(
        builder: (context, provider, child) {
          if (provider.state == FoodPostState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.state == FoodPostState.error) {
            return Center(
              child: Text('데이터 로드 중 오류 발생: ${provider.errorMessage}'),
            );
          }

          if (provider.state == FoodPostState.success) {
            if (provider.posts.isEmpty) {
              return const Center(child: Text('공유된 음식이 없습니다.'));
            }
            return Column(
              children: [
                SizedBox(height: 4.0,),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.posts.length,
                    itemBuilder: (context, index) {
                      final post = provider.posts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              post.thumbnailUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(strokeWidth: 2.0),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.broken_image, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                          title: Text(post.title),
                          // subtitle: Text(post.description),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                          onTap: () {
                            context.push('/post/${post.id}');
                          },
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          }
          return const Center(child: Text('데이터를 로드 중입니다...'));
        },
      ),
    );
  }
}