import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/universal_back_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../../navigation/app_routes.dart';
import '../providers/ticket_provider.dart';

class CreateTicketScreen extends ConsumerStatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  ConsumerState<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends ConsumerState<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _attachmentSource = 'Kamera';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final requester = ref.read(authStateProvider).user?.name ?? 'User';
    final ticket = ref
        .read(ticketStateProvider.notifier)
        .createTicket(
          title: _titleController.text,
          description: _descriptionController.text,
          requester: requester,
          attachmentSource: _attachmentSource,
        );

    ref
        .read(notificationStateProvider.notifier)
        .add(
          title: 'Ticket baru dibuat',
          body: '#${ticket.id} ${ticket.title}',
          route: AppRoutes.ticketDetailPath(ticket.id),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ticket #${ticket.id} berhasil dibuat.')),
    );
    context.pushReplacement(AppRoutes.ticketDetailPath(ticket.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const UniversalBackButton(),
        title: const Text('Buat Ticket'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Ticket',
                hintText: 'Contoh: Akses email bermasalah',
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) {
                  return 'Judul ticket wajib diisi.';
                }
                if (text.length < 6) {
                  return 'Judul ticket minimal 6 karakter.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                hintText: 'Jelaskan kendala secara detail',
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) {
                  return 'Deskripsi wajib diisi.';
                }
                if (text.length < 12) {
                  return 'Deskripsi minimal 12 karakter.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.camera_alt_outlined),
                      title: Text('Lampiran gambar'),
                      subtitle: Text('Pilih sumber: kamera atau galeri.'),
                    ),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('Kamera'),
                          selected: _attachmentSource == 'Kamera',
                          onSelected: (_) {
                            setState(() => _attachmentSource = 'Kamera');
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Galeri'),
                          selected: _attachmentSource == 'Galeri',
                          onSelected: (_) {
                            setState(() => _attachmentSource = 'Galeri');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _submit, child: const Text('Kirim Ticket')),
          ],
        ),
      ),
    );
  }
}
