import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recla/screens/cuestionario.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


import 'package:recla/models/recurso_educativo.dart';
import 'package:recla/providers/recurso_educativo.dart';
//import 'package:recla/providers/usuario.dart';
import 'package:recla/screens/chats.dart';
import 'package:recla/screens/compra_productos.dart';
import 'package:recla/screens/perfil_eco.dart';
import 'package:recla/screens/recursos_educativos.dart';
import 'package:recla/screens/tabla_clasificacion.dart';
import 'package:recla/widgets/datos_rec_edu.dart';
import 'package:recla/widgets/navbar.dart';


class RecEduContenidoPagina extends StatefulWidget {
  final RecursoEducativoPortada recursoPortada;

  const RecEduContenidoPagina({super.key, required this.recursoPortada});

  @override
  State<RecEduContenidoPagina> createState() => _RecEduContenidoPaginaState();
}

class _RecEduContenidoPaginaState extends State<RecEduContenidoPagina> {
  int opcionSeleccionada = 1; // Beneficios es la opción 1
  RecursoEducativoContenido? contenidoRecEdu;

  void _onItemTapped(int index) {
    setState(() {
      opcionSeleccionada = index;
    });

    // NAVEGACIÓN BASADA EN LA OPCIÓN SELECCIONADA
    if (index == 4) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const PerfilEcoPagina()));
    } else if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const TablaClasificacionPagina()),
      );
    } else if (index == 0) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const CompraProductosPagina()));
    } else if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ChatsPagina()));
    }
  }

  // Cargar portadas de recursos educativos
  Future<void> _cargarContenido() async {
    //final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    final recursoEducativoProvider = Provider.of<RecursoEducativoProvider>(context, listen: false);

    //final int idUsuario = usuarioProvider.idUsuario ?? 1;

    final contenidoRecEdu = await recursoEducativoProvider.presentarContenidoRecEducativo(widget.recursoPortada.idRecEdu);

    setState(() {
      this.contenidoRecEdu = contenidoRecEdu;
    });
  }

  //late WebViewController _webViewController;
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    
    // Inicializar el WebViewController
    /*_webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            // print('Página iniciando: $url');
          },
          onPageFinished: (String url) {
            // print('Página cargada: $url');
          },
          onWebResourceError: (WebResourceError error) {
            // print('Error: ${error.description}');
          },
        ),
      );*/

    // Inicializar el YoutubePlayerController
    _youtubeController = YoutubePlayerController(
      initialVideoId: '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false
      ),
    );

    // Usar addPostFrameCallback para asegurar que el contexto esté disponible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarContenido();
    });
  }


  @override
  void didUpdateWidget(RecEduContenidoPagina oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Si el recurso cambió, recargar el contenido
    if (oldWidget.recursoPortada.idRecEdu != widget.recursoPortada.idRecEdu) {
      setState(() {
        contenidoRecEdu = null; // Limpiar contenido anterior
      });
      _cargarContenido();
    }
  }


  // Método para inicializar YouTube Player
  YoutubePlayerController _inicializarYoutubePlayer(String videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    
    if (videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      );
    }
    return _youtubeController;
  }


  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  // Método para crear un nuevo WebViewController con configuración completa
  WebViewController _createWebViewController() {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..setOnConsoleMessage((JavaScriptConsoleMessage message) {});

  }

  // Método para obtener la URL correcta del PDF
  String _getPdfUrl(String url) {
    if (url.endsWith('.pdf')) {
      return 'https://docs.google.com/gviewer?url=${Uri.encodeComponent(url)}&embedded=true';
    }
    return url;
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
            ).push(MaterialPageRoute(builder: (_) => const RecursosEducativosPagina()));
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.recursoPortada.titulo,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              ),

              const SizedBox(height: 16),

              DatosRecursoEducativo(
                tipoContenido: widget.recursoPortada.tipoContenido, 
                resuelto: widget.recursoPortada.resuelto,
                porcentajeAcierto: widget.recursoPortada.porcentajeAcierto,
                referencia: contenidoRecEdu?.referencia,
              ),

              const SizedBox(height: 16),

              // CARGAR CONTENIDO DEL RECURSO EDUCATIVO: artículo web, infografía, video, artículo científico (todo vía url)

              if (widget.recursoPortada.tipoContenido == 1 && contenidoRecEdu != null)
                Column(
                  children: [
                    Text(
                      'Artículo web cargado desde: ${contenidoRecEdu!.contenidoUrl}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                    SizedBox(
                      height: 600,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: WebViewWidget(
                          controller: _createWebViewController()
                            ..loadRequest(Uri.parse(contenidoRecEdu!.contenidoUrl)),
                        ),
                      ),
                    ),
                  ],
                ),

              if (widget.recursoPortada.tipoContenido == 2 && contenidoRecEdu != null)
                Column(
                  children: [
                    Text(
                      'Infografía cargada desde: ${contenidoRecEdu!.contenidoUrl}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                    //Image.network(contenidoRecEdu!.contenidoUrl),
                    InteractiveViewer(
                      boundaryMargin: const EdgeInsets.all(100),
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Image.network(contenidoRecEdu!.contenidoUrl),
                    ),
                  ],
                ),

              if (widget.recursoPortada.tipoContenido == 3 && contenidoRecEdu != null)
                // Mostrar video (usando un paquete de video)
                Column(
                  children: [
                    Text(
                      'Video cargado desde: ${contenidoRecEdu!.contenidoUrl}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    YoutubePlayer(
                      controller: _inicializarYoutubePlayer(contenidoRecEdu!.contenidoUrl),
                      onReady: () {
                        //print('YouTube Player Ready');
                      },
                      onEnded: (metaData) {
                        //print('Video terminado');
                      },
                    ),
                  ],
                ),


              if (widget.recursoPortada.tipoContenido == 4 && contenidoRecEdu != null)
                // Mostrar artículo científico en un WebView o similar
                Column(
                  children: [
                    Text(
                      'Artículo científico cargado desde: ${contenidoRecEdu!.contenidoUrl}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 600,
                      child: WebViewWidget(
                        controller: _createWebViewController()
                          ..loadRequest(
                            Uri.parse(contenidoRecEdu!.contenidoUrl),
                          ),
                      ),
                    ),
                  ],
                ),

              if (contenidoRecEdu == null)
                // Mensaje de error de carga
                const Text('Disculpa, estamos teniendo problemas para cargar el contenido de este recurso educativo.'),

              const SizedBox(height: 30),

              // BOTON PARA RESOLVER EL CUESTIONARIO
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CuestionarioPagina(),
                    ),
                  );
                },
                icon: const Icon(Icons.text_snippet_sharp),
                label: const Text('Resolver cuestionario'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(
                        context,
                      ).colorScheme.secondaryContainer, // Fondo verde
                  foregroundColor:
                      Theme.of(context)
                          .colorScheme
                          .onSecondaryContainer, // Texto e ícono blancos
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 2,
                  ), // Borde verde oscuro
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // Opcional: bordes redondeados
                  ),
                  minimumSize: const Size.fromHeight(50),
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
              ),

              /*Consumer<RecursoEducativoProvider>(
                builder: (context, recEduProvider, child) {
                  return GrupoREducativos(
                    recursos: portadasRecEdu,
                  );
                }
              )*/
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