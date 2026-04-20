import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../cubit/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacementNamed('/dashboard');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              ),
            );
          }
        },
        child: Stack(
          children: [
            // Background Decorative Elements
            Positioned(
              top: -100.h,
              right: -100.w,
              child: _CircularGradient(
                size: 400.w,
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
            Positioned(
              bottom: -150.h,
              left: -100.w,
              child: _CircularGradient(
                size: 500.w,
                color: AppColors.accent.withValues(alpha: 0.1),
              ),
            ),
            
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.background,
                    AppColors.background.withValues(alpha: 0.9),
                    const Color(0xFFE8F1FF),
                  ],
                ),
              ),
              child: Row(
                children: [
                  // Left Side - Info Section (Desktop)
                  if (MediaQuery.of(context).size.width > 900)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 60.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Icon(
                                Icons.storefront_rounded,
                                color: AppColors.primary,
                                size: 48.sp,
                              ),
                            ),
                            AppSpacing.v25,
                            Text(
                              'Dealport Admin',
                              style: TextStyle(
                                fontSize: 44.sp,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                                letterSpacing: -1,
                              ),
                            ),
                            AppSpacing.v15,
                            Text(
                              'Manage your products, orders, and customers with our powerful e-commerce dashboard. Professional tools for professional sellers.',
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                            ),
                            AppSpacing.v30,
                            _FeatureItem(icon: Icons.auto_graph_rounded, text: 'Real-time Analytics & Tracking'),
                            _FeatureItem(icon: Icons.inventory_2_outlined, text: 'Advanced Inventory Management'),
                            _FeatureItem(icon: Icons.security_rounded, text: 'Enterprise Grade Security'),
                          ],
                        ),
                      ),
                    ),
                  
                  // Right Side - Login Card
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(24.r),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.r),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 480.w),
                              padding: EdgeInsets.all(40.r),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(30.r),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 40,
                                    offset: const Offset(0, 20),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Sign In',
                                            style: TextStyle(
                                              fontSize: 32.sp,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            'Access your admin portal',
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    AppSpacing.v30,
                                    
                                    _buildLabel('Email Address'),
                                    SizedBox(height: 10.h),
                                    _buildTextField(
                                      controller: _emailController,
                                      hintText: 'admin@dealport.com',
                                      icon: Icons.alternate_email_rounded,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (v) => v!.isEmpty ? 'Enter email' : null,
                                    ),
                                    AppSpacing.v20,
                                    
                                    _buildLabel('Password'),
                                    SizedBox(height: 10.h),
                                    _buildTextField(
                                      controller: _passwordController,
                                      hintText: 'Password',
                                      icon: Icons.lock_person_rounded,
                                      obscureText: _obscurePassword,
                                      suffixIcon: IconButton(
                                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                        icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20.sp),
                                      ),
                                      validator: (v) => v!.isEmpty ? 'Enter password' : null,
                                    ),
                                    
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {},
                                        child: Text('Forgot Password?', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13.sp)),
                                      ),
                                    ),
                                    AppSpacing.v20,
                                    
                                    BlocBuilder<AuthCubit, AuthState>(
                                      builder: (context, state) {
                                        final isLoading = state is AuthLoading;
                                        return SizedBox(
                                          width: double.infinity,
                                          height: 58.h,
                                          child: ElevatedButton(
                                            onPressed: isLoading ? null : _handleLogin,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primary,
                                              foregroundColor: Colors.white,
                                              elevation: 8,
                                              shadowColor: AppColors.primary.withValues(alpha: 0.4),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                                            ),
                                            child: isLoading
                                                ? SizedBox(width: 24.w, height: 24.w, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                                : Text('Login to Dashboard', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800)),
                                          ),
                                        );
                                      },
                                    ),
                                    AppSpacing.v30,
                                    Center(
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Text("Don't have an account? ", style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp)),
                                          GestureDetector(
                                            onTap: () {},
                                            child: Text('Contact Admin', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13.sp)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary.withValues(alpha: 0.8),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, size: 20.sp, color: AppColors.primary),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        hoverColor: AppColors.primary.withValues(alpha: 0.05),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: Color(0xFFEDF2F7), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
            ),
            child: Icon(icon, color: AppColors.primary, size: 16.sp),
          ),
          SizedBox(width: 14.w),
          Text(text, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _CircularGradient extends StatelessWidget {
  final double size;
  final Color color;

  const _CircularGradient({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}
