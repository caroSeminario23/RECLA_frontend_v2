import 'package:flutter/material.dart';
import 'package:recla/models/recurso_educativo.dart';

class GrupoPreguntas extends StatefulWidget {
  final List<RecursoEducativoCuestionario> preguntas;
  final ValueChanged<Map<int, String>>? onEnviar;

  const GrupoPreguntas({
    super.key,
    required this.preguntas,
    this.onEnviar,
  });

  @override
  State<GrupoPreguntas> createState() => _GrupoPreguntasState();
}

class _GrupoPreguntasState extends State<GrupoPreguntas> {
  final Map<int, String> _seleccionadas = {};
  bool _botonActivo = false;

  void _seleccionarRespuesta(int orden, String variableRespuesta) {
    setState(() => _seleccionadas[orden] = variableRespuesta);
  }

  void _enviar() {
    setState(() => _botonActivo = true);
    widget.onEnviar?.call(_seleccionadas);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _botonActivo = false);
    });
  }

  bool get _puedeEnviar => _seleccionadas.length == widget.preguntas.length;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFD5EBD8),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFF0A6F3C), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                'HORA DEL CUESTIONARIO',
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.secondaryContainer),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...widget.preguntas.map((pregunta) {
            final seleccion = _seleccionadas[pregunta.orden];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PREGUNTA ${pregunta.orden}: ${pregunta.pregunta}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: pregunta.respuestas.asMap().entries.map((entry) {
                      final index = entry.key;
                      final respuestaTexto = entry.value;
                      final variableRespuesta = pregunta.mapeoRespuestas[index] ?? '';
                      final activa = seleccion == variableRespuesta;
                      
                      return GestureDetector(
                        onTap: () => _seleccionarRespuesta(
                          pregunta.orden,
                          variableRespuesta,
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: activa
                                ? Theme.of(context).colorScheme.onTertiaryContainer
                                : Theme.of(context).colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              if (activa)
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                            ],
                          ),
                          child: Text(
                            respuestaTexto,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: activa
                                  ? Theme.of(context).colorScheme.tertiaryContainer
                                  : Theme.of(context).colorScheme.onTertiaryContainer,
                              //fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _botonActivo
                  ? const Color(0xFF074F2B)
                  : const Color(0xFF0A6F3C),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            onPressed: _puedeEnviar ? _enviar : null,
            child: Text(
              'Enviar respuestas',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}