import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/entities/blocks/image_block.dart';
import '../base_block_editor.dart';

class ImageEditor extends BlockEditor<ImageBlock> {
  const ImageEditor({
    super.key,
    required super.block,
    required super.onChanged,
  });

  @override
  State<ImageEditor> createState() => _ImageEditorState();
}

class _ImageEditorState extends State<ImageEditor> {
  final ImagePicker _picker = ImagePicker();
  String? _localPath;

  Future<void> _pickImage(ImageSource source) async {
    final file = await _picker.pickImage(source: source);
    if (file == null) return;
    setState(() => _localPath = file.path);
    // Local images are represented by their path as the URL until uploaded.
    widget.onChanged(ImageBlock(url: file.path));
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = _localPath != null || widget.block.url.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasImage)
          _localPath != null
              ? Image.file(File(_localPath!), fit: BoxFit.cover)
              : Image.network(
                  widget.block.url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const _ImageErrorPlaceholder(),
                ),
        Row(
          children: [
            TextButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Camera'),
            ),
            TextButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Gallery'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ImageErrorPlaceholder extends StatelessWidget {
  const _ImageErrorPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.broken_image_outlined, color: Colors.grey),
      ),
    );
  }
}
