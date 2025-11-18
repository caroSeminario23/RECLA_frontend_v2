import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recla/models/recurso_educativo.dart';
import 'package:recla/providers/recurso_educativo.dart';

import 'package:recla/providers/usuario.dart';
import 'package:recla/screens/chats.dart';
import 'package:recla/screens/compra_productos.dart';
import 'package:recla/screens/perfil_eco.dart';
import 'package:recla/screens/rec_edu_contenido.dart';
import 'package:recla/screens/tabla_clasificacion.dart';
import 'package:recla/widgets/grupo_preguntas.dart';
import 'package:recla/widgets/navbar.dart';
import 'package:recla/widgets/resultados_cuestionario.dart';

class RecEduCuestionarioPagina extends StatefulWidget {
  final RecursoEducativoPortada recursoPortada;
  const RecEduCuestionarioPagina({super.key, required this.recursoPortada});

  @override
  State<RecEduCuestionarioPagina> createState() => _RecEduCuestionarioPaginaState();
}

class _RecEduCuestionarioPaginaState extends State<RecEduCuestionarioPagina> {
  int opcionSeleccionada = 1; // Beneficios es la opción 1
  int? _idUsuario;
  List<RecursoEducativoCuestionario>? preguntasCuestionario;

  void _onItemTapped(int index) {
    setState(() {
      opcionSeleccionada = index;
    });

    // NAVEGACIÓN BASADA EN LA OPCIÓN SELECCIONADA
    if (index == 4) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const PerfilEcoPagina()));
    } else if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const TablaClasificacionPagina()));
    } else if (index == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CompraProductosPagina()));
    } else if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ChatsPagina()));
    }
  }

  // Cargar portadas de recursos educativos
  Future<void> _cargarPreguntas() async {
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    final recursoEducativoProvider = Provider.of<RecursoEducativoProvider>(context, listen: false);

    //final int idUsuario = usuarioProvider.idUsuario ?? 1;

    final preguntasCuestionario = await recursoEducativoProvider.cargarCuestionarioRecEducativo(widget.recursoPortada.idRecEdu);

    setState(() {
      _idUsuario = usuarioProvider.idUsuario ?? 1;
      this.preguntasCuestionario = preguntasCuestionario;
    });
  }

  @override
  void initState() {
    super.initState();
    
    // Usar addPostFrameCallback para asegurar que el contexto esté disponible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarPreguntas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'RECURSOS EDUCATIVOS',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => RecEduContenidoPagina(recursoPortada: widget.recursoPortada,)));
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Consumer<RecursoEducativoProvider>(
                builder: (context, recEduProvider, child) {
                  return GrupoPreguntas(
                    preguntas: preguntasCuestionario ?? const [],
                    onEnviar: (respuestas) async {
                      final userId = _idUsuario ?? 1;
                      final resultados = await recEduProvider.guardarRptsCuestionarioRecEducativo(
                        userId, 
                        widget.recursoPortada.idRecEdu, 
                        respuestas);
                      
                      //print('Resultados recibidos: $resultados');
                      //print('Cantidad: ${resultados.length}');
                      
                      if (!context.mounted) return;

                      if (resultados.isNotEmpty) {
                        final resultado = resultados.first;
                        //print('Mostrando diálogo con: ${resultado.respuestasCorrectas} correctas, ${resultado.puntosExperiencia} XP');
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => ResultadosCuestionarioDialog(
                            respuestasCorrectas: resultado.respuestasCorrectas,
                            totalPreguntas: 4,
                            puntosExperiencia: resultado.puntosExperiencia,
                          ),
                        );
                      }
                    },
                  );
                }
              )
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: NavBar(
          opcionSeleccionada: opcionSeleccionada,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}