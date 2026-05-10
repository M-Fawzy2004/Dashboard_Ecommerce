import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/utils/app_snack_bar.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          }
          if (state is AuthError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        child: Row(
          children: [
            // ─── Left Branding ───────────────────────────────────
            Expanded(
              flex: 4,
              child: Container(
                color: const Color(0xFF0A0A0F),
                child: Stack(
                  children: [
                    // Geometric background accents
                    Positioned(
                      top: -60,
                      left: -60,
                      child: _GeometricSquare(size: 280.r, opacity: 0.06),
                    ),
                    Positioned(
                      bottom: -40,
                      right: -40,
                      child: _GeometricSquare(size: 200.r, opacity: 0.06),
                    ),
                    // Brand content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 56.r,
                            height: 56.r,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.15),
                              ),
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Icon(
                              Icons.shopping_bag_rounded,
                              size: 26.r,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            'DEALPORT',
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 6,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'PREMIUM E-COMMERCE',
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: Colors.white.withOpacity(0.35),
                              letterSpacing: 3,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── Right Form ──────────────────────────────────────
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 52.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DASHBOARD ACCESS',
                        style: TextStyle(
                          fontSize: 10.sp,
                          letterSpacing: 3,
                          color: const Color(0xFFB4B2A9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Welcome back.',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0A0A0F),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Sign in to your account to continue',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF888780),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 36.h),
                      _buildLabel('Email Address'),
                      _buildTextField(_emailController, 'you@example.com'),
                      SizedBox(height: 20.h),
                      _buildLabel('Password'),
                      _buildTextField(
                        _passwordController,
                        '••••••••••',
                        isPassword: true,
                      ),
                      SizedBox(height: 20.h),
                      _buildSignInButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11.sp,
        letterSpacing: 1.5,
        color: const Color(0xFF5F5E5A),
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool isPassword = false,
  }) => TextFormField(
    controller: controller,
    obscureText: isPassword,
    style: TextStyle(color: const Color(0xFF2C2C2A), fontSize: 14.sp),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: const Color(0xFFB4B2A9)),
      filled: true,
      fillColor: const Color(0xFFF1EFE8),
      contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(16.r),
      ),
    ),
    validator: (v) => v!.isEmpty ? 'Required' : null,
  );

  Widget _buildSignInButton() => BlocBuilder<AuthCubit, AuthState>(
    builder: (context, state) {
      final isLoading = state is AuthLoading;
      return SizedBox(
        width: double.infinity,
        height: 70.h,
        child: ElevatedButton(
          onPressed: isLoading
              ? null
              : () {
                  if (_formKey.currentState!.validate()) {
                    context.read<AuthCubit>().login(
                      _emailController.text,
                      _passwordController.text,
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A0A0F),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'SIGNING IN...',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'SIGN IN',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.5,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Container(
                      width: 45.r,
                      height: 45.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20.r,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      );
    },
  );
}

// ─── Helper Widgets ─────────────────────────────────────────────────────────

class _GeometricSquare extends StatelessWidget {
  final double size;
  final double opacity;
  const _GeometricSquare({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(opacity)),
        borderRadius: BorderRadius.circular(40),
      ),
    );
  }
}
