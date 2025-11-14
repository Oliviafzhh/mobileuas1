import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/announcement_provider.dart';
import '../providers/auth_provider.dart';
import '../models/announcement.dart';
import '../widgets/announcement_cart.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({Key? key}) : super(key: key);

  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final announcementProvider = Provider.of<AnnouncementProvider>(context);
    final announcements = announcementProvider.announcements;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengumuman'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (authProvider.isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _showAddAnnouncementDialog(context);
              },
            ),
        ],
      ),
      body: announcementProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : announcements.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada pengumuman',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    final announcement = announcements[index];
                    return AnnouncementCard(
                      announcement: announcement,
                      onEdit: authProvider.isAdmin
                          ? () => _showEditAnnouncementDialog(context, announcement)
                          : null,
                      onDelete: authProvider.isAdmin
                          ? () => _showDeleteConfirmation(context, announcement)
                          : null,
                    );
                  },
                ),
    );
  }

  void _showAddAnnouncementDialog(BuildContext context) {
    final _titleController = TextEditingController();
    final _contentController = TextEditingController();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Pengumuman'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Pengumuman',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Isi Pengumuman',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
                final announcementProvider = Provider.of<AnnouncementProvider>(context, listen: false);
                
                final announcement = Announcement(
                  title: _titleController.text,
                  content: _contentController.text,
                  createdAt: DateTime.now(),
                  createdBy: authProvider.userData['name'] ?? 'Administrator',
                );

                await announcementProvider.addAnnouncement(announcement);

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pengumuman berhasil ditambahkan'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showEditAnnouncementDialog(BuildContext context, Announcement announcement) {
    final _titleController = TextEditingController(text: announcement.title);
    final _contentController = TextEditingController(text: announcement.content);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Pengumuman'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Pengumuman',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Isi Pengumuman',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
                final announcementProvider = Provider.of<AnnouncementProvider>(context, listen: false);
                
                final updatedAnnouncement = Announcement(
                  id: announcement.id,
                  title: _titleController.text,
                  content: _contentController.text,
                  createdAt: announcement.createdAt,
                  createdBy: announcement.createdBy,
                );

                await announcementProvider.updateAnnouncement(announcement.id!, updatedAnnouncement);

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pengumuman berhasil diupdate'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Announcement announcement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pengumuman'),
        content: Text('Yakin ingin menghapus pengumuman "${announcement.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final announcementProvider = Provider.of<AnnouncementProvider>(context, listen: false);
              await announcementProvider.deleteAnnouncement(announcement.id!);
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pengumuman berhasil dihapus'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}