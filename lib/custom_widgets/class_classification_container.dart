import 'package:derma_scan/constant/color.dart';
import 'package:flutter/material.dart';

class ClassClassificationContainer extends StatelessWidget {
  final int topK;
  final double confidence;
  final String className;
  const ClassClassificationContainer({
    super.key,
    required this.topK,
    required this.confidence,
    required this.className,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(horizontal: 4),
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
            children: [
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Color(0xffBAD6FC),
                      ),
                      child: Center(
                        child: Text(
                          topK.toString(),
                          style: TextStyle(
                            color: primary,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            className,
                            style: TextStyle(
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
              SizedBox(width: 16),
              // Expanded(
              //   child: CircularPercentIndicator(
              //     radius: 30.0,
              //     lineWidth: 10.0,
              //     percent: confidence,
              //     center: Text(
              //       "${(confidence * 100).toStringAsFixed(0)}%",
              //       style: TextStyle(
              //         fontSize: 14.0,
              //         color: Colors.orange,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     progressColor: primary,
              //     backgroundColor: Colors.grey.shade300,
              //     circularStrokeCap: CircularStrokeCap.round,
              //     animation: true,
              //   ),
              // ),
              // SizedBox(width: 8),
              Icon(Icons.arrow_drop_up_outlined),
            ],
          ),
        ),
      ],
    );
  }
}
