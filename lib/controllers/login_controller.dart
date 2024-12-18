import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:products_manager/controllers/user_controller.dart';
import 'package:products_manager/ui/login/login.dart';
import 'package:products_manager/ui/products/product_page.dart';

class LoginController extends GetxController {
  static LoginController instance = Get.find();
  final UserController userController = Get.put(UserController());

  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var isLoading = false.obs; // Ajout de l'observable isLoading

  @override
  void onReady() {
    super.onInit();
  }

  void login(String email, String password) async {
    isLoading.value = true; // Démarrage du spinner
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;

      if (user != null && user.emailVerified) {
        // Requête pour récupérer les données utilisateur
        Map<String, dynamic>? userData = await getUserByEmail(email);

        if (userData != null) {
          print("userdata: $userData");
          userController.setUserData(userData);
        }

        Get.snackbar("Notification", "Login réussi",
            snackPosition: SnackPosition.BOTTOM);
        Get.offAll(ProductPage());
      } else {
        Get.snackbar("Vérification requise",
            "Un lien d'activation vous a été envoyé, veuillez vérifier votre boite mail.",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Erreur de connexion", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false; // Arrêt du spinner
    }
  }

  void logout() async {
    await auth.signOut();
    Get.offAll(Login());
  }

  // Méthode pour récupérer un utilisateur basé sur un attribut
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      // Requête Firestore avec une clause where
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        print("Aucun utilisateur trouvé avec l'email : $email");
        return null;
      }
    } catch (e) {
      print("Erreur lors de la récupération de l'utilisateur : $e");
      return null;
    }
  }


  Future passwordReset(String email) async {
    try{
      await auth.sendPasswordResetEmail(email: email);
      Get.offAll(Login());
      Get.showSnackbar(
        GetSnackBar(
          title: "Réinitialisation du mot de passe",
          messageText: RichText(
            text: TextSpan(
              text: "Un lien de réinitialisation a été envoyé à l'adresse ",
              children: [
                TextSpan(
                  text: "$email .",
                  style: TextStyle(fontWeight: FontWeight.bold), // Gras pour l'email
                ),
              ],
            ),
          ),
          duration: Duration(seconds: 3),
        ),
      );

    } on FirebaseAuthException catch(e) {
      Get.snackbar("Information", "${e.message.toString()}");
    }
  }
}
