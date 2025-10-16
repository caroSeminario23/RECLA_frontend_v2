class StickersConEstado {
  int idSticker;
  String urlImagen;
  int precio;
  bool desbloqueado;

  StickersConEstado({
    required this.idSticker,
    required this.urlImagen,
    required this.precio,
    required this.desbloqueado,
  });

  factory StickersConEstado.fromJson(Map<String, dynamic> json) {
    return StickersConEstado(
      idSticker: json['id_sticker'] as int,
      urlImagen: json['url_imagen'] as String,
      precio: json['precio'] as int,
      desbloqueado: json['desbloqueado'] as bool,
    );
  }
}