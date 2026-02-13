import 'package:flutter/material.dart';
import 'package:frontend_otis/presentation/widgets/header_bar.dart';
import 'package:frontend_otis/presentation/screens/admin/admin_profile_screen.dart';

class AdminHeader extends StatelessWidget implements PreferredSizeWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return HeaderBar(
      title: 'Otis Admin',
      showBack: false,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined),
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
