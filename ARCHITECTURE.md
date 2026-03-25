# Arsitektur & Logika Bisnis

## Clean Architecture + MVVM

Aplikasi ini menggunakan kombinasi Clean Architecture dan MVVM untuk pemisahan concern yang optimal.

### Lapisan Arsitektur

```
Presentation Layer (UI)
        ↓
  ViewModel Layer (Logic)
        ↓
   Repository Layer (Interface)
        ↓
   Data Layer (Implementation)
        ↓
External Service (Firebase)
```

#### 1. **Presentation Layer** (`presentation/`)

Bertanggung jawab untuk UI dan user interaction.

- **Pages**: Layar aplikasi (LoginPage, HomePage, VehicleDetailPage)
- **Widgets**: Reusable UI components (ScheduleStatusCard, VehicleCard)
- **ViewModels**: State management & business logic orchestration

**Pattern**: MVVM dengan Provider

```dart
// ViewModel mengelola state dan UI logic
class VehicleViewModel extends ChangeNotifier {
  List<Vehicle> _vehicles = [];
  
  // ViewModel menyediakan data dan behavior ke UI
  List<Vehicle> get vehicles => _vehicles;
  
  Future<void> loadVehicles(String userId) async {
    _isLoading = true;
    notifyListeners(); // Notify UI untuk rebuild
    
    // Call repository untuk fetch data
    _vehicles = await _vehicleRepository.getAllVehicles(userId);
    
    _isLoading = false;
    notifyListeners();
  }
}
```

#### 2. **Core Layer** (`core/`)

Domain layer yang independent dari framework & implementation details.

- **Entities**: Business models yang pure (User, Vehicle, Schedule)
- **Repositories**: Abstract interfaces untuk data operations

```dart
// Entity - Pure business model
class Vehicle {
  final String id;
  final String name;
  final String plateNumber;
  final int currentKm;
  
  // Business logic di entity
  Vehicle updateKm(int newKm) {
    return this.copyWith(currentKm: newKm);
  }
}

// Abstract Repository - Contract
abstract class VehicleRepository {
  Future<List<Vehicle>> getAllVehicles(String userId);
  Future<Vehicle> addVehicle(String userId, Vehicle vehicle);
}
```

#### 3. **Data Layer** (`data/`)

Implementasi concrete dari repositories dan data fetching.

- **Models**: DTO (Data Transfer Object) dari Firebase
- **DataSources**: Interface untuk remote/local data
- **Repositories**: Concrete implementation

```dart
// Model extends Entity dengan serialization
class VehicleModel extends Vehicle {
  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(...);
  }
  
  Map<String, dynamic> toJson() { ... }
}

// DataSource - Implementation konkret
class VehicleRemoteDataSourceImpl {
  Future<List<VehicleModel>> getAllVehicles(String userId) async {
    // Firebase Firestore call
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('vehicles')
        .get();
    
    return snapshot.docs.map(...).toList();
  }
}

// Repository Impl - Use DataSource
class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDataSource dataSource;
  
  @override
  Future<List<Vehicle>> getAllVehicles(String userId) async {
    return await dataSource.getAllVehicles(userId);
  }
}
```

### Dependency Injection (GetIt)

ServiceLocator mengelola semua dependencies:

```dart
// Setup di main()
await ServiceLocator.setup();

// Usage di ViewModel
FirebaseFirestore auth = ServiceLocator.instance<FirebaseFirestore>();
```

## Business Logic - Logika Servis

### Schedule Status Logic

Status jadwal servis ditentukan berdasarkan 2 faktor:

1. **Time-based**: Perbandingan tanggal

```dart
bool isOverdue = currentDate >= nextDueDate
bool isUpcoming = (nextDueDate - 7 days) <= currentDate < nextDueDate
```

2. **KM-based**: Perbandingan kilometer

```dart
int nextServiceKm = lastServiceKm + intervalKm
bool isOverdue = currentKm >= nextServiceKm
bool isUpcoming = currentKm >= (nextServiceKm - 500 km buffer)
```

### Contoh Skenario

**Scenario 1**: Ganti Oli dengan interval 6 bulan atau 10,000 km

```
Last service: 1 Jan 2024 @ 50,000 km
Interval: 6 months OR 10,000 km

Tanggal due: 1 July 2024 (6 months later)
KM due: 60,000 km

Status pada 1 July 2024 @ 58,000 km:
✓ Time-based overdue (tanggal sudah lewat)
✓ KM upcoming (-2,000 km dari target)
→ Status: TERLAMBAT (prioritas time-based)

Status pada 1 July 2024 @ 68,000 km:
✓ Time & KM both overdue
→ Status: TERLAMBAT
```

