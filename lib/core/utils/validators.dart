class Validators {
  // 이메일 검증
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return '올바른 이메일 형식을 입력해주세요';
    }

    return null;
  }

  // 비밀번호 검증
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }

    if (value.length < 8) {
      return '비밀번호는 8자 이상이어야 합니다';
    }

    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
      return '영문과 숫자를 포함해야 합니다';
    }

    return null;
  }

  // 이름 검증
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return '이름을 입력해주세요';
    }

    if (value.length < 2) {
      return '이름은 2자 이상이어야 합니다';
    }

    if (value.length > 20) {
      return '이름은 20자 이하여야 합니다';
    }

    return null;
  }

  // 필수 입력 검증
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? '값'}을 입력해주세요';
    }
    return null;
  }

  // 전화번호 검증
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return '전화번호를 입력해주세요';
    }

    final phoneRegex = RegExp(r'^01[0-9]-?[0-9]{4}-?[0-9]{4}$');
    if (!phoneRegex.hasMatch(value.replaceAll('-', ''))) {
      return '올바른 전화번호 형식을 입력해주세요';
    }

    return null;
  }
}