import 'package:get/get.dart';
import '../models/schedule_model.dart';
import '../services/api_service.dart';

class ScheduleController extends GetxController {
  final RxList<ScheduleModel> schedules = <ScheduleModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSchedules();
  }

  Future<void> fetchSchedules() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final results = await ApiService.getSchedules();
      schedules.assignAll(results);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}

