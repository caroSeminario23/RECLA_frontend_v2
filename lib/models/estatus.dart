class EstatusPerfil {
  int racha;
  int ptosSistema;

  EstatusPerfil({
    required this.racha,
    required this.ptosSistema,
  });

  factory EstatusPerfil.fromJson(Map<String, dynamic> json) {
    return EstatusPerfil(
      racha: json['racha'] as int,
      ptosSistema: json['ptos_sistema'] as int,
    );
  }
}

class EstatusContadores {
  int nCompras;
  int nVentas;
  int nRecEducativos;

  EstatusContadores({
    required this.nCompras,
    required this.nVentas,
    required this.nRecEducativos,
  });

  factory EstatusContadores.fromJson(Map<String, dynamic> json) {
    return EstatusContadores(
      nCompras: json['n_compras'] as int,
      nVentas: json['n_ventas'] as int,
      nRecEducativos: json['n_rec_educativos'] as int,
    );
  }
}