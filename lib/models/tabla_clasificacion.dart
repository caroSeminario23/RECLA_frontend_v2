class TablaClasificacion {
  final int posicion;
  final int idUsuario;
  final String username;
  final int ptosSistema;

  TablaClasificacion({
    required this.posicion,
    required this.idUsuario,
    required this.username,
    required this.ptosSistema,
  });

  factory TablaClasificacion.fromJson(Map<String, dynamic> json) {
    return TablaClasificacion(
      posicion: json['posicion'] as int,
      idUsuario: json['id_usuario'] as int,
      username: json['username'] as String,
      ptosSistema: json['ptos_sistema'] as int,
    );
  }
}
