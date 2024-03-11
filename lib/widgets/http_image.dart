import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sparkmob/utils/dio.dart';

/// 如果传了url，就加载url的图片，
/// 如果url图片加载失败就显示默认的图片
/// 如果没传url，加载默认图片
class HttpImage extends StatelessWidget {
  final String? imageUrl;
  final String defaultImg;
  final double? width;
  final double? height;

  const HttpImage(
      {super.key,
      this.imageUrl = "",
      this.width = 48,
      this.height = 48,
      required this.defaultImg});

  @override
  Widget build(BuildContext context) {
    if (imageUrl != "") {
      return FutureBuilder(
        future: loadImageFromNetwork(imageUrl!, width!, height!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return const CircularProgressIndicator();
          }
        },
      );
    } else {
      return Image.asset(
        defaultImg,
        width: 48,
        height: 48,
      );
    }
  }

  Future<Widget> loadImageFromNetwork(
      String url, double width, double height) async {
    try {
      var response = await dio.get(url,
          options: Options(responseType: ResponseType.bytes));
      return Image.memory(
        response.data,
        width: width,
        height: height,
      );
    } catch (e) {
      return Image.asset(
        defaultImg,
        width: 48,
        height: 48,
      );
    }
  }
}
