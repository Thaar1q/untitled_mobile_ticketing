enum UserRole { user, helpdesk, admin }

UserRole userRoleFromKey(String rawValue) {
  final normalized = rawValue.trim().toLowerCase();
  switch (normalized) {
    case 'admin':
      return UserRole.admin;
    case 'helpdesk':
      return UserRole.helpdesk;
    default:
      return UserRole.user;
  }
}

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.role,
  });

  final String id;
  final String name;
  final String username;
  final String email;
  final UserRole role;

  String get roleKey => role.name;

  String get displayRole {
    switch (role) {
      case UserRole.user:
        return 'User';
      case UserRole.helpdesk:
        return 'Helpdesk';
      case UserRole.admin:
        return 'Admin';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'role': roleKey,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: userRoleFromKey((json['role'] ?? 'user').toString()),
    );
  }
}
