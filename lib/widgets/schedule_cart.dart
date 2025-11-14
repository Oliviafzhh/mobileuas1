import 'package:flutter/material.dart';
import '../models/schedule.dart';

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ScheduleCard({
    Key? key,
    required this.schedule,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: _getDayColor(schedule.day),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.subject,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Guru: ${schedule.teacherName}'),
                  Text('Kelas: ${schedule.className}'),
                  Text('${schedule.day} • ${schedule.time}'),
                ],
              ),
            ),
            if (onEdit != null || onDelete != null) ...[
              if (onEdit != null)
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getDayColor(String day) {
    switch (day) {
      case 'Senin':
        return Colors.blue;
      case 'Selasa':
        return Colors.green;
      case 'Rabu':
        return Colors.orange;
      case 'Kamis':
        return Colors.purple;
      case 'Jumat':
        return Colors.red;
      case 'Sabtu':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
}