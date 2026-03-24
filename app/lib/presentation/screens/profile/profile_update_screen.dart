import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/presentation/bloc/auth/auth_bloc.dart';
import 'package:frontend_otis/presentation/bloc/auth/auth_event.dart';
import 'package:frontend_otis/presentation/bloc/auth/auth_state.dart';
import 'package:frontend_otis/core/injections/injection_container.dart';
import 'package:frontend_otis/domain/usecases/profile/update_user_profile_usecase.dart';
import 'package:frontend_otis/domain/usecases/profile/get_user_by_id_usecase.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthBloc>().state;
    if (state is Authenticated) {
      _nameController.text = state.user.fullName;
      _phoneController.text = state.user.phone;
      _addressController.text = state.user.address;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật thông tin'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Họ và tên'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Địa chỉ'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final fullName = _nameController.text.trim();
                final address = _addressController.text.trim();
                final phone = _phoneController.text.trim();

                int userId = 2; // demo default
                final state = context.read<AuthBloc>().state;
                if (state is Authenticated) {
                  final parsed = int.tryParse(state.user.id.toString());
                  if (parsed != null) userId = parsed;
                }

                try {
                  // 2) Update DB via UseCase
                  final affectedResult = await sl<UpdateUserProfileUseCase>()(
                    userId: userId,
                    fullName: fullName,
                    address: address,
                    phone: phone,
                  );
                  final affected = affectedResult.getOrElse(() => 0);

                  // 3) Query lại DB để kiểm tra
                  final userResult = await sl<GetUserByIdUseCase>()(userId);
                  final user = userResult.fold((_) => null, (u) => u);

                  if (!mounted) return;

                  if (affected == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Update FAILED (affected=0). userId=$userId')),
                    );
                    return;
                  }

                  // 5) Set lại controller từ Entity
                  if (user != null) {
                    _nameController.text = user.fullName;
                    _addressController.text = user.address;
                    _phoneController.text = user.phone;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Updated OK! affected=$affected userId=$userId')),
                  );
                  
                  final authState = context.read<AuthBloc>().state;
                  if (authState is Authenticated && user != null) {
                    context.read<AuthBloc>().add(AuthUserUpdated(user));
                  }
                  
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('ERROR: $e')),
                    );
                  }
                }
              },
              child: const Text('Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }
}
