class UsuarioLoginRequest {
  String email;
  String contrasena;

  UsuarioLoginRequest({
    required this.email,
    required this.contrasena,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'contrasena': contrasena,
    };
  }
}

class UsuarioLoginResponse {
  int idUsuario;
  String username;

  UsuarioLoginResponse({
    required this.idUsuario,
    required this.username,
  });

  factory UsuarioLoginResponse.fromJson(Map<String, dynamic> json) {
    return UsuarioLoginResponse(
      idUsuario: json['id_usuario'] as int,
      username: json['username'] as String,
    );
  }
}

class UsuarioRegistro {
  String email;
  String contrasena;
  String fecNacimiento;
  String username;

  UsuarioRegistro({
    required this.email,
    required this.contrasena,
    required this.fecNacimiento,
    required this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'contrasena': contrasena,
      'fec_nac': fecNacimiento,
      'username': username,
    };
  }
}

class EmailValidacion {
  String email;

  EmailValidacion({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

class UsernameValidacion {
  String username;

  UsernameValidacion({
    required this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
    };
  }
}