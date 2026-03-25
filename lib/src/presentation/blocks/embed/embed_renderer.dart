import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entities/blocks/embed_block.dart';
import '../base_block_renderer.dart';

class EmbedRenderer extends BlockRenderer<EmbedBlock> {
  const EmbedRenderer({super.key, required super.block, super.styleConfig});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: block.source.isNotEmpty
          ? () async {
              final uri = Uri.tryParse(block.source);
              if (uri == null) return;
              final scheme = uri.scheme.toLowerCase();
              if (scheme != 'http' && scheme != 'https') return;
              if (await canLaunchUrl(uri)) {
                await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );
              }
            }
          : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service banner
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.play_circle_outline,
                      size: 18, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text(
                    block.service.isNotEmpty
                        ? _capitalise(block.service)
                        : 'Embedded content',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.black87,
                      fontFamily: styleConfig?.defaultFont,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.open_in_new,
                      size: 14, color: Colors.black45),
                ],
              ),
            ),
            // Source URL
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                block.source,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue.shade700,
                  decoration: TextDecoration.underline,
                  fontFamily: styleConfig?.defaultFont,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Caption
            if (block.caption != null && block.caption!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                child: Text(
                  block.caption!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                    fontFamily: styleConfig?.defaultFont,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _capitalise(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
