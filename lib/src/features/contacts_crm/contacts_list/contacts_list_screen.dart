import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../config/app_theme.dart';

class ContactsListScreen extends ConsumerWidget {
  const ContactsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: FadeInUp(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.contacts,
                size: 80,
                color: AppTheme.primaryColor.withOpacity(0.3),
              ),
              const SizedBox(height: 24),
              Text(
                'Contacts',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Contact management coming soon!',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.subtleTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Contact features are being developed'),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
