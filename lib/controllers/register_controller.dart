import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:products_manager/services/utils.dart';
import 'package:products_manager/ui/login/login.dart';

class RegisterController extends GetxController {

  static RegisterController instance = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  var isLoading = false.obs; // Ajout de l'observable isLoading
  final Utils utils = Get.put(Utils());
  var verificationId = ''.obs;


  void register(String lastname, String firstname, String phone, String email,
      String password) async {
    isLoading.value = true; // Démarrage du spinner

    try {
      var userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print("User registered: ${userCredential.user?.uid}");

      print(firestore.collection('users'));
      await firestore.collection('users').add({
        "id": utils.generateUniqueId(),
        'lastname': lastname,
        'firstname': firstname,
        'phone': phone,
        'email': email,
      }).then((docRef) {
        print("User added with ID: ${docRef.id}");
      }).catchError((error) {
        print("Error adding user: $error");
      });

      sendEmailVerification();
    } catch (e) {
      Get.snackbar("Registration Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false; // Arrêt du spinner
    }
  }

  void sendEmailVerification() async {
    try {
      await auth.currentUser?.sendEmailVerification();

      Get.snackbar("Notification", "Lien d'activation envoyé",
          snackPosition: SnackPosition.BOTTOM);
      Get.offAll(Login());
    } catch (e) {
      Get.snackbar("Registration Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

}
