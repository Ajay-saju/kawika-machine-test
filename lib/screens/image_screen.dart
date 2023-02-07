import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

FilePickerResult? result;

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
              child: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                filePick();
              },
              child: const Text('select')),
          ElevatedButton(
              onPressed: () async {
                var data = formData(result!.files);
                print(data);

                // Future postCall() async {

                //   print(response.data);
                // }
              },
              child: const Text('Upload'))
        ],
      ))),
    );
  }

  void filePick() async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg'],
    );
    print(result!.files);
  }

  formData(List<PlatformFile> result) async {
    final dio = Dio();
    List<MultipartFile> images = [
      MultipartFile.fromFileSync(
        result[0].path!,
        filename: 'firstFile.jpg',
      ),
      MultipartFile.fromFileSync(result[1].path!,
          filename: "IMG-20230126-WA0028.jpg"),
    ];
    var data = FormData.fromMap({
      'userId': '1',
      'captions': 'hi Deeksha kutty',
      'projectId': '1',
      'images': images
    });
    print(data.files[0].value.toString());

    Response response = await dio.post(
        'https://api.bigwave.in/construction/DailyUpdatesController/add_updates',
        data: data);
    print(response.data);
  }
}
