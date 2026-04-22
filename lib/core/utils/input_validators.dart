class InputValidators {
  InputValidators._();

  static String? requiredField(String? value, String fieldName) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return '$fieldName wajib diisi.';
    }
    return null;
  }

  static String? usernameOrEmail(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return 'Username atau email wajib diisi.';
    }

    if (input.contains(' ')) {
      return 'Input tidak boleh mengandung spasi.';
    }
    return null;
  }

  static String? username(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return 'Username wajib diisi.';
    }
    if (input.length < 4) {
      return 'Username minimal 4 karakter.';
    }
    if (!RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(input)) {
      return 'Username hanya boleh huruf, angka, titik, underscore, atau dash.';
    }
    return null;
  }

  static String? email(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return 'Email wajib diisi.';
    }
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(input)) {
      return 'Format email tidak valid.';
    }
    return null;
  }

  static String? password(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return 'Password wajib diisi.';
    }
    if (input.length < 8) {
      return 'Password minimal 8 karakter.';
    }
    return null;
  }

  static String? confirmPassword(String? value, String expectedPassword) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return 'Konfirmasi password wajib diisi.';
    }
    if (input != expectedPassword.trim()) {
      return 'Konfirmasi password tidak sama.';
    }
    return null;
  }
}
