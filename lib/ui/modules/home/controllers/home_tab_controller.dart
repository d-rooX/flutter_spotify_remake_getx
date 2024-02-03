import 'package:get/get.dart';
import 'package:spotify/spotify.dart';

class HomeTracksTab {
  final String title;
  final RxList<Track> tracks;

  const HomeTracksTab({required this.title, required this.tracks});
}

class HomeTabController extends GetxController {
  final List<HomeTracksTab> tabs;
  HomeTabController({required this.tabs});
  var currentIndex = 0.obs;

  HomeTracksTab get currentTab => tabs.elementAt(currentIndex.value);
}
