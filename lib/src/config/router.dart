import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/auth_repository.dart';
import '../features/authentication/auth_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/calls/call_details/call_details_screen.dart';
import '../features/contacts_crm/contact_details/contact_details_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  
  return GoRouter(
    initialLocation: '/',    redirect: (context, state) {
      // Check if user is logged in
      final isLoggedIn = authState.asData?.value != null;
      final isOnLoginPage = state.matchedLocation == '/login';
      
      // If not logged in and not on login page, redirect to login
      if (!isLoggedIn && !isOnLoginPage) {
        return '/login';
      }
      
      // If logged in and on login page, redirect to home
      if (isLoggedIn && isOnLoginPage) {
        return '/';
      }
      
      // No redirect needed
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const AuthScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
        routes: [
          GoRoute(
            path: 'call-details/:callSid',
            name: 'call-details',
            pageBuilder: (context, state) {
              final callSid = state.pathParameters['callSid']!;
              return CustomTransitionPage<void>(
                key: state.pageKey,
                child: CallDetailsScreen(callSid: callSid),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(CurveTween(curve: Curves.easeInOut).animate(animation)),
                    child: child,
                  );
                },
              );
            },
          ),
          GoRoute(
            path: 'contact-details/:contactId',
            name: 'contact-details',
            pageBuilder: (context, state) {
              final contactId = state.pathParameters['contactId']!;
              return CustomTransitionPage<void>(
                key: state.pageKey,
                child: ContactDetailsScreen(contactId: contactId),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(CurveTween(curve: Curves.easeInOut).animate(animation)),
                    child: child,
                  );
                },
              );
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
