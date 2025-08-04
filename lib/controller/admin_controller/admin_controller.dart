import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction_app/view/common_widgets/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {
  RxBool isloading = false.obs;
  createEmployee(String email, String password, String username,
      String mobileNum, BuildContext context) async {
    try {
      isloading.value = true;
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;

      // Store additional employee data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        'phone': mobileNum,
        'role': 'employee',
        'created_at': FieldValue.serverTimestamp(),
      });
      isloading.value = false;
      return true;
    } on FirebaseAuthException catch (e) {
      String message = 'Signup failed';
      if (e.code == 'email-already-in-use') {
        message = 'Email already in use';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email format';
      } else if (e.code == 'weak-password') {
        message = 'Password should be at least 6 characters';
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(CommonWidgets().snackBarinfo(message));
      isloading.value = false;
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          CommonWidgets().snackBarinfo('Error creating employee'));
      isloading.value = false;
      return false;
    }
  }

  Future<bool> addTool(
      String name, String code, int count, File imageFile, String type) async {
    // Validate inputs

    try {
      isloading.value = true;

      // Compress image
      final compressedImage = await FlutterImageCompress.compressWithFile(
        imageFile.path,
        minHeight: 800, // Reduce dimensions
        minWidth: 600, // Reduce dimensions
        quality: 70, // Reduce quality
      );
      if (compressedImage == null) {
        log("Image compression failed");
        isloading.value = false;
        return false;
      }

      // Convert to base64
      String base64Image = base64Encode(compressedImage);
      log("Compressed imageData length: ${base64Image.length}");

      // Validate size (should be < 1MB = 1,048,487 bytes)
      if (base64Image.length > 1048487) {
        log("Compressed imageData still exceeds 1MB: ${base64Image.length} bytes");
        isloading.value = false;
        return false;
      }

      // Add tool to Firestore
      await FirebaseFirestore.instance.collection('tools').doc(code).set({
        'name': name,
        'code': code,
        'count': count,
        'imageData': base64Image,
        'status': 'available',
        'type': type,
        'created_at': FieldValue.serverTimestamp(),
      });
      log("Tool added successfully");
      isloading.value = false;
      return true;
    } catch (e) {
      log("Exception: $e");
      isloading.value = false;
      return false;
    }
  }

  addSite(String placeName, String address, double lat, double lng,
      String siteName) async {
    try {
      isloading.value = true;
      await FirebaseFirestore.instance.collection('sites').add({
        'placeName': placeName,
        'address': address,
        'location': GeoPoint(lat, lng),
        'created_at': FieldValue.serverTimestamp(),
        'site_name': siteName
      });
      isloading.value = false;
      return true;
    } catch (e) {
      log("Exeption : $e");
      isloading.value = false;
      return false;
    }
  }
}
