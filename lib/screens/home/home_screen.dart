import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../data/notifications_data.dart';
import '../../models/app_notification.dart';
import '../../services/auth_service.dart';
import '../../services/blood_service.dart';
import '../../services/donor_service.dart';
import '../../widgets/blood_bank_card.dart';
import '../../widgets/hospital_card.dart';
import '../../widgets/requirement_card.dart';
import '../../widgets/section_header.dart';
import '../blood_banks/blood_bank_detail_screen.dart';
import '../blood_banks/blood_banks_screen.dart';
import '../camps/camps_screen.dart';
import '../donate/book_slot_screen.dart';
import '../hospitals/hospital_detail_screen.dart';
import '../hospitals/hospitals_screen.dart';
import '../notifications/notifications_screen.dart';
import '../requirements/requirements_screen.dart';

/// Home dashboard: user info, emergency requirements, nearby hospitals
/// and blood banks, and the latest notifications.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Rebuild when auth state changes (login/logout/profile edit)
    // and when donor state changes (bookings, camps, notifications).
    AuthService.instance.addListener(_refresh);
    DonorService.instance.addListener(_refresh);
  }

  @override
  void dispose() {
    AuthService.instance.removeListener(_refresh);
    DonorService.instance.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final bloodService = BloodService.instance;
    final donorNotifs = AuthService.instance.isLoggedIn
        ? DonorService.instance.donorNotifications()
        : const <AppNotification>[];
    final allNotifications = [...donorNotifs, ...kNotifications];
    final unreadCount = allNotifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RaktaSetu'),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            ),
            icon: Badge(
              isLabelVisible: unreadCount > 0,
              label: Text('$unreadCount'),
              backgroundColor: Colors.white,
              textStyle: const TextStyle(
                color: AppTheme.red,
                fontSize: 9,
                fontWeight: FontWeight.w900,
              ),
              child: const Icon(Icons.notifications_outlined),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // ---- User greeting card (name + blood group) ----
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.red, AppTheme.redDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white,
                  child: Text(
                    user?.initials ?? 'R',
                    style: const TextStyle(
                      color: AppTheme.red,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${user?.fullName.split(' ').first ?? 'Guest'} 👋',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user != null
                            ? '${user.bloodGroup} · ${user.area}'
                            : 'Log in to personalise your dashboard',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ---- Quick donor actions (Phase 2) ----
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _quickAction(
                    context,
                    icon: Icons.event_available,
                    label: 'Book a slot',
                    onTap: () => _push(context, const BookSlotScreen()),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _quickAction(
                    context,
                    icon: Icons.campaign_outlined,
                    label: 'Donation camps',
                    onTap: () => _push(context, const CampsScreen()),
                  ),
                ),
              ],
            ),
          ),

          // ---- Emergency blood requirements ----
          SectionHeader(
            title: '🚨 Emergency Requirements',
            onSeeAll: () => _push(context, const RequirementsScreen()),
          ),
          for (final r in bloodService.requirements().take(3))
            RequirementCard(requirement: r),

          // ---- Nearby hospitals ----
          SectionHeader(
            title: '🏥 Nearby Hospitals',
            onSeeAll: () => _push(context, const HospitalsScreen()),
          ),
          for (final h in bloodService.topHospitals(limit: 3))
            HospitalCard(
              hospital: h,
              onTap: () => _push(
                context,
                HospitalDetailScreen(hospital: h),
              ),
            ),

          // ---- Nearby blood banks ----
          SectionHeader(
            title: '🩸 Nearby Blood Banks',
            onSeeAll: () => _push(context, const BloodBanksScreen()),
          ),
          for (final b in bloodService.bloodBanks.take(3))
            BloodBankCard(
              bloodBank: b,
              onTap: () => _push(
                context,
                BloodBankDetailScreen(bloodBank: b),
              ),
            ),

          // ---- Latest notifications ----
          SectionHeader(
            title: '🔔 Latest Notifications',
            onSeeAll: () => _push(context, const NotificationsScreen()),
          ),
          for (final n in allNotifications.take(3))
            _NotificationTile(notification: n),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Widget _quickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Icon(icon, color: AppTheme.red, size: 26),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact notification row used in the home preview.
class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Text(
          notification.category.emoji,
          style: const TextStyle(fontSize: 22),
        ),
        title: Text(
          notification.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
        ),
        subtitle: Text(
          notification.body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, color: AppTheme.textGrey),
        ),
        trailing: Text(
          notification.timeAgo,
          style: const TextStyle(fontSize: 10.5, color: AppTheme.textGrey),
        ),
      ),
    );
  }
}
