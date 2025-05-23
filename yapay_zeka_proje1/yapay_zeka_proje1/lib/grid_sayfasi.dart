import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';

class GridSayfasi extends StatefulWidget {
  const GridSayfasi({super.key});

  @override
  State<GridSayfasi> createState() => _GridSayfasiDurumu();
}

class _GridSayfasiDurumu extends State<GridSayfasi> {
  final int baslangicIndex = 0;
  final int bitisIndex = 255;
  late List<int> engeller;
  List<int> bulunanYol = [];
  double agirlikW = 1.0;

  @override
  void initState() {
    super.initState();
    engeller = _rastgeleEngellerOlustur();
  }

  List<int> _rastgeleEngellerOlustur() {
    final rastgele = Random();
    final engelKumesi = <int>{};
    while (engelKumesi.length < 40) {
      int index = rastgele.nextInt(256);
      if (index != baslangicIndex && index != bitisIndex) {
        engelKumesi.add(index);
      }
    }
    return engelKumesi.toList();
  }

  void _bfsCalistir() {
    setState(() => bulunanYol = []);
    Future.delayed(const Duration(milliseconds: 50), () {
      final yol = _bfsIleYoluBul(baslangicIndex, bitisIndex, engeller.toSet());
      setState(() => bulunanYol = yol);
    });
  }

  void _ucsCalistir() {
    setState(() => bulunanYol = []);
    Future.delayed(const Duration(milliseconds: 50), () {
      final yol = _ucsIleYoluBul(baslangicIndex, bitisIndex, engeller.toSet());
      setState(() => bulunanYol = yol);
    });
  }

  void _dfsCalistir() {
    setState(() => bulunanYol = []);
    Future.delayed(const Duration(milliseconds: 50), () {
      final yol = _dfsIleYoluBul(baslangicIndex, bitisIndex, engeller.toSet());
      setState(() => bulunanYol = yol);
    });
  }

  void _aStarCalistir() {
    setState(() => bulunanYol = []);
    Future.delayed(const Duration(milliseconds: 50), () {
      final yol = _aStarIleYoluBul(
        baslangicIndex,
        bitisIndex,
        engeller.toSet(),
      );
      setState(() => bulunanYol = yol);
    });
  }

  void _bestFirstCalistir() {
    setState(() => bulunanYol = []);
    Future.delayed(const Duration(milliseconds: 50), () {
      final yol = _bestFirstSearch(
        baslangicIndex,
        bitisIndex,
        engeller.toSet(),
      );
      setState(() => bulunanYol = yol);
    });
  }

  void _greedyBestFirstCalistir() {
    setState(() => bulunanYol = []);
    Future.delayed(const Duration(milliseconds: 50), () {
      final yol = _greedyBestFirstSearch(
        baslangicIndex,
        bitisIndex,
        engeller.toSet(),
      );
      setState(() => bulunanYol = yol);
    });
  }

  
  List<int> _bfsIleYoluBul(int baslangic, int hedef, Set<int> engelSeti) {
    Queue<List<int>> kuyruk = Queue();
    Set<int> ziyaretEdilenler = {};
    kuyruk.add([baslangic]);

    while (kuyruk.isNotEmpty) {
      List<int> yol = kuyruk.removeFirst();
      int mevcut = yol.last;

      if (mevcut == hedef) return yol;
      if (ziyaretEdilenler.contains(mevcut)) continue;
      ziyaretEdilenler.add(mevcut);

      for (int komsu in _komsulariBul(mevcut)) {
        if (!ziyaretEdilenler.contains(komsu) && !engelSeti.contains(komsu)) {
          kuyruk.add([...yol, komsu]);
        }
      }
    }
    return [];
  }

  List<int> _ucsIleYoluBul(int baslangic, int hedef, Set<int> engelSeti) {
    List<List<int>> sacak = [
      [baslangic],
    ];
    Set<int> ziyaretEdilenler = {};

    while (sacak.isNotEmpty) {
      sacak.sort((a, b) => a.length.compareTo(b.length));
      List<int> yol = sacak.removeAt(0);
      int mevcut = yol.last;

      if (mevcut == hedef) return yol;
      if (ziyaretEdilenler.contains(mevcut)) continue;
      ziyaretEdilenler.add(mevcut);

      for (int komsu in _komsulariBul(mevcut)) {
        if (!ziyaretEdilenler.contains(komsu) && !engelSeti.contains(komsu)) {
          sacak.add([...yol, komsu]);
        }
      }
    }
    return [];
  }

  List<int> _dfsIleYoluBul(int baslangic, int hedef, Set<int> engelSeti) {
    List<List<int>> yigin = [
      [baslangic],
    ];
    Set<int> ziyaretEdilenler = {};

    while (yigin.isNotEmpty) {
      List<int> yol = yigin.removeLast();
      int mevcut = yol.last;

      if (mevcut == hedef) return yol;
      if (ziyaretEdilenler.contains(mevcut)) continue;
      ziyaretEdilenler.add(mevcut);

      for (int komsu in _komsulariBul(mevcut).reversed) {
        if (!ziyaretEdilenler.contains(komsu) && !engelSeti.contains(komsu)) {
          yigin.add([...yol, komsu]);
        }
      }
    }
    return [];
  }

