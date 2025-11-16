class RecursoEducativo {
  final int idRecEdu;
  final String titulo;
  final String portadaUrl;
  final String referencia;
  final int tipoContenido;
  final String contenidoUrl;
  
  RecursoEducativo({
    required this.idRecEdu,
    required this.titulo,
    required this.portadaUrl,
    required this.referencia,
    required this.tipoContenido,
    required this.contenidoUrl,
  });

  factory RecursoEducativo.fromJson(Map<String, dynamic> json) {
    return RecursoEducativo(
      idRecEdu: json['id_rec_edu'],
      titulo: json['titulo'],
      portadaUrl: json['portada_url'],
      referencia: json['referencia'],
      tipoContenido: json['tipo_contenido'],
      contenidoUrl: json['contenido_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_rec_edu': idRecEdu,
      'titulo': titulo,
      'portada_url': portadaUrl,
      'referencia': referencia,
      'tipo_contenido': tipoContenido,
      'contenido_url': contenidoUrl,
    };
  }
}


class RecursoEducativoPortada {
  final int idRecEdu;
  final String titulo;
  final String portadaUrl;
  final int tipoContenido;
  final bool resuelto;
  final double porcentajeAcierto;

  RecursoEducativoPortada({
    required this.idRecEdu,
    required this.titulo,
    required this.portadaUrl,
    required this.tipoContenido,
    required this.resuelto,
    required this.porcentajeAcierto,
  });

  factory RecursoEducativoPortada.fromJson(Map<String, dynamic> json) {
    return RecursoEducativoPortada(
      idRecEdu: json['id_rec_edu'],
      titulo: json['titulo'],
      portadaUrl: json['portada_url'],
      tipoContenido: json['tipo_contenido'],
      resuelto: json['resuelto'],
      porcentajeAcierto: (json['porcentaje_acierto'] as num).toDouble(),
    );
  }
}


class RecursoEducativoContenido {
  final int idRecEdu;
  final String referencia;
  final String contenidoUrl;

  RecursoEducativoContenido({
    required this.idRecEdu,
    required this.referencia,
    required this.contenidoUrl,
  });

  factory RecursoEducativoContenido.fromJson(Map<String, dynamic> json) {
    return RecursoEducativoContenido(
      idRecEdu: json['id_rec_edu'],
      referencia: json['referencia'],
      contenidoUrl: json['contenido_url'],
    );
  }
}


class RecursoEducativoCuestionario {
  final int idCuestionario;
  final int orden;
  final String pregunta;
  final List<String> respuestas;
  final Map<int, String> mapeoRespuestas;
  
  RecursoEducativoCuestionario({
    required this.idCuestionario,
    required this.orden,
    required this.pregunta,
    required this.respuestas,
    required this.mapeoRespuestas,
  });

  factory RecursoEducativoCuestionario.fromJson(Map<String, dynamic> json) {
    return RecursoEducativoCuestionario(
      idCuestionario: json['id_cuestionario'],
      orden: json['orden'],
      pregunta: json['pregunta'],
      respuestas: List<String>.from(json['respuestas'] ?? []),
      mapeoRespuestas: Map<int, String>.from(
        (json['mapeo_respuestas'] as Map).map(
          (key, value) => MapEntry(int.parse(key.toString()), value as String),
        ),
      ),
    );
  }
}


class RecursoEducativoRespuesta {
  final int respuestasCorrectas;
  final int puntosExperiencia;

  RecursoEducativoRespuesta({
    required this.respuestasCorrectas,
    required this.puntosExperiencia,
  });

  factory RecursoEducativoRespuesta.fromJson(Map<String, dynamic> json) {
    return RecursoEducativoRespuesta(
      respuestasCorrectas: json['respuestas_correctas'],
      puntosExperiencia: json['puntos_experiencia'],
    );
  }
}