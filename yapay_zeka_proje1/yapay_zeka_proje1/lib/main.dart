import 'package:flutter/material.dart';
import 'grid_sayfasi.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GirisSayfasi(),
    );
  }
}

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({super.key});

  @override
  State<GirisSayfasi> createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Algoritma AI projesine Hoşgeldiniz"),
      backgroundColor: const Color.fromARGB(255, 106, 108, 106),
      foregroundColor: const Color.fromARGB(255, 0, 0, 0), // AppBar yazı ve ikon rengi
    ),
    backgroundColor: const Color.fromARGB(255, 106, 108, 106),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              return Container(
                height: 100,
                width: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [Colors.purple, Colors.pink, Colors.yellow],
                    stops: [0, _controller.value, 1],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color.fromARGB(255, 250, 250, 250)),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GridSayfasi()),
                    );
                  },
                  child: const Text("Grid Sayfasına Git"),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}
}
