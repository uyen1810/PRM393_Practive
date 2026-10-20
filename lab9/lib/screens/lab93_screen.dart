import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class Lab93Screen extends StatefulWidget {
  const Lab93Screen({super.key});

  @override
  State<Lab93Screen> createState() => _Lab93ScreenState();
}

class _Lab93ScreenState extends State<Lab93Screen> {
  final StorageService _storageService = StorageService();
  final String _fileName = 'lab93_crud_db.json';

  List<Map<String, dynamic>> _allItems = [];
  List<Map<String, dynamic>> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDatabase();
  }

  Future<void> _loadDatabase() async {
    try {
      final data = await _storageService.readJsonFile(_fileName);
      setState(() {
        _allItems = data;
        _filterItems(_searchController.text);
      });
    } catch (e) {
      debugPrint('Lỗi load DB: $e');
    }
  }

  Future<void> _autoSaveDatabase(String actionMessage) async {
    await _storageService.writeJsonFile(_fileName, _allItems);
    _filterItems(_searchController.text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(actionMessage),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _filterItems(String keyword) {
    setState(() {
      if (keyword.trim().isEmpty) {
        _filteredItems = List.from(_allItems);
      } else {
        final lowerKeyword = keyword.toLowerCase();
        _filteredItems = _allItems.where((item) {
          final name = (item['name'] ?? '').toString().toLowerCase();
          final desc = (item['description'] ?? '').toString().toLowerCase();
          return name.contains(lowerKeyword) || desc.contains(lowerKeyword);
        }).toList();
      }
    });
  }

  int _generateNextId() {
    if (_allItems.isEmpty) return 1;
    final maxId = _allItems.map((e) => e['id'] as int).reduce((a, b) => a > b ? a : b);
    return maxId + 1;
  }

  void _showAddOrEditDialog({Map<String, dynamic>? existingItem}) {
    final isEditing = existingItem != null;
    final nameCtrl = TextEditingController(text: isEditing ? existingItem['name'] : '');
    final descCtrl = TextEditingController(text: isEditing ? existingItem['description'] : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Chỉnh sửa mục #${existingItem['id']}' : 'Thêm mục mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Tên sản phẩm / công việc'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Mô tả chi tiết'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;

              if (isEditing) {
                final index = _allItems.indexWhere((e) => e['id'] == existingItem['id']);
                if (index != -1) {
                  _allItems[index]['name'] = nameCtrl.text.trim();
                  _allItems[index]['description'] = descCtrl.text.trim();
                }
                _autoSaveDatabase('Đã cập nhật và tự động lưu!');
              } else {
                _allItems.add({
                  'id': _generateNextId(),
                  'name': nameCtrl.text.trim(),
                  'description': descCtrl.text.trim(),
                });
                _autoSaveDatabase('Đã thêm mới và tự động lưu!');
              }
              Navigator.pop(context);
            },
            child: Text(isEditing ? 'Cập nhật' : 'Thêm'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa "${item['name']}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              _allItems.removeWhere((e) => e['id'] == item['id']);
              _autoSaveDatabase('Đã xóa và cập nhật file JSON!');
              Navigator.pop(context);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 9.3 - JSON CRUD & Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterItems,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm theo tên hoặc mô tả...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterItems('');
                  },
                )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadDatabase,
              child: _filteredItems.isEmpty
                  ? const Center(child: Text('Không tìm thấy dữ liệu nào.'))
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${item['id']}')),
                      title: Text(
                        item['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(item['description'] ?? ''),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showAddOrEditDialog(existingItem: item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(item),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOrEditDialog(),
        tooltip: 'Thêm mới',
        child: const Icon(Icons.add),
      ),
    );
  }
}