import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/app/routes/channel_route.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_mattermost/app/routes/auth_routes.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 900;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Flex(
                  direction: isCompact ? Axis.vertical : Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: isCompact
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    if (!isCompact)
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 64),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mattermost',
                                style: theme.textTheme.displayMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.02,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'All your team communication, search, and collaboration in one place.',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white70,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Text(
                          'Mattermost',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    Container(
                      width: isCompact ? 500 : 500,
                      constraints: const BoxConstraints(maxWidth: 500),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: const Color(0xFF181825),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 16,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is AuthenticatedState) {
                            // بعد نجاح تسجيل الدخول انتقل إلى الصفحة الرئيسية.
                            context.go(ChatRoutes.home);
                          } else if (state is AuthFailureState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          final isLoading = state is AuthLoadingState;

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    color: Colors.blueAccent,
                                    size: 28,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Mattermost Desktop',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Sign in to your server',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: _usernameController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Username or Email',
                                  hintStyle: const TextStyle(
                                    color: Colors.white38,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFF313244),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: const TextStyle(
                                    color: Colors.white38,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFF313244),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () =>
                                      context.push(AuthRoutes.resetPassword),
                                  child: const Text('Forgot your password?'),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 44,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          final username = _usernameController
                                              .text
                                              .trim();
                                          final password = _passwordController
                                              .text
                                              .trim();
                                          if (username.isNotEmpty &&
                                              password.isNotEmpty) {
                                            context.read<AuthBloc>().add(
                                              LoginSubmittedEvent(
                                                username: username,
                                                password: password,
                                              ),
                                            );
                                          }
                                        },
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Log In',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Align(
                                alignment: Alignment.center,
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 8,
                                  children: const [
                                    Text(
                                      "Don't have an account?",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () => context.push(
                                    AuthRoutes.signupUserComplete,
                                  ),
                                  child: const Text('Create one'),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
