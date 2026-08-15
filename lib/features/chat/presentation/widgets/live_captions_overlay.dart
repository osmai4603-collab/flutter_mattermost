import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/captions_bloc.dart';
import 'package:flutter_mattermost/core/calls/calls_manager.dart';

class LiveCaptionsOverlay extends StatelessWidget {
  const LiveCaptionsOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaptionsBloc, CaptionsState>(
      builder: (context, state) {
        if (state.activeCaptions.isEmpty) return const SizedBox.shrink();

        return Positioned(
          bottom: 120,
          left: 20,
          right: 20,
          child: Column(
            children: state.activeCaptions.map((caption) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _CaptionItem(caption: caption),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _CaptionItem extends StatelessWidget {
  final dynamic caption;

  const _CaptionItem({required this.caption});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: '${caption.userId}: ',
              style: const TextStyle(
                color: Colors.yellowAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: caption.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
