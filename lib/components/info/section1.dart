import 'package:bms/components/SVI/svi.dart';
import 'package:flutter/material.dart';

Widget section1(Map states) {
  return Container(
    child: Column(
      children: [
        InfoRow(
          label1: 'Charging',
          status1: states['charging'],
          label2: 'Balance',
          status2: states['balance'],
        ),
        const SizedBox(height: 20),
        InfoRow(
          label1: 'DisMos',
          status1: states['dis_mos'],
          label2: 'Protection',
          status2: states['protection'],
        ),
      ],
    ),
  );
}

class InfoRow extends StatelessWidget {
  final String label1;
  final bool? status1;
  final String label2;
  final bool? status2;

  const InfoRow({
    Key? key,
    required this.label1,
    required this.status1,
    required this.label2,
    required this.status2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InfoColumn(label: label1, status: status1),
        const SizedBox(width: 20),
        InfoColumn(label: label2, status: status2),
      ],
    );
  }
}

class InfoColumn extends StatelessWidget {
  final String label;
  final bool? status;

  const InfoColumn({
    Key? key,
    required this.label,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 8),
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: status == true ? Colors.lightBlue : Colors.grey,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              status == true ? 'ON' : 'OFF',
              style: TextStyle(
                fontSize: 16,
                color: status == true ? Colors.lightBlue : Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
