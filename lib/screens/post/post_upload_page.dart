import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oasis/providers/food_post_provider.dart';

class PostUploadPage extends StatefulWidget {
  const PostUploadPage({super.key});

  @override
  State<PostUploadPage> createState() => _PostUploadPageState();
}

class _PostUploadPageState extends State<PostUploadPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _expirationDateController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];
  DateTime? _selectedExpirationDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _expirationDateController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      setState(() {
        if (_images.length + pickedFiles.length <= 5) {
          _images.addAll(pickedFiles);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('사진은 5장 까지만 선택할 수 있습니다.')),
          );
        }
      });
    } catch (e) {
      debugPrint('Error picking images: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _selectExpirationDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedExpirationDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 1825)),
    );
    if (picked != null && picked != _selectedExpirationDate) {
      setState(() {
        _selectedExpirationDate = picked;
        _expirationDateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _submitPost() async {
    final title = _titleController.text;
    final author = 'ideademisdedos';
    final description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty || _selectedExpirationDate == null || _images.first.path.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필드를 입력하고 사진을 1장 이상 등록해주세요.')),
      );
      return;
    }

    try {
      final resData = await context.read<FoodPostProvider>().createFoodPost(
        title,
        author,
        description,
        _images,
        _selectedExpirationDate!,
      );

      if (resData.success == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('음식 공유 글이 성공적으로 등록되었습니다!')),
        );
        _titleController.clear();
        _descriptionController.clear();
        _expirationDateController.clear();
        setState(() {
          _images.clear();
          _selectedExpirationDate = null;
        });
        context.go('/post/${resData.id}');
        // Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('음식 공유 글 등록 실패: ${context.read<FoodPostProvider>().errorMessage}')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            // 제목
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '음식 이름',
                border: OutlineInputBorder(),
                hintText: '공유할 음식의 이름을 적어주세요.'
              ),
            ),
            const SizedBox(height: 24),
            // 이미지
            const Text(
              '사진 등록 (최대 5장)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(_images.length, (index) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_images[index].path),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: -4,
                            right: -4,
                            child: IconButton(
                              icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                              onPressed: () => _removeImage(index),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  if (_images.isNotEmpty) const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _pickImages,
                    label: const Text('사진 선택하기'),
                    icon: const Icon(Icons.add_a_photo_outlined),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(color: Theme.of(context).colorScheme.primary)
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // 상세
            TextField(
              controller: _descriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              minLines: 1,
              decoration: const InputDecoration(
                labelText: '음식 설명',
                border: OutlineInputBorder(),
                hintText: '공유할 음식의 정보를 기입해 주세요.',
                alignLabelWithHint: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 30.0,
                  horizontal: 10.0
                )
              ),
            ),
            const SizedBox(height: 24),
            // 유통기한
            GestureDetector(
              onTap: () => _selectExpirationDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: _expirationDateController,
                  decoration: const InputDecoration(
                    labelText: '유통기한',
                    border: OutlineInputBorder(),
                    hintText: '공유하실 제품의 유통기한을 선택해주세요.',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // 등록
            ElevatedButton(
              onPressed: _submitPost,
              child: const Text('공유 하기'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}