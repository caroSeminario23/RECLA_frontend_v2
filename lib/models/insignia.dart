class InsigniaConEstado {
  int idInsignia;
  String nombre;
  String urlImagen;
  int nivel;
  bool desbloqueada;

  InsigniaConEstado({
    required this.idInsignia,
    required this.nombre,
    required this.urlImagen,
    required this.nivel,
    required this.desbloqueada,
  });

  factory InsigniaConEstado.fromJson(Map<String, dynamic> json) {
    return InsigniaConEstado(
      idInsignia: json['id_insignia'] as int,
      nombre: json['nombre'] as String,
      urlImagen: json['url_imagen'] as String,
      nivel: json['nivel'] as int,
      desbloqueada: json['desbloqueada'] as bool,
    );
  }
}