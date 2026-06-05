import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class SavedAccount {
  final String username;
  final String password;
  final String userType;

  SavedAccount({
    required this.username,
    required this.password,
    required this.userType,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'userType': userType,
  };

  factory SavedAccount.fromJson(Map<String, dynamic> json) {
    return SavedAccount(
      username: json['username'],
      password: json['password'],
      userType: json['userType'],
    );
  }
}

class LocalAuthService {
  static const _storage = FlutterSecureStorage();
  static const _accountsKey = 'saved_accounts';
  static final LocalAuthentication _localAuth = LocalAuthentication();

  static Future<bool> authenticate() async {
    try {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      bool isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canCheckBiometrics && !isDeviceSupported) {
        return true;
      }

      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to login securely',
      );
    } catch (e) {
      return false;
    }
  }

  static Future<List<SavedAccount>> getSavedAccounts() async {
    String? accountsStr = await _storage.read(key: _accountsKey);
    if (accountsStr != null) {
      List<dynamic> jsonList = jsonDecode(accountsStr);
      return jsonList.map((e) => SavedAccount.fromJson(e)).toList();
    }
    return [];
  }

  static Future<void> saveAccount(
    String username,
    String password,
    String userType,
  ) async {
    List<SavedAccount> accounts = await getSavedAccounts();
    // Remove if already exists to update password
    accounts.removeWhere(
      (acc) => acc.username == username && acc.userType == userType,
    );

    accounts.add(
      SavedAccount(username: username, password: password, userType: userType),
    );

    List<Map<String, dynamic>> jsonList = accounts
        .map((e) => e.toJson())
        .toList();
    await _storage.write(key: _accountsKey, value: jsonEncode(jsonList));
  }

  static Future<void> updatePasswordIfSaved(
    String username,
    String newPassword,
    String userType,
  ) async {
    List<SavedAccount> accounts = await getSavedAccounts();
    bool updated = false;
    for (int i = 0; i < accounts.length; i++) {
      if (accounts[i].username == username &&
          accounts[i].userType == userType) {
        accounts[i] = SavedAccount(
          username: username,
          password: newPassword,
          userType: userType,
        );
        updated = true;
      }
    }
    if (updated) {
      List<Map<String, dynamic>> jsonList = accounts
          .map((e) => e.toJson())
          .toList();
      await _storage.write(key: _accountsKey, value: jsonEncode(jsonList));
    }
  }

  static Future<void> removeAccount(String username, String userType) async {
    List<SavedAccount> accounts = await getSavedAccounts();
    accounts.removeWhere(
      (acc) => acc.username == username && acc.userType == userType,
    );
    List<Map<String, dynamic>> jsonList = accounts
        .map((e) => e.toJson())
        .toList();
    await _storage.write(key: _accountsKey, value: jsonEncode(jsonList));
  }
}
