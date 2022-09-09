import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

// import '../../constants/constants.dart';
Future<File?> GetImage() async {
  final picker = ImagePicker();
  File _image;
  final pickedFile =
      await picker.getImage(source: ImageSource.camera, imageQuality: 70);
  // picker.
  if (pickedFile != null) {
    _image = File(pickedFile.path);
    return _image;
  } else {
    return null;
  }
}
Future<File?> GetVideoFromCamera() async {
  final picker = ImagePicker();
  File _image;
  final pickedFile =
      await picker.pickVideo(source: ImageSource.camera,);
  // picker.
  if (pickedFile != null) {
    _image = File(pickedFile.path);
    return _image;
  } else {
    return null;
  }
}

Future<File?> GetImageFromGallery() async {
  final picker = ImagePicker();
  File _image;
  final pickedFile =
      await picker.getImage(source: ImageSource.gallery, imageQuality: 70);
  if (pickedFile != null) {
    _image = File(pickedFile.path);
    return _image;
  } else {
    return null;
  }
}Future<File?> GetVideoFromGallery() async {
  final picker = ImagePicker();
  File _image;
  final pickedFile =
      await picker.pickVideo(source: ImageSource.gallery);
  if (pickedFile != null) {
    _image = File(pickedFile.path);
    return _image;
  } else {
    return null;
  }
}
// Future<List<File>> getImagesAndVideos() async {
//   FilePickerResult? result = await FilePicker.platform.pickFiles(
//     type: FileType.custom,
//     allowedExtensions: ['mp4','png','jpg'],
//   );
//   List<File> files =[];
//   if (result != null) {files = result.paths.map((path) => File(path!)).toList();
//   } else {
//     // User canceled the picker
//   }
//   return files;
// }
Future<List<File>?> getMultipleImages() async {
  print("inside multiple images");
  final picker = ImagePicker();
  List<File> _image=[];
  final pickedFile =
      await picker.pickMultiImage(imageQuality: 70);
  if (pickedFile != null) {

   for(int i=0;i<pickedFile.length;i++){
    // File? imageC=await  compressImage(File(pickedFile[i].path));
     _image.add(File(pickedFile[i].path));
   }
   print("got the picked fiels${pickedFile.length}");

    return _image;
  } else {
    return null;
  }
}
// Future<File?> CropImage(BuildContext context,File? imageFile) async {
//   File? croppedFile = await ImageCropper().cropImage(
//       compressQuality: 25,
//       sourcePath: imageFile!.path,
//       aspectRatio:const CropAspectRatio(ratioX: 1, ratioY: 1),
//       androidUiSettings:const AndroidUiSettings(
//           toolbarTitle: 'CROP',
//           toolbarColor: Constant.appColorblue,
//           toolbarWidgetColor: Colors.white,
//           initAspectRatio: CropAspectRatioPreset.square,
//           lockAspectRatio: true),
//       iosUiSettings:const IOSUiSettings(
//
//         title: 'CROP',
//       ));
//   if (croppedFile != null) {
//     return croppedFile;
//   }
// }
// Future<File?> compressImage(File file) async {
//   final filePath = file.absolute.path;
//   print(filePath);
//   int lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
//   print("last index${lastIndex.abs()}");
//   if(lastIndex==-1){
//     lastIndex=filePath.length-4;
//   }
//   print(filePath.substring(lastIndex));
//   final splitted = filePath.substring(0, (lastIndex));
//
//   final outPath = "${splitted}_out${".jpg"}";
//   print("outpath");
//   print(outPath);
//   File? compressedImage = await FlutterImageCompress.compressAndGetFile(
//       filePath,
//       outPath,
//       // minWidth: 1000,
//       // minHeight: 1000,
//       quality: 25);
//   return  compressedImage;
// }
