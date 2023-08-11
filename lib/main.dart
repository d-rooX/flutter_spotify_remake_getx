import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_remake_getx/app.dart';

void main() {
  runApp(
    const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: App(),
      getPages: [],
    ),
  );
}
