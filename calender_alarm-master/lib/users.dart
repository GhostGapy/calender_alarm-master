class RegistrationData {
  final String id;
  final String email;
  final String password;

  RegistrationData(this.id, this.email, this.password);

  @override
  String toString() {
    return 'ID: $id, Email: $email, Password: $password';
  }
}
