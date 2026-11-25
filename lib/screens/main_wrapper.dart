import 'package:flutter/material.dart';

import '../services/event_store.dart';
import 'archive_screen.dart';
import 'radar_screen.dart';

/// Halaman utama: BottomNavigationBar Event Radar <-> Arsip Event.
/// Data diunduh sekali di sini lalu dibagi ke kedua tab.
class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final _store = EventStore();
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _store.load();
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [RadarScreen(store: _store), ArchiveScreen(store: _store)],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.radar), label: 'Event Radar'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Arsip Event'),
        ],
      ),
    );
  }
}
