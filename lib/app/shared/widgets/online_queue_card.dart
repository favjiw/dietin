import 'package:flutter/material.dart';

class OnlineQueueCard extends StatelessWidget {
  final VoidCallback onPressed;

  const OnlineQueueCard({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    const blueButtonColor = Color(0xFF2BAFD4);
    const textBlue = Color(0xFF2BAFD4);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Left circle with illustration
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F7),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.network(
                'https://picsum.photos/72/72?onlinequeue',
                width: 48,
                height: 48,
                fit: BoxFit.contain,
                semanticLabel: 'Online Queue Illustration',
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Text and button
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Antrean Online',
                  style: TextStyle(
                    color: textBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Untuk kunjungan lebih efisien tanpa harus menunggu lama.',
                  style: TextStyle(
                    color: Color(0xFF6B6B6B),
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      minimumSize: const Size(120, 36),
                    ),
                    child: const Text(
                      'Ambil Antrean',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
