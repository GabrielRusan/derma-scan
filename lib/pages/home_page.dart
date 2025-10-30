import 'package:derma_scan/constant/color.dart';
import 'package:derma_scan/controllers/diagnose_log_provider.dart';
import 'package:derma_scan/controllers/navigation_provider.dart';
import 'package:derma_scan/custom_widgets/custom_text.dart';
import 'package:derma_scan/custom_widgets/diagnose_container.dart';
import 'package:derma_scan/custom_widgets/ready_to_diagnose_container.dart';
import 'package:derma_scan/pages/camera_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? nama;

  String greetingByTime() {
    final hour = DateTime.now().hour;

    if (hour >= 4 && hour < 10) {
      return "Selamat Pagi";
    } else if (hour >= 10 && hour < 15) {
      return "Selamat Siang";
    } else if (hour >= 15 && hour < 18) {
      return "Selamat Sore";
    } else {
      return "Selamat Malam";
    }
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('nama');
    });
  }

  @override
  void initState() {
    _loadName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<DiagnoseLogProvider>(
          context,
          listen: false,
        ).fetchLogs();
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 75,
            backgroundColor: Colors.white,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Row(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.asset('assets/logo.png'),
                    ),
                    SizedBox(width: 12),
                    Text(
                      // '${greetingByTime()}, ${nama ?? ''}',
                      'test update, ${nama ?? ''}',
                      style: GoogleFonts.eduNswActFoundation(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 175,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16,
                  top: 4,
                  bottom: 4,
                ),
                child: ReadyToDiagnoseContainer(),
              ),
            ),
          ),
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 190,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16,
                  top: 20,
                  bottom: 4,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PoppinsText.headlineSmall(
                      'Cara melakukan Scanning',
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CameraPage()),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(top: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade100,
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      PoppinsText.headlineSmall(
                                        'Ambil gambar spesifik',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      SizedBox(height: 12),
                                      PoppinsText.bodyMedium(
                                        'Arahkan kamera ke area kulit\nyang mau kamu cek.',
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Image.asset(
                                    'assets/asset_2.png',
                                    alignment: Alignment.topLeft,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 8,
                            child: Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: Color(0xffBAD6FC),
                              ),
                              child: Center(
                                child: Text(
                                  '1#',
                                  style: TextStyle(
                                    color: primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 30,
            toolbarHeight: 30,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16,
                  bottom: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PoppinsText.headlineSmall('Screening sebelumnya'),
                    InkWell(
                      onTap: () {
                        Provider.of<NavigationProvider>(
                          context,
                          listen: false,
                        ).setIndex(1);
                      },
                      child: Row(
                        children: [
                          PoppinsText.bodyMedium('See more'),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Consumer<DiagnoseLogProvider>(
            builder: (context, logProvider, _) {
              if (logProvider.isLoading) {
                return SliverAppBar(
                  backgroundColor: Colors.white,
                  pinned: true,
                  expandedHeight: 75,
                  toolbarHeight: 75,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Center(child: CircularProgressIndicator()),
                  ),
                );
              }

              if (logProvider.allDiagnoseResult.isEmpty) {
                return SliverAppBar(
                  backgroundColor: Colors.white,
                  pinned: true,
                  expandedHeight: 75,
                  toolbarHeight: 75,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Center(
                      child: Text(
                        "Belum ada hasil scanning",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                );
              }

              final items = logProvider.allDiagnoseResult.take(10).toList();

              return SliverList(
                delegate: SliverChildBuilderDelegate(childCount: items.length, (
                  context,
                  index,
                ) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DiagnoseContainer(diagnoseResult: item),
                  );
                }),
              );
            },
          ),
          // Sliver
          // SliverList(delegate: SliverChildBuilderDelegate((context, index){

          // })),
          // SliverFillRemaining(),
        ],
      ),
    );
  }
}
