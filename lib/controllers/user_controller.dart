
import 'package:get/get.dart';

// UserController
class UserController extends GetxController {
  var userData = {}.obs; // Utilisation de Rx pour observer les données

  void setUserData(Map<String, dynamic> data) {
    userData.value = data; // Mise à jour des données
  }
}