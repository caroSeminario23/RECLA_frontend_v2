class VentaRegistroRequest {
  int idProducto;
  int idComprador;
  int idVendedor;

  VentaRegistroRequest({
    required this.idProducto,
    required this.idComprador,
    required this.idVendedor,
  });
  Map<String, dynamic> toJson() {
    return {
      'id_producto': idProducto,
      'id_comprador': idComprador,
      'id_vendedor': idVendedor,
    };
  }

}