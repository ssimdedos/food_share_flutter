import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oasis/providers/auth_provider.dart';
import 'package:oasis/providers/chat_provider.dart';
import 'package:oasis/providers/food_post_provider.dart';
import 'package:provider/provider.dart';

class PostDetailPage extends StatefulWidget {
  final int postId;
  const PostDetailPage({super.key, required this.postId});


  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late PageController _imgController;
  int _currentImgIndex = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodPostProvider>().getFoodPost(widget.postId);
    });
    _imgController = PageController();
  }
  @override
  void dispose() {
    _imgController.dispose();
    super.dispose();
  }
  Future<void> onChat() async {
    try {
      final roomId = await context.read<ChatProvider>().createChat(
        context.read<FoodPostProvider>().post!.id,
        context.read<FoodPostProvider>().post!.authorId,
        context.read<AuthProvider>().currentUser!.id,
      );
      if (!mounted) {
        return;
      }
      context.push('/chat/$roomId');
    } catch (err) {
      print('채팅 생성 에러: $err');
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          if(context.canPop()) {
            context.pop();
          } else {
            context.go('/main');
          }
        },
        icon: const Icon(Icons.navigate_before)),
      ),
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
            if (provider.post == null) {
              return const Center(child: Text('게시글을 찾을 수 없습니다.'));
            } else {
              final post = provider.post!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 300,
                      child: PageView.builder(
                        controller: _imgController,
                        itemCount: post.imageUrl.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImgIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            post.imageUrl[index],
                            width: screenWidth,
                            height: 300,
                            fit: BoxFit.fitWidth,
                            loadingBuilder: (context, child, loadingProgress) {
                              if(loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    :null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(child: Text('이미지 로드 실패'));
                            },
                          );
                        },
                      ),
                    ),
                    if(post.imageUrl.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(post.imageUrl.length, (index) {
                            return AnimatedContainer(duration: const Duration(milliseconds: 150),
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            width: _currentImgIndex == index ? 13.0 : 8.0,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(4.0)
                            ),
                          );
                          }),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '작성자: ${post.author}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '유통기한: ${post.expirationDate.toLocal().toString().split(' ')[0]}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '등록일: ${post.createdAt.toLocal().toString().split(' ')[0]}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            post.description,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          ElevatedButton(
                            onPressed: onChat,
                            child: Text(
                              '채팅하기'
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return const Center(child: Text('데이터를 로드 중입니다...'));
        }),
    );
  }
}