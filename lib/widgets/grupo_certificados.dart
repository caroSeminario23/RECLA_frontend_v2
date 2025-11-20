import 'package:flutter/material.dart';
import 'package:recla/models/certificado.dart';
import 'package:recla/widgets/certificado_desbloqueo_dialog.dart';
import 'package:recla/widgets/certificado_impresion_dialog.dart';

class GrupoCertificados extends StatelessWidget {
  final List<CertificadoConEstado> certificados;

  const GrupoCertificados({super.key, required this.certificados});

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

  Widget _buildCertificado(CertificadoConEstado cert, BuildContext context) {
    return GestureDetector(
      onTap: () {
          if (!cert.revisado && !cert.desbloqueado) {
            showDialog(
              context: context, 
              builder: (context) => CertificadoDesbloqueoDialog(
                idCertificado: cert.idCertificado,
                urlImagen: cert.urlImagen,
                nombreInsignia1: cert.nombreInsignia1,
                nombreInsignia2: cert.nombreInsignia2,
                nombreInsignia3: cert.nombreInsignia3,
                desbloqueado: false,
            ),
          );
          } else if (cert.desbloqueado && !cert.revisado) {
            showDialog(
              context: context, 
              builder: (context) => CertificadoDesbloqueoDialog(
                idCertificado: cert.idCertificado,
                urlImagen: cert.urlImagen,
                nombreInsignia1: cert.nombreInsignia1,
                nombreInsignia2: cert.nombreInsignia2,
                nombreInsignia3: cert.nombreInsignia3,
                desbloqueado: true,
              ),
            );
          } else if (cert.desbloqueado && cert.revisado) {
            showDialog(
              context: context, 
              builder: (context) => CertificadoImpresionDialog(
                idCertificado: cert.idCertificado,
                urlImagen: cert.urlImagen,
                nombreInsignia1: cert.nombreInsignia1,
                nombreInsignia2: cert.nombreInsignia2,
                nombreInsignia3: cert.nombreInsignia3,
                revisado: cert.revisado,
                plantillaCertificadoUrl: cert.urlImagen,
              ),
            );
          }
      },

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            cert.urlImagen,
            height: 120,
            fit: BoxFit.contain,
            // Mostrar estado deshabilitado si no está obtenido
            color: cert.desbloqueado ? null : Colors.grey,
            //color: cert.desbloqueado ? (cert.revisado ? null : Colors.amber) : Colors.grey,
            colorBlendMode: cert.desbloqueado ? BlendMode.srcIn : BlendMode.saturation,
          ),
          const SizedBox(height: 4),
          Text(
            cert.nombre,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: !cert.revisado && cert.desbloqueado ? Theme.of(context).colorScheme.primary : null,
              fontWeight: !cert.revisado && cert.desbloqueado ? FontWeight.bold : null,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          /*Text(
            'Nivel ${cert.nivel}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),*/
        ],
      ),
    );
  }
}