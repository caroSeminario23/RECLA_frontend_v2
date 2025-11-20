import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:recla/providers/certificado.dart';
import 'package:recla/providers/estatus.dart';
import 'package:recla/providers/usuario.dart';

class CertificadoImpresionDialog extends StatelessWidget {
  final int idCertificado;
  final String urlImagen;
  final String nombreInsignia1;
  final String nombreInsignia2;
  final String nombreInsignia3;
  final bool revisado;
  final String plantillaCertificadoUrl;

  const CertificadoImpresionDialog({
    super.key,
    required this.idCertificado,
    required this.urlImagen,
    required this.nombreInsignia1,
    required this.nombreInsignia2,
    required this.nombreInsignia3,
    required this.revisado,
    required this.plantillaCertificadoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Título
          Text(
            '¿CÓMO PUEDO\nCONSEGUIRLO?',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(letterSpacing: 2),
          ),
          const SizedBox(height: 20),

          Container(
            width: 120,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(urlImagen),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 30),

          Text(
            'Lo obtendrás cuando\nhayas desbloqueado:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    '$nombreInsignia1, $nombreInsignia2 y $nombreInsignia3',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          Theme.of(context).textTheme.bodySmall?.fontStyle,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          InkWell(
            onTap: () async {
              final usuarioProvider = Provider.of<UsuarioProvider>(
                context,
                listen: false,
              );
              final certificadoProvider = Provider.of<CertificadoProvider>(
                context,
                listen: false,
              );
              final estatusProvider = Provider.of<EstatusProvider>(
                context,
                listen: false,
              );

              final int idUsuario = usuarioProvider.idUsuario ?? 1;

              try {
                if (!revisado) {
                  final resultado = await certificadoProvider
                      .desbloquearCertificado(idUsuario, idCertificado);

                  // Verifica si el widget sigue montado antes de usar context
                  if (!context.mounted) return;

                  if (resultado) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '¡Certificado desbloqueado correctamente!',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        duration: Duration(seconds: 2),
                      ),
                    );

                    if (!context.mounted) return;

                    // Recarga los certificados
                    await certificadoProvider.obtenerCertificados(idUsuario);

                    // Actualiza los puntos del usuario
                    await estatusProvider.cargarEstatusContadores(idUsuario);

                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'No has desbloqueado las insignias necesarias para este certificado',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.onError,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                } else {
                  final resultado = await certificadoProvider
                      .enviarCertificadoPorCorreo(idUsuario, idCertificado, usuarioProvider.username?? '', plantillaCertificadoUrl);

                  if (!context.mounted) return;

                  if (resultado) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '¡Certificado enviado a tu correo!',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        duration: const Duration(seconds: 2),
                      ),
                    );

                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error al enviar el certificado',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.onError,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                }
              } catch (e) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Error: ${e.toString()}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.onError,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },

            child:
                !revisado
                    ? Text(
                      '¡Lo he revisado!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.end,
                    )
                    //: SizedBox.shrink(),
                    // Mensaje motivacional
                    : Text(
                      '¡Envíenme mi certificado!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.end,
                    ),
          ),
        ],
      ),
    );
  }
}
