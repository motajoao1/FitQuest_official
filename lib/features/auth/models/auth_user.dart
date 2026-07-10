enum AccountLevel {
  free,
  premium,
  admin,
}

class AuthUser {
  final String id;
  final String email;
  final String Senha;
  final AccountLevel accountLevel;

  const AuthUser({
    required this.id,
    required this.email,
    required this.Senha,
    required this.accountLevel,
  });
}
