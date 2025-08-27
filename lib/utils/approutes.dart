import 'package:construction_app/view/admin_view/add_employee_view/addemployee.dart';
import 'package:construction_app/view/admin_view/add_site_view/add%20_site.dart';
import 'package:construction_app/view/admin_view/add_tools_view/add_tools.dart';
import 'package:construction_app/view/admin_view/admin_dashboard_view/admindashboard.dart';
import 'package:construction_app/view/admin_view/employeeDetails_view/employeelist.dart';
import 'package:construction_app/view/admin_view/sites_management_view/sitemanagement.dart';
import 'package:construction_app/view/admin_view/tools_management_view/toolmanagement.dart';
import 'package:construction_app/view/auth_view/forgot_password.dart';
import 'package:construction_app/view/employee_view/homepage_view/homepage.dart';
import 'package:construction_app/view/auth_view/new_password.dart';
import 'package:construction_app/view/auth_view/otp.dart';
import 'package:construction_app/view/splash_screen_view/splash_screen.dart';
import 'package:construction_app/view/auth_view/userlogin.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>> getpages = [
  GetPage(
    name: Approutes.splashScreen,
    page: () => const SelectRoleScreen(),
    transition: Transition.cupertino,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: Approutes.loginScreen,
    page: () => LoginScreen(),
    transition: Transition.cupertino,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: Approutes.forgotPasswordScreen,
    page: () => const ForgotPasswordScreen(),
    transition: Transition.cupertino,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: Approutes.otpVerificationScreen,
    page: () => const OtpVerificationScreen(),
    transition: Transition.cupertino,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: Approutes.newPasswordScreen,
    page: () => const NewPasswordScreen(),
    transition: Transition.cupertino,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: Approutes.employeeHomePage,
    page: () => const EmployeeHomePage(),
    transition: Transition.cupertino,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: Approutes.adminDashboardPage,
    page: () => const DashboardPage(),
    transition: Transition.cupertino,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: Approutes.adminAddEmployee,
    page: () => const AddEmployee(),
    transition: Transition.cupertino,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: Approutes.adminAddSite,
    page: () => const AddSite(),
    transition: Transition.cupertino,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: Approutes.adminAddTools,
    page: () => const AddToolPage(),
    transition: Transition.cupertino,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: Approutes.adminEmployeeDetails,
    page: () => const EmployeeManagementPage(),
    transition: Transition.cupertino,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: Approutes.adminToolsManagement,
    page: () => const ToolManagementPage(),
    transition: Transition.cupertino,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: Approutes.adminSitesManagement,
    page: () => const ViewSitesPage(),
    transition: Transition.cupertino,
    transitionDuration: const Duration(milliseconds: 200),
  ),
];

class Approutes {
  static const splashScreen = '/splashScreen';
  static const loginScreen = '/loginScreen';
  static const forgotPasswordScreen = '/forgotPasswordScreen';
  static const otpVerificationScreen = '/otpVerificationScreen';
  static const newPasswordScreen = '/newPasswordScreen';
  static const employeeHomePage = '/employeeHomePage';
  static const adminDashboardPage = '/adminDashboardPage';
  static const adminAddEmployee = '/adminAddEmployee';
  static const adminAddSite = '/adminAddSite';
  static const adminAddTools = '/adminAddTools';
  static const adminEmployeeDetails = '/adminEmployeeDetails';
  static const adminToolsManagement = '/adminToolsManagement';
  static const adminSitesManagement = '/adminSitesManagement';
}
