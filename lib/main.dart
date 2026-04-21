import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/supabase/supabase_config.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/categories/presentation/pages/categories_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/orders/presentation/pages/orders_page.dart';
import 'features/products/presentation/pages/add_product_page.dart';
import 'features/products/presentation/pages/products_page.dart';
import 'shared/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  
  // Initialize Supabase configuration
  await SupabaseConfig.init();

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
    return BlocProvider(
      create: (context) => AuthCubit()..checkAuth(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1100;
          
          Size designSize = const Size(1440, 1024);
          if (isMobile) {
            designSize = const Size(430, 932);
          } else if (isTablet) {
            designSize = const Size(1100, 800); // Prevents text from sizing UP on 1000px widths
          }

          return ScreenUtilInit(
            key: ValueKey(designSize),
            designSize: designSize,
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
                routes: {
                  '/login': (_) => const LoginPage(),
                  '/dashboard': (_) => const DashboardPage(),
                  '/categories': (_) => const CategoriesPage(),
                  '/orders': (_) => const OrdersPage(),
                  '/products': (_) => const ProductsPage(),
                  '/add-products': (_) => const AddProductPage(),
                },
                home: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthAuthenticated) {
                      return const DashboardPage();
                    } else if (state is AuthUnauthenticated || state is AuthError) {
                      return const LoginPage();
                    }
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
