import 'package:flutter/material.dart';

class AddTransactionSheet extends StatefulWidget {
  final bool Function(String title, double amount, bool isExpense) onSubmit;
  final String? Function()? validationMessageBuilder;

  const AddTransactionSheet({
    super.key,
    required this.onSubmit,
    this.validationMessageBuilder,
  });

  static Future<void> show(
    BuildContext context, {
    required bool Function(String title, double amount, bool isExpense)
    onSubmit,
    String? Function()? validationMessageBuilder,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => AddTransactionSheet(
        onSubmit: onSubmit,
        validationMessageBuilder: validationMessageBuilder,
      ),
    );
  }

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _amountFocusNode = FocusNode();
  var _isExpense = true;
  String? _inlineHintMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;

    if (title.isEmpty || amount <= 0) {
      return;
    }

    final submitted = widget.onSubmit(title, amount, _isExpense);

    if (!submitted) {
      setState(() {
        _inlineHintMessage =
            widget.validationMessageBuilder?.call() ??
            'Unable to add transaction';
      });
      return;
    }

    setState(() {
      _inlineHintMessage = null;
    });

    _titleController.clear();
    _amountController.clear();

    Navigator.pop(context);
  }

  void _clearInlineHint() {
    if (_inlineHintMessage == null) {
      return;
    }
    setState(() {
      _inlineHintMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 18),
            child: child,
          ),
        );
      },
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 3,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Transaction',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                onChanged: (_) => _clearInlineHint(),
                onSubmitted: (_) {
                  _amountFocusNode.requestFocus();
                },
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                focusNode: _amountFocusNode,
                textInputAction: TextInputAction.done,
                onChanged: (_) => _clearInlineHint(),
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: const OutlineInputBorder(),
                  helperText: _inlineHintMessage,
                  helperMaxLines: 2,
                  helperStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                value: _isExpense,
                title: Text(_isExpense ? 'Spend' : 'Income'),
                onChanged: (value) {
                  setState(() {
                    _isExpense = value;
                    _inlineHintMessage = null;
                  });
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF0EA5E9)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: _submit,
                    child: const Text('Add Transaction'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
