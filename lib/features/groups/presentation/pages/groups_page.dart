import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/groups/domain/entities/group_entity.dart';
import 'package:flutter_mattermost/features/groups/domain/repositories/groups_repository.dart';

/// إدارة مجموعات Enterprise: بحث/أرشفة/استعادة + تفاصيل الأعضاء والربط.
class AdminConsoleGroupsPage extends StatefulWidget {
  const AdminConsoleGroupsPage({super.key});

  @override
  State<AdminConsoleGroupsPage> createState() => _AdminConsoleGroupsPageState();
}

class _AdminConsoleGroupsPageState extends State<AdminConsoleGroupsPage> {
  final GroupsRepository _repository = getIt<GroupsRepository>();

  List<GroupEntity> _groups = [];
  bool _loading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load({String? query}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final groups = await _repository.getGroups(
        q: query,
        perPage: 100,
        includeMemberCount: true,
      );
      if (!mounted) return;
      setState(() => _groups = groups);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _archiveGroup(GroupEntity group) async {
    try {
      await _repository.archiveGroup(group.id);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Group archived')));
      _load(query: _searchController.text);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _restoreGroup(GroupEntity group) async {
    try {
      await _repository.restoreGroup(group.id);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Group restored')));
      _load(query: _searchController.text);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showDetails(GroupEntity group) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF232335),
      builder: (context) =>
          _GroupDetailsSheet(repository: _repository, group: group),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        Expanded(
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.blueAccent),
                )
              : _error != null
              ? Center(
                  child: Text(
                    'Could not load groups: $_error',
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 13,
                    ),
                  ),
                )
              : _buildContent(context),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          const Icon(Icons.groups_outlined, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 10),
          const Text(
            'Groups',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 36,
              child: TextField(
                controller: _searchController,
                onSubmitted: (value) => _load(query: value),
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'ابحث بالاسم...',
                  hintStyle: const TextStyle(
                    color: Colors.white38,
                    fontSize: 13,
                  ),
                  isDense: true,
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 18,
                    color: Colors.white38,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF181825),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loading ? null : _load,
            icon: const Icon(Icons.refresh, color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_groups.isEmpty) {
      return const Center(
        child: Text('No groups found', style: TextStyle(color: Colors.white38)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _groups.length,
      separatorBuilder: (_, _) =>
          const Divider(color: Colors.white10, height: 1),
      itemBuilder: (context, index) {
        final group = _groups[index];
        final archived = group.isArchived;
        return InkWell(
          onTap: () => _showDetails(group),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  child: Text(
                    group.displayName.isNotEmpty ? group.displayName : (group.name.isNotEmpty ? group.name : '—'),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 140,
                  child: Text(
                    group.name.isNotEmpty ? group.name : '—',
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    group.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ),
                Text(
                  '${group.memberCount} members',
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
                const SizedBox(width: 12),
                if (archived)
                  Text(
                    'Archived',
                    style: TextStyle(
                      color: Colors.redAccent.withValues(alpha: 0.8),
                      fontSize: 11,
                    ),
                  ),
                IconButton(
                  tooltip: archived ? 'Restore' : 'Archive',
                  onPressed: () =>
                      archived ? _restoreGroup(group) : _archiveGroup(group),
                  icon: Icon(
                    archived
                        ? Icons.unarchive_outlined
                        : Icons.archive_outlined,
                    color: Colors.white38,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GroupDetailsSheet extends StatefulWidget {
  final GroupsRepository repository;
  final GroupEntity group;

  const _GroupDetailsSheet({required this.repository, required this.group});

  @override
  State<_GroupDetailsSheet> createState() => _GroupDetailsSheetState();
}

class _GroupDetailsSheetState extends State<_GroupDetailsSheet> {
  int? _memberCount;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final stats = await widget.repository.getGroupStats(
        widget.group.id,
      );
      if (!mounted) return;
      setState(() {
        _memberCount = stats['total_member_count'] as int?;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.group;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.displayName.isNotEmpty ? group.displayName : (group.name.isNotEmpty ? group.name : 'Group'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            group.description,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _infoChip('Source', group.source.isNotEmpty ? group.source : '—'),
              const SizedBox(width: 8),
              _loading
                  ? const Text('…', style: TextStyle(color: Colors.white38))
                  : _error != null
                  ? Text(
                      'stats: $_error',
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 11,
                      ),
                    )
                  : _infoChip('Members', '$_memberCount'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF181825),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }
}
