class InsigniaConEstado {
  int idInsignia;
  String nombre;
  String urlImagen;
  int nivel;
  int ptosNecesarios;
  bool desbloqueada;

  InsigniaConEstado({
    required this.idInsignia,
    required this.nombre,
    required this.urlImagen,
    required this.nivel,
    required this.ptosNecesarios,
    required this.desbloqueada,
  });

  factory InsigniaConEstado.fromJson(Map<String, dynamic> json) {
    return InsigniaConEstado(
      idInsignia: json['id_insignia'] as int,
      nombre: json['nombre'] as String,
      urlImagen: json['url_imagen'] as String,
      nivel: json['nivel'] as int,
      ptosNecesarios: json['ptos_necesarios'] as int,
      desbloqueada: json['desbloqueado'] as bool,
    );
  }
}



class InsigniaDesbloqueada {
  int idInsignia;
  String nombre;
  String urlImagen;
  int nivel;

  InsigniaDesbloqueada({
    required this.idInsignia,
    required this.nombre,
    required this.urlImagen,
    required this.nivel,
  });

  factory InsigniaDesbloqueada.fromJson(Map<String, dynamic> json) {
    return InsigniaDesbloqueada(
      idInsignia: json['id_insignia'] as int,
      nombre: json['nombre'] as String,
      urlImagen: json['url_imagen'] as String,
      nivel: json['nivel'] as int,
    );
  }
}