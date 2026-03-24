import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/core/injections/injection_container.dart' as di;
import 'package:frontend_otis/presentation/bloc/notification/notification_bloc.dart';
import 'package:frontend_otis/presentation/bloc/notification/notification_state.dart';
import 'package:frontend_otis/presentation/widgets/header_bar.dart';
import 'package:frontend_otis/presentation/screens/admin/admin_profile_screen.dart';

class AdminHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  const AdminHeader({
    super.key,
    this.title = 'Otis Admin',
    this.showBack = false,
    this.onBack,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return HeaderBar(
      title: title,
      showBack: showBack,
      onBack: onBack,
      actions:
          actions ??
          [
            BlocProvider.value(
              value: di.sl<NotificationBloc>(),
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  final unreadCount = state is NotificationLoaded
                      ? state.notifications.where((n) => !n.isRead).length
                      : 0;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        onPressed: () => context.push('/admin/notifications'),
                        icon: const Icon(Icons.notifications_outlined),
                        color: Colors
                            .black, // <-- THÊM DÒNG NÀY: Thay Colors.black bằng màu nổi bật trên nền của bạn
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              unreadCount > 99 ? '99+' : unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.yellow,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AdminProfileScreen(),
                  ),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuD8YWidUUkqIitQsKH0Xj1BREkpvbhijdepzuqA_Da7KY6sVqLLfwQgwKUF9ajSgmIMnTK0j4b0lW5CkUPGvtwFsjNt2kHd8yr7_dEwL5bx51eY3jU3_u31A2YSvWEFA00LNez6c73az5gA1bCFT0EEn4VjFiJVlHZn88Ebl-X_XiKkoFtdil-UCs5KFqAl7wEnKq8OLGx60Cizj1NUiG97bPDbHHbp5LaKFDQzgFSHOcwQW9yHMP5fpRLrvtR7YpdR7Wd2dLwd7G4',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
