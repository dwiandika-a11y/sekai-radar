import 'package:material_ui/material_ui.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'screens/main_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID'); // nama bulan bahasa Indonesia
  runApp(const SekaiRadarApp());
}

class SekaiRadarApp extends StatelessWidget {
  const SekaiRadarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SekaiRadar JP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF33CCBB),
          brightness: Brightness.dark,
        ),
      ),
      home: const MainWrapper(),
    );
  }
}
