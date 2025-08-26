import 'package:derma_scan/controllers/diagnose_log_provider.dart';
import 'package:derma_scan/controllers/navigation_provider.dart';
import 'package:derma_scan/pages/camera_page.dart';
import 'package:derma_scan/pages/diagnose_log_page.dart';
import 'package:derma_scan/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID');
    WidgetsBinding.instance.addPostFrameCallback(
      (_) =>
          Provider.of<DiagnoseLogProvider>(context, listen: false).fetchLogs(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NavigationProvider>(context);
    return Scaffold(
      body: PageView(
        controller: provider.pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: provider.setIndex,
        children: [HomePage(), DiagnoseLogPage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 36),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, size: 36),
            label: 'Screening Log',
          ),
        ],
        currentIndex: provider.currentIndex,
        onTap: provider.setIndex,
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FittedBox(
          child: FloatingActionButton(
            shape: CircleBorder(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraPage()),
              );
            },
            child: Icon(Icons.center_focus_strong, size: 42),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
