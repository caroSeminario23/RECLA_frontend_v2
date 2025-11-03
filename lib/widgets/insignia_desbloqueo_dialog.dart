import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recla/providers/estatus.dart';

import 'package:recla/utils/ref_imagenes.dart';
import 'package:recla/providers/insignia.dart';
import 'package:recla/providers/usuario.dart';

class InsigniaDesbloqueoDialog extends StatelessWidget {
  //final String nombreInsignia;
  final int idInsignia;
  final String urlImagen;
  //final String descripcion;
  final int comprasRequeridas;

  const InsigniaDesbloqueoDialog({
    super.key,
    //required this.nombreInsignia,
    required this.idInsignia,
    required this.urlImagen,
    //required this.descripcion,
    required this.comprasRequeridas,
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
            '¿CÓMO PUEDO\nCONSEGUIRLA?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          
          // Imagen y texto
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(urlImagen),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'La obtendrás cuando\nhayas realizado:',
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
                              '$comprasRequeridas compras ',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Image.asset(ptosCompra, width: 30, height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          InkWell(
            onTap: () async {
              final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
              final insigniaProvider = Provider.of<InsigniaProvider>(context, listen: false);
              final estatusProvider = Provider.of<EstatusProvider>(context, listen: false);

              final int idUsuario = usuarioProvider.idUsuario ?? 1;
              
              try {
                final resultado = await insigniaProvider.desbloquearInsignia(idUsuario, idInsignia);
                
                //print('Resultado del desbloqueo: $resultado'); // DEBUG
                //print('Tipo de resultado: ${resultado.runtimeType}'); // DEBUG

                // Verifica si el widget sigue montado antes de usar context
                if (!context.mounted) return;

                if (resultado) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '¡Insignia desbloqueada correctamente!',
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
                  
                  // Recarga las insignias del tipo correspondiente (ajusta según sea necesario)
                  await insigniaProvider.obtenerInsignias(idUsuario, 1); // compras
                  await insigniaProvider.obtenerInsignias(idUsuario, 2); // ventas
                  await insigniaProvider.obtenerInsignias(idUsuario, 3); // recursos educativos

                  // Actualiza los puntos del usuario
                  //await estatusProvider.cargarEstatusPerfil(idUsuario);
                  await estatusProvider.cargarEstatusContadores(idUsuario);

                  if (!context.mounted) return;
                  Navigator.of(context).pop();

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'No tienes suficientes puntos para desbloquear esta insignia',
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
                      'Ocurrió un error al intentar desbloquear la insignia',
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.onError,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },

            // Mensaje motivacional
            child: Text(
              '¡Lo he logrado!',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.end,
            ),
          )
        ],
      ),
    );
  }
}