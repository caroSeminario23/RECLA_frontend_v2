class CertificadoConEstado {
  final int idCertificado;
  final String nombre;
  final String urlImagen;
  final int nivel;
  final bool desbloqueado;
  final bool revisado;

  CertificadoConEstado({
    required this.idCertificado,
    required this.nombre,
    required this.urlImagen,
    required this.nivel,
    required this.desbloqueado,
    required this.revisado,
  });

  factory CertificadoConEstado.fromJson(Map<String, dynamic> json) {
    return CertificadoConEstado(
      idCertificado: json['id_certificado'] as int,
      nombre: json['nombre'] as String,
      urlImagen: json['url_imagen'] as String,
      nivel: json['nivel'] as int,
      desbloqueado: json['desbloqueado'] as bool,
      revisado: json['revisado'] as bool,
    );
  }
}


class CertificadoDesbloqueado {
  final int idCertificado;
  final int nivel;
  final String nombre;
  final String urlImagen;

  CertificadoDesbloqueado({
    required this.idCertificado,
    required this.nivel,
    required this.nombre,
    required this.urlImagen,
  });

  factory CertificadoDesbloqueado.fromJson(Map<String, dynamic> json) {
    return CertificadoDesbloqueado(
      idCertificado: json['id_certificado'] as int,
      nivel: json['nivel'] as int,
      nombre: json['nombre'] as String,
      urlImagen: json['url_imagen'] as String,
    );
  }
}