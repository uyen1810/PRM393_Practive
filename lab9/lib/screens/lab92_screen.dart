import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class Lab92Screen extends StatefulWidget {
  const Lab92Screen({super.key});

  @override
  State<Lab92Screen> createState() => _Lab92ScreenState();
}

class _Lab92ScreenState extends State<Lab92Screen> {
  final StorageService _storageService = StorageService();
  final String _fileName = 'lab92_data.json';

  List<Map<String, dynamic>> _items = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    try {
      final data = await _storageService.readJsonFile(_fileName);
      setState(() => _items = data);
    } catch (e) {
      debugPrint('Lỗi đọc file: $e');
    }
  }

  void _addItemToList() {
    if (_nameController.text.trim().isEmpty) return;
    setState(() {
      _items.add({
        'id': _items.isEmpty ? 1 : (_items.last['id'] as int) + 1,
        'name': _nameController.text.trim(),
        'role': _roleController.text.trim().isEmpty
            ? 'Member'
            : _roleController.text.trim(),
      });
      _nameController.clear();
      _roleController.clear();
    });
  }

  Future<void> _saveToFile() async {
    try {
      await _storageService.writeJsonFile(_fileName, _items);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã lưu dữ liệu vào bộ nhớ thiết bị thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi lưu: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.2 - Save & Load Storage'),
        actions: [
          ElevatedButton.icon(
            onPressed: _saveToFile,
            icon: const Icon(Icons.save),
            label: const Text('Save JSON'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên (Name)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _roleController,
                  decoration: const InputDecoration(
                    labelText: 'Vai trò (Role)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _items.isEmpty
                ? const Center(child: Text('Chưa có dữ liệu. Hãy thêm mới và bấm Save!'))
                : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${item['id']}')),
                  title: Text(item['name']),
                  subtitle: Text('Role: ${item['role']}'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItemToList,
        tooltip: 'Thêm vào danh sách',
        child: const Icon(Icons.add),
      ),
    );
  }
}