import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/post_repository.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/markdown_message.dart';

/// جسم لوحة سجل التعديلات داخل RHS — مطابق لوحة Edit History في webapp:
/// نسخ الرسالة السابقة مرتبة زمنياً، مع زر استعادة لكل نسخة أقدم من الحالية.
class PostEditHistoryPanel extends StatelessWidget {
  const PostEditHistoryPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<RhsBloc, RhsState>(
      builder: (context, state) {
        if (state is! RhsEditHistoryState) return const SizedBox.shrink();
        final historyState = state;

        if (historyState.loading) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final versions = historyState.versions;
        if (versions.isEmpty) {
          return _EmptyBody(
            title: l10n.search_headerTitle_editHistory,
            subtitle: l10n.rhsNoResultsEditHistory,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: versions.length,
          itemBuilder: (context, index) =>
              _VersionItem(post: versions[index], isLatest: index == 0),
        );
      },
    );
  }
}

class _VersionItem extends StatelessWidget {
  final PostEntity post;
  final bool isLatest;

  const _VersionItem({required this.post, required this.isLatest});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final time = DateFormat('MMM d, yyyy · HH:mm').format(
      DateTime.fromMillisecondsSinceEpoch(post.editAt),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.centerChannelColor.withValues(
          alpha: isLatest ? 0.04 : 0,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.centerChannelColor.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 14,
                color: theme.centerChannelColor.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 6),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.centerChannelColor.withValues(alpha: 0.6),
                ),
              ),
              const Spacer(),
              if (isLatest)
                Text(
                  'أحدث نسخة',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.linkColor,
                  ),
                )
              else
                TextButton(
                  onPressed: () => _restore(context, post),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: const Text('استعادة'),
                ),
            ],
          ),
          const SizedBox(height: 4),
          MarkdownMessage(text: post.message),
        ],
      ),
    );
  }

  Future<void> _restore(BuildContext context, PostEntity post) async {
    try {
      await getIt<PostRepository>().restorePostVersion(post.id, post.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تمت استعادة النسخة السابقة')),
      );
      context.read<RhsBloc>().add(CloseRhsEvent());
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذّر استعادة النسخة')),
      );
    }
  }
}

class _EmptyBody extends StatelessWidget {
  final String title;
  final String subtitle;

  const _EmptyBody({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history,
              size: 48,
              color: theme.centerChannelColor.withValues(alpha: 0.25),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: theme.centerChannelColor.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: theme.centerChannelColor.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}