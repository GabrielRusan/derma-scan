import 'dart:io';

import 'package:derma_scan/constant/color.dart';
import 'package:derma_scan/constant/datetime_function.dart';
import 'package:derma_scan/controllers/diagnose_log_provider.dart';
import 'package:derma_scan/custom_widgets/custom_text.dart';
import 'package:derma_scan/models/diagnose_result_model.dart';
import 'package:derma_scan/pages/detail_diagnose_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DiagnoseContainer extends StatelessWidget {
  final DiagnoseResultModel diagnoseResult;

  const DiagnoseContainer({super.key, required this.diagnoseResult});

  @override
  Widget build(BuildContext context) {
    File image = File(diagnoseResult.imagePath);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailDiagnosePage(result: diagnoseResult),
          ),
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,

                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      image,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) => SizedBox(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      PoppinsText.headlineSmall(
                        diagnoseResult.predictedClass,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 14),
                      PoppinsText.bodyMedium(
                        customDateTimeFormatter(diagnoseResult.timeStamp),
                        overflow: TextOverflow.ellipsis,
                        // style: TextStyle(
                        //   fontWeight: FontWeight.w500,
                        //   fontSize: 16,
                        // ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -4,
            top: 8,
            child: PopupMenuButton(
              iconColor: Colors.grey,
              onSelected: (value) {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text(
                          'Konfirmasi',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        content: PoppinsText(
                          'Apakah kamu yakin ingin menghapus?',
                          textAlign: TextAlign.center,
                        ),
                        actionsAlignment: MainAxisAlignment.spaceAround,
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Tutup dialog
                            },
                            child: PoppinsText(
                              'Tidak',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Provider.of<DiagnoseLogProvider>(
                                context,
                                listen: false,
                              ).deleteLog(diagnoseResult.id);

                              Navigator.of(context).pop(); // Tutup dialog
                            },
                            child: PoppinsText(
                              'Ya',
                              color: primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                );
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: PoppinsText.body('Hapus', color: Colors.red),
                    ),
                  ],
            ),
          ),
        ],
      ),
    );
  }
}
