import 'package:flutter/material.dart';
import 'dart:io';

class DocumentUpload extends StatelessWidget {
  final String? imageUrl;
  final File? newImage;
  final String type;
  final VoidCallback onPickImage;

  const DocumentUpload({
    super.key,
    required this.imageUrl,
    required this.newImage,
    required this.type,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: newImage != null
                  ? Image.file(
                      newImage!,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : (imageUrl != null
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(child: Icon(Icons.image_not_supported)),
                        )
                      : const Center(child: Icon(Icons.upload_file, size: 50))),
            ),
          ),
          FloatingImagePickerButton(onPressed: onPickImage),
        ],
      ),
    );
  }
}

class FloatingImagePickerButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FloatingImagePickerButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 8,
      bottom: 8,
      child: FloatingActionButton.small(
        heroTag: null,
        onPressed: onPressed,
        child: Icon(Icons.camera_alt, color: Color(0xFF213A58),),
        backgroundColor: const Color(0xFF80EE98),
      ),
    );
  }
}
