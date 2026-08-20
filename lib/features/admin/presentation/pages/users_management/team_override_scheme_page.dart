import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/role_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/scheme_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_roles_schemes_repository.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/users_management/scheme_permissions_widget.dart';
import 'package:flutter_mattermost/features/teams/domain/entities/team_entity.dart';

class TeamOverrideSchemePage extends StatefulWidget {
  const TeamOverrideSchemePage({super.key});

  @override
  State<TeamOverrideSchemePage> createState() => _TeamOverrideSchemePageState();
}

class _TeamOverrideSchemePageState extends State<TeamOverrideSchemePage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  List<RoleEntity> _roles = [];
  List<SchemeEntity> _schemes = [];
  String? _error;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    final repository = getIt<AdminRolesSchemesRepository>();
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      _roles = await repository.getRoles();
      _schemes = await repository.getSchemes(scope: 'channel');
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: Container(
          color: colors.centerChannelBg,
          child: Row(
            children: [
              SizedBox(
                width: 65,
                height: 65,
                child: InkWell(
                  child: Align(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ),
              VerticalDivider(thickness: 0.50, width: 0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8,
                  ),
                  child: Text(
                    'Team Scheme',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: .w600,
                      color: colors.centerChannelColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _loading
          ? _buildLoading()
          : _error != null
          ? _buildError()
          : _buildBody(),
    );
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildError() {
    return Container(
      padding: .all(8),
      decoration: BoxDecoration(
        border: .all(width: 0.50, color: Colors.red),
        borderRadius: .circular(6),
        color: Colors.red.withValues(alpha: 0.20),
      ),
      alignment: .center,
      child: Text(
        _error ?? '',
        style: TextStyle(fontSize: 20, fontWeight: .bold),
      ),
    );
  }

  SingleChildScrollView _buildBody() {
    final guests = _roles.where((r) => r.name == 'system_guest').toList();
    final allUsers = _roles
        .where(
          (r) =>
              r.name == 'system_user' ||
              r.name == 'team_user' ||
              r.name == 'channel_user',
        )
        .toList();
    final channelAdmins = _roles
        .where((r) => r.name == 'channel_admin')
        .toList();
    const teamAdmins = <RoleEntity>[];
    final sysAdmins = _roles.where((r) => r.name == 'system_admin').toList();
    final playbookAdmins = _roles
        .where((r) => r.name == 'playbook_admin')
        .toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 870,
        child: Column(
          crossAxisAlignment: .start,
          spacing: 24,
          children: [
            noticeWidget(),
            schemeDetailsWidget(),
            _buildTeamOverrideSchemesPanel([]),
            if (guests.isNotEmpty)
              SchemePermissionsWidget(
                title: 'Gest',
                roles: guests,
                subtitle: 'Permissions granted to guest users.',
                isVisible: true,
              ),
            if (allUsers.isNotEmpty)
              SchemePermissionsWidget(
                title: 'All Members',
                roles: allUsers,
                subtitle:
                    'Permissions granted to all members, including administrators and newly created users.',
                isVisible: true,
              ),
            if (channelAdmins.isNotEmpty)
              SchemePermissionsWidget(
                title: 'Channel Administrators',
                roles: channelAdmins,
                subtitle:
                    'Permissions granted to channel creators and any users promoted to Channel Administrator.',
                isVisible: true,
              ),
            if (playbookAdmins.isNotEmpty)
              SchemePermissionsWidget(
                title: 'Playbook Administrators',
                roles: allUsers,
                subtitle:
                    'Permissions granted to administrators of a playbook.',
                isVisible: true,
              ),
            if (teamAdmins.isNotEmpty)
              SchemePermissionsWidget(
                title: 'Team Administrators',
                roles: teamAdmins,
                subtitle:
                    'Permissions granted to team creators and any users promoted to Team Administrator.',
                isVisible: true,
              ),
            if (sysAdmins.isNotEmpty)
              SchemePermissionsWidget(
                title: 'System Administrators',
                roles: allUsers,
                subtitle:
                    'Permissions granted to all members, including administrators and newly created users.',
                isVisible: true,
              ),
          ],
        ),
      ),
    );
  }

  Widget noticeWidget() {
    final colors = AppTheme.of(context);
    return Container(
      padding: .all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.30,
          color: colors.centerChannelColor.withValues(alpha: 0.20),
        ),
        color: colors.centerChannelBg,
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: colors.linkColor, fontSize: 13, height: 1.50),
          text:
              'Team Override Schemes set the permissions for Team Admins, Channel Admins and other members in specific teams. Use a Team Override Scheme when specific teams need permission exceptions to the ',
          children: [TextSpan(text: 'System Scheme.')],
        ),
      ),
    );
  }

  Widget schemeDetailsWidget() {
    final colors = AppTheme.of(context);
    return Container(
      padding: .all(16.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.30,
          color: colors.centerChannelColor.withValues(alpha: 0.20),
        ),
        color: colors.centerChannelBg,
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            'Scheme Details',
            style: TextStyle(
              fontSize: 18,
              color: colors.centerChannelColor,
              fontWeight: .bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Set the name and description for this scheme.',
            style: TextStyle(fontSize: 14, color: colors.centerChannelColor),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 140, child: Text('Scheme Name:')),
              const SizedBox(width: 50),
              Expanded(
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Scheme Name',
                    contentPadding: .symmetric(horizontal: 8, vertical: 8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(width: 140, child: Text('Scheme Description:')),

              const SizedBox(width: 50),
              Expanded(
                child: TextField(
                  controller: descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    contentPadding: .symmetric(horizontal: 8, vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamOverrideSchemesPanel(List<TeamEntity> selectedTeams) {
    final colors = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.centerChannelBg,
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.20),
          width: 0.30,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      'Select teams to override permissions',
                      style: TextStyle(
                        color: colors.centerChannelColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Select teams where permission exceptions are required.',
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.centerChannelColor,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: .circular(2)),
                  padding: .all(16),
                ),
                onPressed: () {},
                child: Text('Add Teams'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Team override schemes allow you to customize permissions for specific teams.',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 16),
          if (selectedTeams.isEmpty)
            Align(
              alignment: .center,
              child: Text(
                'No team selected. Please add teams to this list.',
                style: TextStyle(
                  fontSize: 16,
                  color: colors.centerChannelColor.withValues(alpha: 0.65),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
