import 'package:get/get.dart';
import 'package:spotify_remake_getx/abstract/services/api_service.dart';
import 'package:spotify_remake_getx/modules/home/controllers.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    final apiService = Get.find<ApiService>();
    Get.put(HomeController(api: apiService));
  }
}
