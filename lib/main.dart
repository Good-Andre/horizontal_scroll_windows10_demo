import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horizontal Scroll Demo (Windows 10)',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Horizontal Scroll Demo (Windows 10)')),
        body: Center(
          child: Container(
            height: 150,
            color: Colors.grey[300],
            child: ScrollConfiguration(
              behavior: MouseScrollBehavior(),
              child: ScrollMouseHandler(
                scrollDeltaDirection: -1.0, // change the direction of mouse wheel scrolling
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  primary: true, // Required for mouse wheel scroll
                  physics: const ClampingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemCount: 100,
                  itemBuilder:
                      (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              '$index',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ScrollMouseHandler extends StatefulWidget {
  final Widget child;
  final double scrollDeltaDirection;
  const ScrollMouseHandler({
  required this.child,
  this.scrollDeltaDirection = 1.0,
  super.key
  });

  @override
  State<ScrollMouseHandler> createState() => _ScrollMouseHandlerState();
}

class _ScrollMouseHandlerState extends State<ScrollMouseHandler> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      if (!_controller.hasClients) return;
      final double delta = event.scrollDelta.dy * widget.scrollDeltaDirection;
      _controller.animateTo(
        _controller.offset + delta,
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: _handlePointerSignal,
      child: PrimaryScrollController(
        controller: _controller,
        child: widget.child,
      ),
    );
  }
}

class MouseScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
