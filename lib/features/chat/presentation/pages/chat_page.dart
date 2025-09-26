import 'dart:math';

import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n.dart';
import '../../application/chat_controller.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  static const routeName = 'chat';
  static const routePath = '/chat';

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _scrollController = ScrollController();
  final _textController = TextEditingController();
  late final ProviderSubscription<ChatState> _subscription;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _subscription = ref.listen<ChatState>(chatControllerProvider, (previous, next) {
      if (!mounted) {
        return;
      }
      final previousLast = previous?.messages.lastOrNull;
      final nextLast = next.messages.lastOrNull;
      if (nextLast != null && (previousLast == null || nextLast.sentAt.isAfter(previousLast.sentAt))) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(force: false));
      }
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.errorMessage!)),
          );
          ref.read(chatControllerProvider.notifier).clearError();
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription.close();
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(chatControllerProvider);
    final controller = ref.read(chatControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.chatTitle)),
      body: Column(
        children: [
          _buildModeSelector(context, state, controller, l10n),
          if (state.mode == ChatMode.moderator)
            _buildModeratorToolbar(context, state, controller, l10n),
          Expanded(child: _buildMessageList(context, state, l10n)),
          if (state.isModeratorTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const SizedBox.square(dimension: 8, child: CircularProgressIndicator(strokeWidth: 2)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(l10n.chatModeratorTyping)),
                ],
              ),
            ),
          if (state.pendingAttachments.isNotEmpty)
            _buildPendingAttachments(context, state, controller, l10n),
          _buildInputArea(context, state, controller, l10n),
        ],
      ),
    );
  }

  Widget _buildModeSelector(
    BuildContext context,
    ChatState state,
    ChatController controller,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SegmentedButton<ChatMode>(
        segments: [
          ButtonSegment(value: ChatMode.user, label: Text(l10n.chatModeUser)),
          ButtonSegment(value: ChatMode.moderator, label: Text(l10n.chatModeModerator)),
        ],
        selected: {state.mode},
        onSelectionChanged: (selection) {
          controller.setMode(selection.first);
        },
      ),
    );
  }

  Widget _buildModeratorToolbar(
    BuildContext context,
    ChatState state,
    ChatController controller,
    AppLocalizations l10n,
  ) {
    final selectedChatId = state.availableChats.any((chat) => chat.id == state.selectedChatId)
        ? state.selectedChatId
        : null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedChatId,
              decoration: InputDecoration(labelText: l10n.chatModeratorChatPickerLabel),
              items: state.availableChats
                  .map(
                    (chat) => DropdownMenuItem(
                      value: chat.id,
                      child: Text(chat.title ?? chat.userId),
                    ),
                  )
                  .toList(),
              onChanged: state.isLoading ? null : (value) => value == null ? null : controller.selectChat(value),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: state.isMarkingInWork || selectedChatId == null ? null : controller.markChatInWork,
            icon: const Icon(Icons.work_outline),
            label: Text(l10n.chatMarkInWork),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(
    BuildContext context,
    ChatState state,
    AppLocalizations l10n,
  ) {
    if (state.isLoading && state.messages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.messages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            state.mode == ChatMode.user ? l10n.chatEmptyUser : l10n.chatEmptyModerator,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final items = _buildMessageItems(state.messages);
    return Stack(
      children: [
        ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          itemCount: items.length + (state.isFetchingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (state.isFetchingMore && index == 0) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final item = items[state.isFetchingMore ? index - 1 : index];
            return item.when(
              date: (date) => _DateHeader(date: date),
              message: (message) => _MessageBubble(message: message, l10n: l10n),
            );
          },
        ),
        if (!state.hasMore)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                l10n.chatHistoryEnd,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPendingAttachments(
    BuildContext context,
    ChatState state,
    ChatController controller,
    AppLocalizations l10n,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: state.pendingAttachments
            .map(
              (file) => InputChip(
                avatar: const Icon(Icons.attach_file),
                label: Text(file.name),
                onDeleted: () => controller.removeAttachment(file),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildInputArea(
    BuildContext context,
    ChatState state,
    ChatController controller,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file),
              tooltip: l10n.chatAttachTooltip,
              onPressed: state.isSending ? null : _pickAttachments,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _textController,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
                enabled: !state.isSending,
                decoration: InputDecoration(
                  hintText: l10n.chatInputHint,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: state.isSending ? null : () => _handleSend(controller),
              icon: state.isSending
                  ? SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.onPrimary,
                      ),
                    )
                  : const Icon(Icons.send),
              tooltip: l10n.chatSend,
            ),
          ],
        ),
      ),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    if (_scrollController.position.pixels <= 80 &&
        !_scrollController.position.outOfRange &&
        !ref.read(chatControllerProvider).isFetchingMore) {
      ref.read(chatControllerProvider.notifier).loadMore();
    }
  }

  void _scrollToBottom({required bool force}) {
    if (!_scrollController.hasClients) {
      return;
    }
    final position = _scrollController.position;
    final threshold = 160.0;
    final distance = position.maxScrollExtent - position.pixels;
    if (force || distance < threshold) {
      final target = max(position.maxScrollExtent, 0.0);
      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _pickAttachments() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) {
      return;
    }
    final files = result.files
        .where((file) => file.path != null)
        .map(
          (file) => PendingAttachment(
            path: file.path!,
            name: file.name,
            mimeType: file.mimeType,
            size: file.size,
          ),
        )
        .toList();
    if (files.isNotEmpty) {
      ref.read(chatControllerProvider.notifier).addAttachments(files);
    }
  }

  void _handleSend(ChatController controller) {
    final text = _textController.text;
    _textController.clear();
    controller.sendMessage(text);
    _scrollToBottom(force: true);
  }

  List<_ChatListItem> _buildMessageItems(List<ChatMessageView> messages) {
    final items = <_ChatListItem>[];
    DateTime? currentDate;
    for (final message in messages) {
      final date = DateTime(message.sentAt.year, message.sentAt.month, message.sentAt.day);
      if (currentDate == null || currentDate != date) {
        currentDate = date;
        items.add(_ChatListItem.date(date));
      }
      items.add(_ChatListItem.message(message));
    }
    return items;
  }
}

