import 'package:flutter/material.dart';
import 'package:recla/models/certificado.dart';

class GrupoCertificadosPersona extends StatelessWidget {
  final List<CertificadoDesbloqueado> certificados;

  const GrupoCertificadosPersona({super.key, required this.certificados});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        (certificados.length / 2).ceil(),
        (index) {
          final int first = index * 2;
          final int second = first + 1;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Primer certificado
                Expanded(child: _buildCertificado(certificados[first], context)),

                const SizedBox(width: 8),

                // Segundo certificado (si existe)
                Expanded(
                  child: second < certificados.length
                      ? _buildCertificado(certificados[second], context)
                      : const SizedBox(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCertificado(CertificadoDesbloqueado cert, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
          cert.urlImagen,
          height: 120,
          fit: BoxFit.contain,
          // Mostrar estado deshabilitado si no está obtenido
          //color: cert.desbloqueado ? null : Colors.grey,
          //colorBlendMode: cert.desbloqueado ? BlendMode.srcIn : BlendMode.saturation,
        ),
        const SizedBox(height: 4),
        Text(
          cert.nombre,
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        /*Text(
          'Nivel ${cert.nivel}',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
          textAlign: TextAlign.center,
        ),*/
      ],
    );
  }
}