import '../interfaces/home_interface.dart';
import '../interfaces/library_interface.dart';
import '../interfaces/player_interface.dart';

abstract interface class ApiService
    implements HomeInterface, LibraryInterface, PlayerInterface {}
