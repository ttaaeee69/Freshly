class Profile {
  String uid;
  String email;
  String username;
  String? profileImage;

  Profile(
      {required this.uid,
      required this.email,
      required this.username,
      this.profileImage});
}