  List<int> _aStarIleYoluBul(int baslangic, int hedef, Set<int> engelSeti) {
    List<List<int>> open = [
      [baslangic],
    ];
    Set<int> closed = {};

    int manhattan(int a, int b) {
      int ax = a % 16, ay = a ~/ 16;
      int bx = b % 16, by = b ~/ 16;
      return (ax - bx).abs() + (ay - by).abs();
    }

    while (open.isNotEmpty) {
      open.sort(
        (a, b) => (a.length + manhattan(a.last, hedef)).compareTo(
          b.length + manhattan(b.last, hedef),
        ),
      );
      List<int> yol = open.removeAt(0);
      int mevcut = yol.last;
      if (mevcut == hedef) return yol;
      if (closed.contains(mevcut)) continue;
      closed.add(mevcut);

      for (int komsu in _komsulariBul(mevcut)) {
        if (!closed.contains(komsu) && !engelSeti.contains(komsu)) {
          open.add([...yol, komsu]);
        }
      }
    }
    return [];
  }

  List<int> _bestFirstSearch(int baslangic, int hedef, Set<int> engelSeti) {
    List<List<int>> open = [
      [baslangic],
    ];
    Set<int> closed = {};

    int h(int n) {
      int x1 = n % 16, y1 = n ~/ 16;
      int x2 = hedef % 16, y2 = hedef ~/ 16;
      return (x1 - x2).abs() + (y1 - y2).abs();
    }

    while (open.isNotEmpty) {
      open.sort((a, b) => h(a.last).compareTo(h(b.last)));
      List<int> yol = open.removeAt(0);
      int mevcut = yol.last;
      if (mevcut == hedef) return yol;
      if (closed.contains(mevcut)) continue;
      closed.add(mevcut);

      for (int komsu in _komsulariBul(mevcut)) {
        if (!closed.contains(komsu) && !engelSeti.contains(komsu)) {
          open.add([...yol, komsu]);
        }
      }
    }
    return [];
  }

  List<int> _greedyBestFirstSearch(
    int baslangic,
    int hedef,
    Set<int> engelSeti,
  ) {
    List<List<int>> open = [
      [baslangic],
    ];
    Set<int> closed = {};

    int h(int n) {
      int x1 = n % 16, y1 = n ~/ 16;
      int x2 = hedef % 16, y2 = hedef ~/ 16;
      return (x1 - x2).abs() + (y1 - y2).abs();
    }

    while (open.isNotEmpty) {
      open.sort((a, b) => h(a.last).compareTo(h(b.last)));
      List<int> yol = open.removeAt(0);
      int mevcut = yol.last;
      if (mevcut == hedef) return yol;
      if (closed.contains(mevcut)) continue;
      closed.add(mevcut);

      List<List<int>> yeniYollar = [];
      for (int komsu in _komsulariBul(mevcut)) {
        if (!closed.contains(komsu) && !engelSeti.contains(komsu)) {
          yeniYollar.add([...yol, komsu]);
        }
      }

      if (yeniYollar.isNotEmpty) {
        yeniYollar.sort((a, b) => h(a.last).compareTo(h(b.last)));
        open.add(yeniYollar.first);
      }
    }
    return [];
  }

  

  List<int> _komsulariBul(int index) {
    List<int> komsular = [];
    int satir = index ~/ 16;
    int sutun = index % 16;

    if (satir > 0) komsular.add(index - 16);
    if (satir < 15) komsular.add(index + 16);
    if (sutun > 0) komsular.add(index - 1);
    if (sutun < 15) komsular.add(index + 1);

    return komsular;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("16x16 Izgara")),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 16,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemCount: 256,
                itemBuilder: (context, index) {
                  Color kutuRengi;

                  if (index == baslangicIndex) {
                    kutuRengi = Colors.green;
                  } else if (index == bitisIndex) {
                    kutuRengi = Colors.red;
                  } else if (engeller.contains(index)) {
                    kutuRengi = Colors.black;
                  } else if (bulunanYol.contains(index)) {
                    kutuRengi = Colors.lightGreen;
                  } else {
                    kutuRengi = Colors.grey[300]!;
                  }

                  return Container(color: kutuRengi);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: _bfsCalistir,
                  child: const Text("BFS"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: _ucsCalistir,
                  child: const Text("UCS"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                  ),
                  onPressed: _dfsCalistir,
                  child: const Text("DFS"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 234, 153, 31),
                  ),
                  onPressed: _aStarCalistir,
                  child: const Text("A*"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 128, 239, 228),
                  ),
                  onPressed: _bestFirstCalistir,
                  child: const Text("BeFS"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 236, 233, 224),
                  ),
                  onPressed: _greedyBestFirstCalistir,
                  child: const Text("G-BeFS"),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}
