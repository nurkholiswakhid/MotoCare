import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/entities/schedule.dart';
import '../../core/entities/service_history.dart';
import '../../core/entities/vehicle.dart';
import '../../presentation/viewmodels/auth_viewmodel.dart';
import '../../presentation/viewmodels/schedule_viewmodel.dart';
import '../../presentation/viewmodels/service_history_viewmodel.dart';
import '../../presentation/widgets/schedule_status_card.dart';
import '../../main.dart';

class VehicleDetailPage extends StatefulWidget {
  final Vehicle vehicle;

  const VehicleDetailPage({Key? key, required this.vehicle}) : super(key: key);

  @override
  State<VehicleDetailPage> createState() => _VehicleDetailPageState();
}

class _VehicleDetailPageState extends State<VehicleDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    Future.microtask(() {
      final authVM = context.read<AuthViewModel>();
      final scheduleVM = context.read<ScheduleViewModel>();
      final historyVM = context.read<ServiceHistoryViewModel>();

      scheduleVM.loadSchedules(authVM.currentUser!.id, widget.vehicle.id);
      historyVM.loadHistory(authVM.currentUser!.id, widget.vehicle.id);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          widget.vehicle.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Header Section with Rich Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primaryLight,
                  AppColors.accent,
                ],
                stops: const [0.0, 0.6, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.vehicle.name,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.vehicle.plateNumber,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.speed,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.vehicle.currentKm} km',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: AppColors.primary,
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            unselectedLabelStyle: GoogleFonts.poppins(),
            tabs: const [
              Tab(text: 'Jadwal Servis'),
              Tab(text: 'Riwayat'),
            ],
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildSchedulesTab(), _buildHistoryTab()],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          _showAddScheduleDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSchedulesTab() {
    return Consumer2<AuthViewModel, ScheduleViewModel>(
      builder: (context, authVM, scheduleVM, _) {
        if (scheduleVM.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (scheduleVM.schedules.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.calendar_today_rounded,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Belum ada jadwal servis',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (scheduleVM.overdueSchedules.isNotEmpty) ...[
              const Text(
                'Terlambat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              ...scheduleVM.overdueSchedules.map(
                (schedule) => ScheduleStatusCard(
                  schedule: schedule,
                  currentKm: widget.vehicle.currentKm,
                  onTap: () {
                    _showEditScheduleDialog(context, schedule, authVM);
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (scheduleVM.upcomingSchedules.isNotEmpty) ...[
              const Text(
                'Segera Hadir',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 8),
              ...scheduleVM.upcomingSchedules.map(
                (schedule) => ScheduleStatusCard(
                  schedule: schedule,
                  currentKm: widget.vehicle.currentKm,
                  onTap: () {
                    _showEditScheduleDialog(context, schedule, authVM);
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (scheduleVM.safeSchedules.isNotEmpty) ...[
              const Text(
                'Aman',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              ...scheduleVM.safeSchedules.map(
                (schedule) => ScheduleStatusCard(
                  schedule: schedule,
                  currentKm: widget.vehicle.currentKm,
                  onTap: () {
                    _showEditScheduleDialog(context, schedule, authVM);
                  },
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    return Consumer<ServiceHistoryViewModel>(
      builder: (context, historyVM, _) {
        if (historyVM.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (historyVM.history.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.history_rounded,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Belum ada riwayat servis',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: AppColors.primary.withOpacity(0.1),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Biaya Servis',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'Rp ${historyVM.totalCost.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...historyVM.history.map(
              (history) => Card(
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      history.type.toString().split('.').last == 'gantiOli'
                          ? Icons.local_gas_station_rounded
                          : Icons.build_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(
                    history.type.toString().split('.').last == 'gantiOli'
                        ? 'Ganti Oli'
                        : 'Servis Rutin',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat('dd/MM/yyyy').format(history.date)),
                      if (history.notes.isNotEmpty)
                        Text(
                          history.notes,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                  trailing: Text(
                    'Rp ${history.costInRupiah.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    _showHistoryDetailDialog(context, history);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddScheduleDialog(BuildContext context) {
    ServiceType selectedType = ServiceType.gantiOli;
    final lastServiceDateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
    );
    final intervalDaysController = TextEditingController();
    final intervalKmController = TextEditingController();
    final lastServiceKmController = TextEditingController(
      text: widget.vehicle.currentKm.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Tambah Jadwal Servis'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<ServiceType>(
                  value: selectedType,
                  isExpanded: true,
                  items: ServiceType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(
                            type.toString().split('.').last == 'gantiOli'
                                ? 'Ganti Oli'
                                : 'Servis Rutin',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedType = value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: lastServiceDateController,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Terakhir Servis',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      lastServiceDateController.text = DateFormat(
                        'dd/MM/yyyy',
                      ).format(date);
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: lastServiceKmController,
                  decoration: const InputDecoration(
                    labelText: 'KM Terakhir Servis',
                    prefixIcon: Icon(Icons.speed),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: intervalDaysController,
                  decoration: const InputDecoration(
                    labelText: 'Interval (Hari) - Opsional',
                    prefixIcon: Icon(Icons.today),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: intervalKmController,
                  decoration: const InputDecoration(
                    labelText: 'Interval (KM) - Opsional',
                    prefixIcon: Icon(Icons.speed),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final authVM = context.read<AuthViewModel>();
                final scheduleVM = context.read<ScheduleViewModel>();

                final lastDate = DateFormat(
                  'dd/MM/yyyy',
                ).parse(lastServiceDateController.text);
                final intervalDays = int.tryParse(intervalDaysController.text);
                final intervalKm = int.tryParse(intervalKmController.text);

                DateTime nextDue = lastDate;
                if (intervalDays != null) {
                  nextDue = lastDate.add(Duration(days: intervalDays));
                }

                final schedule = Schedule(
                  id: const Uuid().v4(),
                  vehicleId: widget.vehicle.id,
                  type: selectedType,
                  lastServiceDate: lastDate,
                  intervalDays: intervalDays,
                  intervalKm: intervalKm,
                  nextDueDate: nextDue,
                  lastServiceKm:
                      int.tryParse(lastServiceKmController.text) ??
                      widget.vehicle.currentKm,
                );

                scheduleVM.createSchedule(authVM.currentUser!.id, schedule);
                Navigator.pop(context);
              },
              child: const Text('Tambah'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditScheduleDialog(
    BuildContext context,
    Schedule schedule,
    AuthViewModel authVM,
  ) {
    // Similar implementation to add, but for editing
    // For brevity, implementing basic version
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Jadwal Servis'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              schedule.type.toString().split('.').last == 'gantiOli'
                  ? 'Ganti Oli'
                  : 'Servis Rutin',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Tanggal Terakhir: ${DateFormat('dd/MM/yyyy').format(schedule.lastServiceDate)}',
            ),
            const SizedBox(height: 8),
            Text(
              'Jatuh Tempo: ${DateFormat('dd/MM/yyyy').format(schedule.nextDueDate)}',
            ),
            if (schedule.intervalDays != null)
              Text('Interval: ${schedule.intervalDays} hari'),
            if (schedule.intervalKm != null)
              Text('Interval: ${schedule.intervalKm} km'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              final scheduleVM = context.read<ScheduleViewModel>();
              scheduleVM.deleteSchedule(authVM.currentUser!.id, schedule.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showHistoryDetailDialog(BuildContext context, ServiceHistory history) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Servis'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              history.type.toString().split('.').last == 'gantiOli'
                  ? 'Ganti Oli'
                  : 'Servis Rutin',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Tanggal: ${DateFormat('dd/MM/yyyy').format(history.date)}'),
            const SizedBox(height: 8),
            Text(
              'Biaya: Rp ${history.costInRupiah.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
            ),
            if (history.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Catatan: ${history.notes}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
