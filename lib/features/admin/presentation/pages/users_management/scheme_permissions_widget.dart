import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/widgets/hover_widget.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/role_entity.dart';

class SchemePermissionsWidget extends StatelessWidget {
  const SchemePermissionsWidget({
    super.key,
    required this.title,
    required this.roles,
    required this.subtitle,
    required this.isVisible,
  });

  final String title;
  final List<RoleEntity> roles;
  final String subtitle;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.centerChannelBg,
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.20),
          width: 0.30,
        ),
      ),
      padding: .all(16),
      child: Column(
        children: [
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    spacing: 3,
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: .bold,
                          color: colors.centerChannelColor,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: .w500,
                          color: colors.centerChannelColor,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: isVisible ? 0.25 : 0,
                  duration: const Duration(milliseconds: 1000),
                  child: Icon(Icons.arrow_circle_right_outlined),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Permission',
                  style: TextStyle(fontSize: 15, fontWeight: .w600),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Description',
                  style: TextStyle(fontSize: 15, fontWeight: .w700),
                ),
              ),
            ],
          ),
          Divider(thickness: 0.80, height: 0),
          ...roles.map((role) {
            return Column(
              children: [
                CheckboxListTile(
                  dense: true,
                  minTileHeight: 35,
                  controlAffinity: .leading,
                  value: roles.first.schemeManaged,
                  onChanged: (value) {},
                  title: Text(
                    role.name
                        .split('_')
                        .map((e) => e.replaceFirst(e[0], e[0].toUpperCase()))
                        .join(' '),
                  ),
                ),
                ...List.generate(role.permissions.length, (index) {
                  final permission = role.permissions[index];
                  return HoverWidget(
                    builder: (context, isHovered) {
                      return Container(
                        color: isHovered
                            ? colors.linkColor.withValues(alpha: 0.30)
                            : index % 2 == 0
                            ? Color.fromRGBO(245, 245, 245, 1)
                            : Colors.black12,
                        child: Stack(
                          alignment: AlignmentDirectional.centerStart,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 50),
                                Expanded(
                                  child: CheckboxListTile(
                                    dense: true,
                                    minTileHeight: 35,
                                    controlAffinity: .leading,
                                    value: true,
                                    onChanged: (value) {},
                                    title: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            permission
                                                .split('_')
                                                .map(
                                                  (e) => e.replaceFirst(
                                                    e[0],
                                                    e[0].toUpperCase(),
                                                  ),
                                                )
                                                .join(' '),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(role.description),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (isHovered)
                              PositionedDirectional(
                                child: VerticalDivider(
                                  width: 0,
                                  thickness: 1.50,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ],
            );
          }),
        ],
      ),
    );
  }
}
