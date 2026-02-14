import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../element_builder.dart';
import '../models/element_model.dart';
import '../models/section_model.dart';
import '../notifiers/edit_mode_notifier.dart';
import '../notifiers/section_provider.dart';
import 'edit_attributes_screen.dart';
import 'element_selection_screen.dart';
import '../services/auth_service.dart';

class PageScreen extends StatefulWidget {
  const PageScreen({super.key});

  @override
  State<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  final List<ElementItem> _items = [];
  String? _userName;
  List<String> _userGroups = []; // Mock user groups

  @override
  void initState() {
    super.initState();
    _loadData();
    _getUserName();
    _getUserGroups();
  }

  void _loadData() {
    // TODO: load data from database
    setState(() {});
  }

  void _getUserName() {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      setState(() {
        _userName = user.displayName;
      });
    }
  }

  void _getUserGroups() {
    setState(() {
      _userGroups = ['friends', 'family', 'public'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final editModeNotifier = Provider.of<EditModeNotifier>(context);
    final sectionProvider = Provider.of<SectionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_userName ?? 'My Page'),
        actions: [
          IconButton(
            icon: Icon(editModeNotifier.isEditMode ? Icons.done : Icons.edit),
            onPressed: () {
              editModeNotifier.toggleEditMode();
            },
          ),
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight *
                2, // TODO: dynamically make the page scrollable
            child: Stack(
              children: [
                for (var item in _items.where(
                    (item) => _isItemVisible(item, sectionProvider.sections)))
                  Positioned(
                    left: item.position.dx * constraints.maxWidth,
                    top: item.position.dy * constraints.maxHeight * 2,
                    width: item.size.width * constraints.maxWidth,
                    height: item.size.height * constraints.maxHeight * 2,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        if (editModeNotifier.isEditMode) {
                          setState(() {
                            final newDx = item.position.dx +
                                details.delta.dx / constraints.maxWidth;
                            final newDy = item.position.dy +
                                details.delta.dy / (constraints.maxHeight * 2);
                            item.position = Offset(newDx, newDy);
                          });
                        }
                      },
                      onTap: () {
                        if (editModeNotifier.isEditMode) {
                          _showEditMenu(item, sectionProvider.sections);
                        }
                      },
                      child: buildElementItem(item),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: editModeNotifier.isEditMode
          ? FloatingActionButton(
              onPressed: _addNewItem,
              tooltip: 'Add new item',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  bool _isItemVisible(ElementItem item, List<Section> sections) {
    if (sections.isEmpty) return false;
    final section = sections.firstWhere((s) => s.id == item.sectionId,
        orElse: () => sections.first);
    if (section.visibleToGroupIds.isEmpty) {
      return true; // Public section
    }
    return section.visibleToGroupIds
        .any((groupId) => _userGroups.contains(groupId));
  }

  void _showEditMenu(ElementItem item, List<Section> sections) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit_note),
              title: const Text('Edit Content'),
              onTap: () async {
                Navigator.pop(context);
                final updatedItem = await Navigator.push<ElementItem>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditAttributesScreen(item: item),
                  ),
                );
                if (updatedItem != null) {
                  setState(() {
                    final index = _items.indexWhere((i) => i.id == item.id);
                    if (index != -1) {
                      _items[index] = updatedItem;
                    }
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Change Section'),
              onTap: () async {
                Navigator.pop(context);
                final selectedSection =
                    await _showSectionSelectionDialog(item.sectionId, sections);
                if (selectedSection != null) {
                  setState(() {
                    item.sectionId = selectedSection.id;
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                setState(() {
                  _items.remove(item);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<Section?> _showSectionSelectionDialog(
      String currentSectionId, List<Section> sections) {
    return showDialog<Section>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Section'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                return ListTile(
                  title: Text(section.name),
                  onTap: () {
                    Navigator.pop(context, section);
                  },
                  trailing: section.id == currentSectionId
                      ? const Icon(Icons.check)
                      : null,
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _addNewItem() async {
    final selectedType = await showModalBottomSheet<ElementItemType>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return ElementSelectionScreen(scrollController: scrollController);
          },
        );
      },
    );

    if (selectedType != null) {
      final sectionProvider =
          Provider.of<SectionProvider>(context, listen: false);
      if (sectionProvider.sections.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please create a section first.')));
        return;
      }
      final selectedSection = await _showSectionSelectionDialog(
          sectionProvider.sections.first.id, sectionProvider.sections);
      if (selectedSection != null) {
        final random = Random();
        final newItem = ElementItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: selectedType,
          position:
              Offset(random.nextDouble() * 0.7, random.nextDouble() * 0.7),
          size: const Size(0.2, 0.2),
          sectionId: selectedSection.id,
          content: selectedType == ElementItemType.text ? 'New Text' : null,
        );
        setState(() {
          _items.add(newItem);
        });
      }
    }
  }

  Widget buildElementItem(ElementItem item) {
    return ElementBuilder.build(context, item);
  }
}