class _ChatListItem {
  const _ChatListItem._({this.date, this.message});

  factory _ChatListItem.date(DateTime date) => _ChatListItem._(date: date);
  factory _ChatListItem.message(ChatMessageView message) => _ChatListItem._(message: message);

  final DateTime? date;
  final ChatMessageView? message;

  T when<T>({required T Function(DateTime date) date, required T Function(ChatMessageView message) message}) {
    if (this.date != null) {
      return date(this.date!);
    }
    return message(this.message!);
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final text = DateFormat.yMMMMd(locale.toLanguageTag()).format(date);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(text, style: theme.textTheme.labelMedium),
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.l10n});

  final ChatMessageView message;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMine = message.isMine;
    final colorScheme = theme.colorScheme;
    final backgroundColor = isMine ? colorScheme.primaryContainer : colorScheme.surfaceVariant;
    final textColor = isMine ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant;
    final author = message.isModerator ? l10n.chatAuthorModerator : l10n.chatAuthorUser;
    final timeText = DateFormat.Hm().format(message.sentAt);
    final statusText = message.isSynced ? null : l10n.chatMessagePending;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
        child: Card(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMine ? 16 : 4),
              bottomRight: Radius.circular(isMine ? 4 : 16),
            ),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  author,
                  style: theme.textTheme.labelSmall?.copyWith(color: textColor.withOpacity(0.7)),
                ),
                const SizedBox(height: 4),
                Text(
                  message.body,
                  style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
                ),
                if (message.attachments.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: message.attachments
                        .map(
                          (file) => Chip(
                            label: Text(file.url.split('/').last),
                            avatar: const Icon(Icons.insert_drive_file_outlined, size: 18),
                          ),
                        )
                        .toList(),
                  ),
                ],
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    statusText == null ? timeText : '$timeText · $statusText',
                    style: theme.textTheme.labelSmall?.copyWith(color: textColor.withOpacity(0.7)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
