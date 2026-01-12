# Flutter Widgets Integration Guide

**Quick reference for using CargoLink UI components**

---

## 🚀 Authentication Widgets

### EmailInputField
**Purpose**: Reusable email input with validation

**Props**:
```dart
EmailInputField(
  controller: emailController,
  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
  onChanged: (value) => print('Email: $value'),
  labelText: 'Email Address',
  hintText: 'Enter your email',
)
```

**Default Behavior**:
- ✅ Email regex validation
- ✅ Focus state styling
- ✅ Error border on invalid input
- ✅ Icon with dynamic coloring

---

### PasswordInputField
**Purpose**: Secure password input with show/hide toggle

**Props**:
```dart
PasswordInputField(
  controller: passwordController,
  validator: (value) => value?.length ?? 0 < 6 ? 'Min 6 chars' : null,
  onChanged: (value) => print('Password: $value'),
  labelText: 'Password',
  hintText: 'Enter your password',
  isConfirmPassword: false,
)
```

**Features**:
- ✅ Password visibility toggle
- ✅ Minimum 6 character validation
- ✅ Custom error messages
- ✅ Confirm password variant

---

### CustomButton & SecondaryButton
**Purpose**: Filled and outlined buttons with loading states

**CustomButton (Filled)**:
```dart
CustomButton(
  text: 'Sign In',
  onPressed: () => _handleLogin(),
  isLoading: isLoading,
  isEnabled: isFormValid,
  backgroundColor: AppTheme.primaryColor,
  textColor: Colors.white,
  width: double.infinity,
  height: 56,
  borderRadius: BorderRadius.circular(12),
)
```

**SecondaryButton (Outlined)**:
```dart
SecondaryButton(
  text: 'Cancel',
  onPressed: () => Navigator.pop(context),
  isLoading: false,
  borderColor: AppTheme.primaryColor,
  textColor: AppTheme.primaryColor,
)
```

**Features**:
- ✅ Loading spinner animation
- ✅ Disabled state handling
- ✅ Customizable colors and sizes
- ✅ Full width support

---

### RoleSelectorWidget & RoleSelectionChips
**Purpose**: Visual role selection interface

**RoleSelectorWidget (Card-based)**:
```dart
RoleSelectorWidget(
  initialRole: 'Shipper',
  onRoleSelected: (role) {
    setState(() {
      selectedRole = role;
    });
  },
)
```

**RoleSelectionChips (Chip-based)**:
```dart
RoleSelectionChips(
  initialRole: null,
  onRoleSelected: (role) {
    // Handle role selection
  },
)
```

**Roles Available**:
- 🚚 Shipper - Send shipments
- 🚗 Carrier - Deliver shipments
- 👨‍💼 Admin - Manage platform

---

## 📱 Authentication Screens

### LoginScreen
**Usage**:
```dart
routes: {
  AppRoutes.login: (context) => const LoginScreen(),
}
```

**Features**:
- Email/password fields
- Forgot password link
- Social login buttons
- Sign-up navigation

---

### SignupScreen
**Usage**:
```dart
routes: {
  AppRoutes.register: (context) => const SignupScreen(),
}
```

**Features**:
- Email, phone, password fields
- Password confirmation
- Role selection via RoleSelectorWidget
- Terms & conditions checkbox

---

### RoleSelectionScreen
**Usage**:
```dart
routes: {
  AppRoutes.roleSelection: (context) => const RoleSelectionScreen(),
}
```

**Features**:
- Standalone role selection
- Navigate to role-specific dashboard

---

## 📦 Shipper Components

### ShipperBookingForm
**Purpose**: Complete booking creation form

**Usage**:
```dart
ShipperBookingForm(
  onBookingSubmit: (bookingData) {
    // bookingData contains all form values
    Map<String, dynamic> data = {
      'cargoType': 'Electronics',
      'pickupLocation': '123 Main St',
      'deliveryLocation': '456 Oak Ave',
      'distance': 5.2,
      'weight': 2.5,
      'description': 'Laptop shipment',
      'estimatedValue': 1500.0,
      'isFragile': true,
      'requiresSignature': true,
    };
    
    // Send to backend
    ApiService.createBooking(data);
  },
)
```

