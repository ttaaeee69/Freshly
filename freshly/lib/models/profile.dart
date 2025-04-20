class Profile {
  final String uid;
  final String username;
  final String profileImage;

  Profile({
    required this.uid,
    required this.username,
    required this.profileImage,
  });

  // Convert Profile to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'profileImage': profileImage,
    };
  }
}