### Notifikasi Trigger

1. **Local Notifications** (setiap hari)
   ```dart
   // Check jadwal vs current date
   if (schedule.isOverdue(today, currentKm)) {
     showNotification("Servis Terlambat!");
   } else if (schedule.isUpcoming(today, currentKm)) {
     showNotification("Servis Segera Hadir!");
   }
   ```

2. **FCM Notifications** (push dari server)
   ```
   - User opt-in untuk reminder notifications
   - Server schedule notifications sesuai jadwal
   - Deliver ke device via FCM
   ```

## Data Flow - Contoh: Load Vehicles

```
user taps "List Vehicles"
        ↓
   HomePage build
        ↓
   Consumer<VehicleViewModel>
        ↓
   VehicleViewModel.loadVehicles(userId)
        ↓
   VehicleRepository.getAllVehicles(userId)
        ↓
   VehicleRemoteDataSource.getAllVehicles(userId)
        ↓
   Firestore Query: 'users/{userId}/vehicles'
        ↓
   VehicleModel.fromJson(snapshot) × N
        ↓
   Return List<Vehicle>
        ↓
   ViewModel updates _vehicles list
        ↓
   notifyListeners() → Consumer rebuild
        ↓
   UI renders VehicleCard


Widget rebuild flow:
VehicleViewModel.loadVehicles() 
  → _vehicles = [...]
  → _isLoading = false
  → notifyListeners()
    → Consumer<VehicleViewModel> rebuild
      → ListView(children: vehicles.map(VehicleCard))
        → UI updated
```

## Firebase Database Structure

```
users/
  {userId}/
    vehicles/
      {vehicleId}/
        name: string
        plateNumber: string
        currentKm: int
        createdAt: timestamp
        
        schedules/
          {scheduleId}/
            type: "gantiOli" | "servisRutin"
            lastServiceDate: timestamp
            intervalDays: int (optional)
            intervalKm: int (optional)
            nextDueDate: timestamp
            lastServiceKm: int
            
        history/
          {historyId}/
            type: "gantiOli" | "servisRutin"
            date: timestamp
            costInRupiah: int
            notes: string
```

## Error Handling

Setiap layer memiliki error handling:

```dart
// ViewModel - User-friendly messages
catch (e) {
  _errorMessage = 'Gagal memuat kendaraan';
  notifyListeners();
}

// UI - Show error dialog
if (viewModel.errorMessage != null) {
  showDialog(ErrorDialog(message: viewModel.errorMessage));
}

// Firebase - Log errors
catch (e) {
  debugPrint('Firebase error: $e');
  rethrow; // Pass to ViewModel
}
```

## Best Practices Implemented

✅ Single Responsibility Principle
- Setiap class punya 1 responsibility
- ViewModel ≠ UI Logic
- Repository ≠ Firebase Implementation

✅ Dependency Inversion
- ViewModel depends on abstract Repository
- Repository implementation swappable
- Easy for testing & mocking

✅ State Management
- Provider untuk reactive setState
- notifyListeners() untuk UI updates
- Clear data flow

✅ Error Handling
- Try-catch di setiap operation
- User-friendly error messages
- Graceful failure recovery

✅ Async Operations
- Proper async/await handling
- Loading states managed
- Cancellation support (via Future)

## Performance Optimizations

1. **Lazy Loading**
   - Schedules & History loaded on-demand
   - Not loading all data at startup

2. **Local Caching** (TODO)
   - Cache vehicles list locally
   - Sync dengan Firestore

3. **Pagination** (TODO)
   - Load history 10 items first
   - Load more on scroll

4. **Index Creation**
   - Firestore indexes untuk query yang rumit
   - Setup di console.firebase.google.com

## Testing Strategy (Optional)

```dart
// Unit Tests
test('Schedule.isOverdue returns true when past due date', () {
  final schedule = Schedule(..., nextDueDate: now.subtract(1.day));
  expect(schedule.isOverdue(now, 0), true);
});

// Widget Testing
testWidgets('VehicleCard displays vehicle info', (tester) async {
  await tester.pumpWidget(VehicleCard(vehicle: mockVehicle));
  expect(find.text('Honda CB150R'), findsOneWidget);
});

// Integration Testing
testWidgets('Full flow: Login → Add Vehicle → Add Schedule', ...);
```

---

**Last Updated**: Maret 2026