**Form Fields**:
- Cargo Type (dropdown)
- Pickup Location (with map picker)
- Delivery Location (with map picker)
- Distance (km)
- Weight (kg)
- Description (optional)
- Estimated Value ($)
- Fragile checkbox
- Signature required checkbox

**Validation**:
- All fields required except description
- Distance > 0
- Weight > 0
- Estimated value ≥ 0

---

### CreateBookingScreen
**Usage**:
```dart
routes: {
  AppRoutes.createBooking: (context) => const CreateBookingScreen(),
}
```

**Contains**: ShipperBookingForm with AppBar and padding

---

## 🚚 Carrier Components

### NearbyRequestCard
**Purpose**: Display individual delivery request

**Usage**:
```dart
NearbyRequestCard(
  bookingId: 'BK001234',
  pickupLocation: '123 Main St, Downtown',
  deliveryLocation: '456 Oak Ave, Midtown',
  cargoType: 'Documents',
  distance: 5.2,
  estimatedPay: 25.50,
  minutesAgo: 3,
  onViewDetails: () {
    // Navigate to booking details
    Navigator.pushNamed(context, '/booking/details');
  },
  onAccept: () {
    // Accept the booking
    CarrierService.acceptBooking(bookingId);
  },
)
```

**Displays**:
- Booking ID and post time
- Cargo type badge
- Pickup/delivery locations
- Distance and estimated payment
- Action buttons

---

### CarrierDashboardScreen
**Usage**:
```dart
routes: {
  AppRoutes.carrierDashboard: (context) => const CarrierDashboardScreen(),
}
```

**Features**:
- Today's earnings summary
- Request filtering (Nearby/All/Saved)
- List of NearbyRequestCard components
- Vehicle management FAB
- Notifications icon

**Mock Data**: 4 sample requests included

---

## 👨‍💼 Admin Components

### AnalyticsCard
**Purpose**: Display key metrics

**Usage**:
```dart
AnalyticsCard(
  title: 'Total Users',
  value: '1,245',
  subtitle: '156 new this month',
  icon: Icons.people_outline,
  backgroundColor: Color(0xFF2196F3).withOpacity(0.2),
  iconColor: Color(0xFF2196F3),
  changePercent: '12',
  isPositiveChange: true,
)
```

**Customizable**:
- Title, value, subtitle text
- Icon and background color
- Optional change percentage
- Positive/negative indicators

---

### UserManagementCard
**Purpose**: Display and manage user information

**Usage**:
```dart
UserManagementCard(
  name: 'John Smith',
  email: 'john@example.com',
  role: 'Shipper',
  status: 'Active',
  joinDate: 'Jan 15, 2025',
  onTap: () {
    // Navigate to user details
  },
  onSuspend: () {
    // Suspend user account
    AdminService.suspendUser(userId);
  },
)
```

**Status Options**:
- Active (Green)
- Suspended (Red)
- Pending (Amber)

---

### AdminDashboardScreen
**Usage**:
```dart
routes: {
  AppRoutes.adminDashboard: (context) => const AdminDashboardScreen(),
}
```

**Tabs**:
1. **Overview**
   - 4 AnalyticsCard metrics
   - Booking statistics

2. **Users**
   - User management cards
   - Suspend user actions

3. **Disputes**
   - Dispute summary
   - Link to disputes page

4. **Reports**
   - Reports generation
   - Link to reports page

---

## 🎨 Theming

### Using AppTheme
```dart
import 'config/app_theme.dart';

// Colors
AppTheme.primaryColor      // #2E7D32
AppTheme.accentColor       // #FF9800
AppTheme.backgroundColor   // #FAFAFA
AppTheme.textColor         // #212121
AppTheme.lightGray         // #ECECEC
AppTheme.errorColor        // #D32F2F
AppTheme.successColor      // #4CAF50
AppTheme.warningColor      // #FBC02D

// Status colors
AppTheme.pendingColor      // Amber
AppTheme.acceptedColor     // Blue
AppTheme.inTransitColor    // Purple
AppTheme.deliveredColor    // Green
AppTheme.cancelledColor    // Red

// Theme data
ThemeData theme = AppTheme.lightTheme;
```

