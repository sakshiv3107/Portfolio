import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'emailjs_service.dart';

enum _SendState { idle, loading, success, error }

class ContactFormWidget extends StatefulWidget {
  const ContactFormWidget({super.key});

  @override
  State<ContactFormWidget> createState() => _ContactFormWidgetState();
}

class _ContactFormWidgetState extends State<ContactFormWidget>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  final _honeypotCtrl = TextEditingController();

  late AnimationController _checkCtrl;
  _SendState _state = _SendState.idle;
  bool _btnHovered = false;

  final _emailService = EmailJSService();

  // Focus nodes for glow effect
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _subjectFocus = FocusNode();
  final _messageFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _checkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    for (final fn in [_nameFocus, _emailFocus, _subjectFocus, _messageFocus]) {
      fn.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    _honeypotCtrl.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _subjectFocus.dispose();
    _messageFocus.dispose();
    _checkCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_honeypotCtrl.text.isNotEmpty) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _state = _SendState.loading);

    final success = await _emailService.sendEmail(
      fromName: _nameCtrl.text.trim(),
      fromEmail: _emailCtrl.text.trim(),
      subject: _subjectCtrl.text.trim(),
      message: _messageCtrl.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      setState(() => _state = _SendState.success);
      _checkCtrl.forward(from: 0);
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      setState(() {
        _state = _SendState.idle;
        _nameCtrl.clear();
        _emailCtrl.clear();
        _subjectCtrl.clear();
        _messageCtrl.clear();
        _checkCtrl.reset();
      });
    } else {
      setState(() => _state = _SendState.error);
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      setState(() => _state = _SendState.idle);
    }
  }

  InputDecoration _fieldDecoration({
    required String label,
    required String hint,
    required FocusNode focusNode,
  }) {
    final bool focused = focusNode.hasFocus;
    return InputDecoration(
      label: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '> ',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                color: focused
                    ? const Color(0xFF3B82F6)
                    : const Color(0xFF6B7A8D),
              ),
            ),
            TextSpan(
              text: '$label:',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                color: focused
                    ? const Color(0xFFE8EDF5)
                    : const Color(0xFF6B7A8D),
              ),
            ),
          ],
        ),
      ),
      hintText: hint,
      hintStyle: GoogleFonts.jetBrainsMono(
        fontSize: 13,
        color: const Color(0x4D6B7A8D),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.fromLTRB(16, 28, 16, 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: const BorderSide(color: Color(0xFF1A2030)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Color(0xFFFF4444)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Color(0xFFFF4444), width: 1.5),
      ),
      filled: true,
      fillColor: focused
          ? const Color(0xFF0D1219)
          : const Color(0xFF0F1318),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final bool focused = focusNode.hasFocus;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        boxShadow: focused
            ? [
                BoxShadow(
                  color: const Color(0x263B82F6),
                  blurRadius: 16,
                  spreadRadius: 0,
                  offset: Offset.zero,
                ),
              ]
            : [],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        enabled: _state != _SendState.loading,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 13,
          color: const Color(0xFFE8EDF5),
        ),
        decoration: _fieldDecoration(
          label: label,
          hint: hint,
          focusNode: focusNode,
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    final bool isLoading = _state == _SendState.loading;
    final bool isSuccess = _state == _SendState.success;
    final bool isError = _state == _SendState.error;

    Color bgColor = const Color(0xFF3B82F6);
    if (isSuccess) bgColor = const Color(0xFF00FF88);
    if (isError) bgColor = const Color(0xFFFF4444);

    return MouseRegion(
      cursor: isLoading ? SystemMouseCursors.wait : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _btnHovered = true),
      onExit: (_) => setState(() => _btnHovered = false),
      child: GestureDetector(
        onTap: (isLoading || isSuccess) ? null : _submit,
        child: AnimatedScale(
          scale: isLoading ? 1.0 : (_btnHovered ? 1.02 : 1.0),
          duration: const Duration(milliseconds: 180),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: bgColor,
              boxShadow: _btnHovered && !isLoading
                  ? [
                      BoxShadow(
                        color: bgColor.withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 0,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: isLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Sending...',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : isSuccess
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              size: 18,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Message Sent!',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        )
                      : isError
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Failed — Try Again',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.send_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Send Message',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: const BoxDecoration(
        color: Color(0xFF0F1318),
        border: Border.fromBorderSide(
          BorderSide(color: Color(0xFF1A2030)),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name + Email row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildField(
                    controller: _nameCtrl,
                    focusNode: _nameFocus,
                    label: 'name',
                    hint: 'Your full name',
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (v.trim().length < 2) return 'Min 2 characters';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildField(
                    controller: _emailCtrl,
                    focusNode: _emailFocus,
                    label: 'email',
                    hint: 'your@email.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      final re = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$');
                      if (!re.hasMatch(v.trim())) return 'Invalid email';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildField(
              controller: _subjectCtrl,
              focusNode: _subjectFocus,
              label: 'subject',
              hint: "What's this about?",
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (v.trim().length < 3) return 'Min 3 characters';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildField(
              controller: _messageCtrl,
              focusNode: _messageFocus,
              label: 'message',
              hint: 'Tell me about your project...',
              maxLines: 6,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                return null;
              },
            ),

            // Honeypot
            Opacity(
              opacity: 0,
              child: SizedBox(
                height: 0,
                child: TextFormField(
                  controller: _honeypotCtrl,
                  decoration: const InputDecoration(labelText: 'Leave empty'),
                ),
              ),
            ),

            const SizedBox(height: 24),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }
}
