import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:spinchat/app/app.locator.dart';
import 'package:spinchat/app/app.logger.dart';
import 'package:spinchat/app/app.router.dart';
import 'package:spinchat/app/services/firebse_auth_service.dart';
import 'package:spinchat/app/services/firestore_service.dart';
import 'package:spinchat/app/services/localdatabase.dart';
import 'package:spinchat/utils/storage_keys.dart';
import 'package:spinchat/widgets/custom_snackbar.dart';
import 'package:spinchat/widgets/setup_ui_dialog.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginScreenViewModel extends BaseViewModel {
  final log = getLogger('Login Screen Viewmodel');

  ///SERVICES
  final _navigation = locator<NavigationService>();
  final _storage = locator<SharedPreferenceLocalStorage>();
  final _dialog = locator<DialogService>();
  final _authservice = locator<FirebaseAuthService>();
  final _snackbar = locator<SnackbarService>();
  final _fireStore = locator<FirestoreService>();

  ///Required Parameters in the view
  GlobalKey<FormState> resetForm = GlobalKey<FormState>();
  // User? get loggedInUSer => _authservice.getCurrentUSer();
  bool isLoading = true;
  TextEditingController newEmailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? snapshot;
  String? username;
  String? photoLink;

  Future<UserCredential?> login() async {
    try {
      if (resetForm.currentState!.validate()) {
        _dialog.showCustomDialog(
          variant: DialogType.login,
        );
        final createdUser = await _authservice.login(
            newEmailController.text, newPasswordController.text);
        if (createdUser != null) {
          await _storage.setBool(StorageKeys.isLoggedIn, true);
          await _storage.setBool(StorageKeys.registered, false);
          await _fireStore.updateDocument(
              collPath: 'users',
              docPath: createdUser.user!.uid,
              data: {'loggedIn': true});
          await _fireStore.getUSerDetails(createdUser.user!.uid).then((value) {
            username = value!['userName'];
            photoLink = value['photoUrl'];

            _storage.setString(StorageKeys.username, username!);
            _storage.setString(StorageKeys.photoUrl, photoLink!);
          });
          await _storage.setString(
              StorageKeys.currentUserId, createdUser.user!.uid);
          await _storage.setString(
              StorageKeys.userEmail, createdUser.user!.email!);

          _navigation.navigateTo(Routes.indexScreen);
          _snackbar.showCustomSnackBar(
              variant: SnackBarType.success,
              duration: const Duration(seconds: 4),
              message: 'Login Successful for $username');
          return createdUser;
        }
      } else if (newEmailController.text.isEmpty ||
          newPasswordController.text.isEmpty ||
          newEmailController.text == '' ||
          newPasswordController.text == '') {
        log.e('Fill all fields');
        _snackbar.showCustomSnackBar(
            variant: SnackBarType.failure, message: 'Please fill all fields');
      }
    } on FirebaseException catch (e) {
      _navigation.back();
      _snackbar.showCustomSnackBar(
          variant: SnackBarType.failure,
          duration: const Duration(seconds: 2),
          message: '${e.message}');
    } on SocketException {
      _navigation.back();
      _snackbar.showCustomSnackBar(
          variant: SnackBarType.failure,
          message: 'Please check your internet connection');
    }

    notifyListeners();
  }

  void navigateToRegistrationPage() {
    _navigation.replaceWith(Routes.registration);
  }
}
