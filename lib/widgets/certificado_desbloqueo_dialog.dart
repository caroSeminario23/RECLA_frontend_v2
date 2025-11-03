import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:recla/providers/certificado.dart';
import 'package:recla/providers/estatus.dart';
import 'package:recla/providers/usuario.dart';

class CertificadoDesbloqueoDialog extends StatelessWidget {
  final int idCertificado;
  final String urlImagen;
  final String nombreInsignia1;
  final String nombreInsignia2;
  final String nombreInsignia3;
  final bool desbloqueado;

  const CertificadoDesbloqueoDialog({
    super.key,
    required this.idCertificado,
    required this.urlImagen,
    required this.nombreInsignia1,
    required this.nombreInsignia2,
    required this.nombreInsignia3,
    required this.desbloqueado,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Título
          Text(
            '¿CÓMO PUEDO\nCONSEGUIRLO?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              letterSpacing: 2,
            ),
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
                      fontStyle: Theme.of(context).textTheme.bodySmall?.fontStyle,
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
              final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
              final certificadoProvider = Provider.of<CertificadoProvider>(context, listen: false);
              final estatusProvider = Provider.of<EstatusProvider>(context, listen: false);

              final int idUsuario = usuarioProvider.idUsuario ?? 1;
              
              try {
                final resultado = await certificadoProvider.desbloquearCertificado(idUsuario, idCertificado);
                
                //print('Resultado del desbloqueo: $resultado'); // DEBUG
                //print('Tipo de resultado: ${resultado.runtimeType}'); // DEBUG

                // Verifica si el widget sigue montado antes de usar context
                if (!context.mounted) return;

                if (resultado) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '¡Certificado desbloqueado correctamente!',
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      duration: Duration(seconds: 2),
                    ),
                  );

                  // Espera a que se muestre el SnackBar
                  //await Future.delayed(const Duration(seconds: 2));
                  
                  if (!context.mounted) return;

                  // Recargar insignias para actualizar la pantalla
                  //final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
                  //final estatusProvider = Provider.of<EstatusProvider>(context, listen: false);
                  //final idUsuario = usuarioProvider.idUsuario ?? 1;
                  
                  // Recarga los certificados
                  await certificadoProvider.obtenerCertificados(idUsuario);

                  // Actualiza los puntos del usuario
                  //await estatusProvider.cargarEstatusPerfil(idUsuario);
                  await estatusProvider.cargarEstatusContadores(idUsuario);

                  if (!context.mounted) return;
                  Navigator.of(context).pop();

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'No has desbloqueado las insignias necesarias para este certificado',
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.onError,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
                //Navigator.of(context).pop();
              } catch (e) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Error: ${e.toString()}',
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.onError,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },

            child: desbloqueado ?
              Text(
                '¡Lo he desbloqueado!',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.end,
              )
              : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}