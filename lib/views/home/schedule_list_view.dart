import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/schedule_controller.dart';
import '../../models/schedule_model.dart';
import '../../utils/app_theme.dart';

class ScheduleListView extends StatelessWidget {
  const ScheduleListView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleController = Get.find<ScheduleController>();

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (scheduleController.isLoading.value) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppTheme.primary),
                  SizedBox(height: 16),
                  Text(
                    'Memuat jadwal tayang bioskop...',
                    style: TextStyle(color: AppTheme.textMuted),
                  ),
                ],
              ),
            );
          }

          if (scheduleController.errorMessage.value.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 56, color: AppTheme.error),
                    const SizedBox(height: 12),
                    const Text(
                      'Gagal Memuat Jadwal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      scheduleController.errorMessage.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => scheduleController.fetchSchedules(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (scheduleController.schedules.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada jadwal tayang tersedia saat ini.',
                style: TextStyle(color: AppTheme.textMuted),
              ),
            );
          }

          return RefreshIndicator(
            color: AppTheme.primary,
            backgroundColor: AppTheme.surface,
            onRefresh: () => scheduleController.fetchSchedules(),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: scheduleController.schedules.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final schedule = scheduleController.schedules[index];
                return _buildScheduleCard(schedule);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildScheduleCard(ScheduleModel schedule) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.confirmation_number_outlined,
                color: AppTheme.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.movieTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        schedule.cinema,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textMuted,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.access_time, size: 14, color: AppTheme.secondary),
                      const SizedBox(width: 4),
                      Text(
                        schedule.showTime,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primary.withAlpha(40),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primary),
              ),
              child: Text(
                schedule.price,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

