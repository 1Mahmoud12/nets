import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nets/core/utils/app_icons.dart';
import 'package:nets/core/utils/extensions.dart';

class ImageSelectionWidget extends StatefulWidget {
  final Function(File? selectedFile)? onImageSelected;
  final Color? borderColor;
  final File? file;

  const ImageSelectionWidget({Key? key, this.onImageSelected, this.borderColor, this.file}) : super(key: key);

  @override
  State<ImageSelectionWidget> createState() => _ImageSelectionWidgetState();
}

class _ImageSelectionWidgetState extends State<ImageSelectionWidget> {
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> selectImage() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

      if (pickedImage != null) {
        final File imageFile = File(pickedImage.path);
        setState(() {
          selectedImage = imageFile;
        });

        // Call the callback function to pass the selected image to the parent widget
        widget.onImageSelected!(imageFile);
      }
    } catch (e) {
      // Handle error
      debugPrint('Error picking image: $e');
    }
  }

  @override
  void didUpdateWidget(covariant ImageSelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.file != oldWidget.file && widget.file != null) {
      setState(() {
        selectedImage = widget.file;
      });
    }
  }

  void removeImage() {
    setState(() {
      selectedImage = null;
    });

    // Call the callback with null to inform parent widget the image was removed
    if (widget.onImageSelected != null) {
      widget.onImageSelected!(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return selectedImage == null
        ? Container(
            width: context.screenWidth,
            alignment: AlignmentDirectional.center,
            child: InkWell(
              onTap: selectImage,
              child: SvgPicture.asset(AppIcons.appLogo, fit: BoxFit.fitWidth, width: context.screenWidth),
            ),
          )
        : Stack(
            children: [
              Container(
                alignment: AlignmentDirectional.center,
                width: context.screenWidth,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(image: FileImage(selectedImage!), fit: BoxFit.fill),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: InkWell(
                  onTap: removeImage,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                    child: const Icon(Icons.close, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          );
  }
}
