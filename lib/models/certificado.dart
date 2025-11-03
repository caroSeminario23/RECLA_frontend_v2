class CertificadoConEstado {
  final int idCertificado;
  final String nombre;
  final String urlImagen;
  final int nivel;
  final bool desbloqueado;
  bool revisado;
  final String nombreInsignia1;
  final String nombreInsignia2;
  final String nombreInsignia3;

  CertificadoConEstado({
    required this.idCertificado,
    required this.nombre,
    required this.urlImagen,
    required this.nivel,
    required this.desbloqueado,
    required this.revisado,
    required this.nombreInsignia1,
    required this.nombreInsignia2,
    required this.nombreInsignia3,
  });

  factory CertificadoConEstado.fromJson(Map<String, dynamic> json) {
    return CertificadoConEstado(
      idCertificado: json['id_certificado'] as int,
      nombre: json['nombre'] as String,
      urlImagen: json['url_imagen'] as String,
      nivel: json['nivel'] as int,
      desbloqueado: json['desbloqueado'] as bool,
      revisado: json['revisado'] as bool,
      nombreInsignia1: json['nombre_insignia_1'] as String,
      nombreInsignia2: json['nombre_insignia_2'] as String,
      nombreInsignia3: json['nombre_insignia_3'] as String
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