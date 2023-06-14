import 'package:calender_alarm/users.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  final List<RegistrationData> _registeredUsers = [];
  RegistrationData? _loggedInUser; // Define loggedInUser property

  List<RegistrationData> get registeredUsers => _registeredUsers;
  RegistrationData? get loggedInUser =>
      _loggedInUser; // Getter for loggedInUser

  void addUser(RegistrationData registeredUser) {
    _registeredUsers.add(registeredUser);
    notifyListeners();
  }

  void deleteUser(RegistrationData registeredUser) {
    _registeredUsers.remove(registeredUser);
    notifyListeners();
  }

  void setLoggedInUser(RegistrationData user) {
    _loggedInUser = user;
    notifyListeners();
  }

  void clearLoggedInUser() {
    _loggedInUser = null;
    notifyListeners();
  }
}
