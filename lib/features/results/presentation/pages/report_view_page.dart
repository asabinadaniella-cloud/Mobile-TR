import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/providers/app_providers.dart';
import '../models/report_models.dart';

class ReportViewPage extends ConsumerStatefulWidget {
  const ReportViewPage({required this.report, super.key});

  static const routeName = 'report-view';
  static const routePath = ':reportId';

  final Report report;

  @override
  ConsumerState<ReportViewPage> createState() => _ReportViewPageState();
}

class _ReportViewPageState extends ConsumerState<ReportViewPage> {
  late Map<String, TextEditingController> _controllers;
  late Map<String, dynamic> _currentSummary;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _currentSummary = Map<String, dynamic>.from(widget.report.summary);
    _controllers = <String, TextEditingController>{};
    _initControllers(widget.report.summary);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final analytics = ref.read(firebaseAnalyticsProvider);
      analytics?.logEvent(
        name: 'report_ready_view',
        parameters: {
          'report_id': widget.report.id,
          'status': widget.report.status.apiValue,
        },
      );
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isModeratorView = widget.report.status == ReportStatus.inReview;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.report.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.report.subtitle,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.table_view),
                onPressed: () => _onExport(context, 'csv'),
                label: Text(l10n.resultsExportCsv),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.picture_as_pdf_outlined),
                onPressed: () => _onExport(context, 'pdf'),
                label: Text(l10n.resultsDownloadPdf),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n.resultsSummaryTitle,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ..._buildSummaryBlocks(context, _currentSummary),
          const SizedBox(height: 24),
          Text(
            l10n.resultsRecommendationsTitle,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          if (widget.report.recommendations.isEmpty)
            Text(l10n.resultsRecommendationsEmpty)
          else
            ...widget.report.recommendations.map(
              (recommendation) => Card(
                child: ListTile(
                  leading: const Icon(Icons.lightbulb_outline),
                  title: Text(recommendation.title),
                  subtitle: Text(recommendation.description),
                ),
              ),
            ),
          if (isModeratorView) ...[
            const SizedBox(height: 32),
            Divider(color: theme.colorScheme.outlineVariant),
            const SizedBox(height: 16),
            Text(
              l10n.resultsModeratorSectionTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.resultsSummaryEditorHint,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            ..._controllers.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: entry.value,
                  decoration: InputDecoration(
                    labelText: entry.key,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              );
            }),
            if (_hasChanges)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  l10n.resultsSummaryDraftNotice,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
                ),
              ),
            ElevatedButton.icon(
              icon: const Icon(Icons.publish_outlined),
              onPressed: _onPublish,
              label: Text(l10n.resultsPublishAction),
            ),
          ],
        ],
      ),
    );
  }

  void _initControllers(Map<String, dynamic> data, [String prefix = '']) {
    data.forEach((key, value) {
      final path = prefix.isEmpty ? key : '$prefix.$key';
      if (value is Map<String, dynamic>) {
        _initControllers(value, path);
      } else {
        final controller = TextEditingController(text: value.toString());
        controller.addListener(() {
          setState(() {
            _hasChanges = true;
          });
        });
        _controllers[path] = controller;
      }
    });
  }

  List<Widget> _buildSummaryBlocks(BuildContext context, Map<String, dynamic> summary) {
    final theme = Theme.of(context);
    return summary.entries.map((entry) {
      final value = entry.value;
      if (value is Map<String, dynamic>) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                ...value.entries.map(
                  (metric) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            metric.key,
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 3,
                          child: Text(
                            metric.value.toString(),
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return Card(
        child: ListTile(
          title: Text(entry.key),
          subtitle: Text(value.toString()),
        ),
      );
    }).toList();
  }

  Map<String, dynamic> _collectUpdatedSummary(Map<String, dynamic> source, [String prefix = '']) {
    final result = <String, dynamic>{};
    source.forEach((key, value) {
      final path = prefix.isEmpty ? key : '$prefix.$key';
      if (value is Map<String, dynamic>) {
        result[key] = _collectUpdatedSummary(value, path);
      } else {
        final controller = _controllers[path];
        if (controller != null) {
          final text = controller.text.trim();
          final numeric = num.tryParse(text);
          result[key] = numeric ?? text;
        } else {
          result[key] = value;
        }
      }
    });
    return result;
  }

  void _onPublish() {
    final l10n = AppLocalizations.of(context);
    final analytics = ref.read(firebaseAnalyticsProvider);
    final updatedSummary = _collectUpdatedSummary(widget.report.summary);
    final hadChanges = _hasChanges;
    analytics?.logEvent(
      name: 'report_publish',
      parameters: {
        'report_id': widget.report.id,
        'status': widget.report.status.apiValue,
        'has_changes': hadChanges ? 1 : 0,
      },
    );
    setState(() {
      _currentSummary = updatedSummary;
      _hasChanges = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.resultsPublishSuccessMessage)),
    );
  }

  void _onExport(BuildContext context, String format) {
    final l10n = AppLocalizations.of(context);
    final analytics = ref.read(firebaseAnalyticsProvider);
    analytics?.logEvent(
      name: 'export_downloaded',
      parameters: {
        'report_id': widget.report.id,
        'format': format,
      },
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${l10n.resultsExportPreparing} ${format.toUpperCase()}')),
    );
  }
}
