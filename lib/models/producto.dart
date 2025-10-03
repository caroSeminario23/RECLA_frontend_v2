
class ProductoRegistroRequest {
  int idProducto;
  int idVendedor;
  String urlFoto;
  double precio;
  int cantidad;
  String descripcion;
  bool comprado;
  int tipo;
  String material;
  String nombre;

  ProductoRegistroRequest({
    required this.idProducto,
    required this.idVendedor,
    required this.urlFoto,
    required this.precio,
    required this.cantidad,
    required this.descripcion,
    required this.comprado,
    required this.tipo,
    required this.material,
    required this.nombre,
  });
  Map<String, dynamic> toJson() {
    return {
      'id_producto': idProducto,
      'id_vendedor': idVendedor,
      'url_foto': urlFoto,
      'precio': precio,
      'cantidad': cantidad,
      'descripcion': descripcion,
      'comprado': comprado,
      'tipo': tipo,
      'material': material,
      'nombre': nombre,
    };
  }

}

class ProductoFiltradoRequest {
  List<int> tipo;
  String material;
  ProductoFiltradoRequest({
    required this.tipo,
    required this.material,
  });
  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo,
      'material': material,
    };
  }
}

class ProductoFiltradoResponse {
  int idProducto;
  String urlFoto;
  double precio;
  int cantidad;
  int tipo;
  String nombre;
  ProductoFiltradoResponse({
    required this.idProducto,
    required this.urlFoto,
    required this.precio,
    required this.cantidad,
    required this.tipo,
    required this.nombre,
  });
  factory ProductoFiltradoResponse.fromJson(Map<String, dynamic> json) {
    return ProductoFiltradoResponse(
      idProducto: json['id_producto'] as int,
      urlFoto: json['url_foto'] as String,
      precio: double.parse(json['precio'] as String),
      //precio: (json['precio'] as String).toDouble(),
      cantidad: json['cantidad'] as int,
      tipo: json['tipo'] as int,
      nombre: json['nombre'] as String,
    );
  }
}

class ProductoDetalleRequest{
  int idProducto;
  ProductoDetalleRequest({
    required this.idProducto
  });
  Map<String, dynamic> toJson() {
    return {
      'id_producto': idProducto,
    };
  }
}

class ProductoDetalleResponse {
  int idProducto;
  int idVendedor;
  String descripcion;
  //int tipo;
  String material;

  ProductoDetalleResponse({
    required this.idProducto,
    required this.idVendedor,
    required this.descripcion,
    //required this.tipo,
    required this.material,
  });
  factory ProductoDetalleResponse.fromJson(Map<String, dynamic> json) {
    return ProductoDetalleResponse(
      idProducto: json['id_producto'] as int,
      idVendedor: json['id_vendedor'] as int,
      descripcion: json['descripcion'] as String,
      //tipo: json['tipo'] as int,
      material: json['material'] as String,
    );
  }
}