---

## 🔄 Common Patterns

### Form with Validation
```dart
class MyForm extends StatefulWidget {
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          EmailInputField(
            controller: _emailController,
          ),
          CustomButton(
            text: 'Submit',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Submit form
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
```

### List of Cards
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    final item = items[index];
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: NearbyRequestCard(
        bookingId: item['id'],
        pickupLocation: item['pickup'],
        // ... other props
      ),
    );
  },
)
```

### Tab Navigation
```dart
String _selectedTab = 'Overview';
final List<String> _tabs = ['Overview', 'Users', 'Disputes'];

// In UI
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: _tabs.map((tab) => GestureDetector(
      onTap: () => setState(() => _selectedTab = tab),
      child: Container(
        // Styling
        child: Text(tab),
      ),
    )).toList(),
  ),
)

// Conditional content
if (_selectedTab == 'Overview') {
  // Overview content
} else if (_selectedTab == 'Users') {
  // Users content
}
```

---

## 🧪 Testing Widgets

### Widget Test Example
```dart
testWidgets('LoginScreen renders correctly', (WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(
    home: LoginScreen(),
  ));

  expect(find.byType(EmailInputField), findsOneWidget);
  expect(find.byType(PasswordInputField), findsOneWidget);
  expect(find.byType(CustomButton), findsOneWidget);
});

testWidgets('Form validation works', (WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(
    home: LoginScreen(),
  ));

  // Find and interact with widgets
  await tester.tap(find.byType(CustomButton));
  await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

  // Verify validation messages
  expect(find.text('Email is required'), findsWidgets);
});
```

---

## 📊 Component Tree

```
MaterialApp
├── LoginScreen
│   ├── EmailInputField
│   ├── PasswordInputField
│   ├── CustomButton
│   └── SecondaryButton
│
├── SignupScreen
│   ├── EmailInputField
│   ├── PasswordInputField (x2)
│   ├── TextFormField (Phone)
│   ├── Checkbox (Terms)
│   ├── RoleSelectorWidget
│   └── CustomButton
│
├── RoleSelectionScreen
│   ├── RoleSelectorWidget
│   └── CustomButton
│
├── CreateBookingScreen
│   └── ShipperBookingForm
│       ├── DropdownButtonFormField (Cargo Type)
│       ├── TextFormField (x6)
│       ├── CheckboxListTile (x2)
│       └── ElevatedButton
│
├── CarrierDashboardScreen
│   ├── Gradient Container (Earnings)
│   ├── Filter Chips
│   └── ListView(NearbyRequestCard)
│
└── AdminDashboardScreen
    ├── Tab Navigation
    ├── GridView(AnalyticsCard)
    └── ListView(UserManagementCard)
```

---

## ✅ Checklist for Integration

- [ ] Import all necessary files in pubspec.yaml
- [ ] Copy widgets to lib/features/*/presentation/
- [ ] Update app_routes.dart with new routes
- [ ] Test each screen individually
- [ ] Connect form submissions to backend APIs
- [ ] Integrate state management (Riverpod)
- [ ] Add loading states and error handling
- [ ] Implement navigation between screens
- [ ] Add push notifications for dashboard updates
- [ ] Set up real-time data updates

---

## 🚨 Common Issues & Solutions

### Issue: Widget not found
**Solution**: Ensure correct import path
```dart
import 'lib/features/auth/presentation/widgets/email_input_field.dart';
```

### Issue: Form validation not working
**Solution**: Wrap in Form widget and validate before submit
```dart
if (_formKey.currentState!.validate()) {
  // Process form
}
```

### Issue: TextField focus not working
**Solution**: Ensure TextEditingController is disposed
```dart
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

### Issue: Layout overflow
**Solution**: Wrap content in SingleChildScrollView
```dart
SingleChildScrollView(
  child: Column(...),
)
```

---

## 📞 Support

For issues or questions:
1. Check FLUTTER_UI_COMPONENTS.md for detailed component docs
2. Review example implementations in dashboard screens
3. Check AppTheme for color and styling references
4. Refer to Material Design 3 guidelines

---

*Flutter Widgets Integration Guide - CargoLink Logistics*  
*Last Updated: January 12, 2026*
