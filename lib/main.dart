import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/orders/presentation/pages/orders_page.dart';
import 'features/products/presentation/pages/products_page.dart';
import 'shared/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const DashboardApp(),
    ),
  );
}

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'app_title'.tr(),
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          theme: AppTheme.light,
          initialRoute: '/dashboard',
          routes: {
            '/dashboard': (_) => const DashboardPage(),
            '/orders': (_) => const OrdersPage(),
            '/products': (_) => const ProductsPage(),
          },
          home: child,
        );
      },
      child: const DashboardPage(),
    );
  }
}
