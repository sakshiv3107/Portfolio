import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/section_header.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  final _honeypotCtrl = TextEditingController(); // spam protection
  bool _isLoading = false;
  bool _submitted = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    _honeypotCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Honeypot check — bots fill hidden fields
    if (_honeypotCtrl.text.isNotEmpty) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // mailto fallback
    final subject = Uri.encodeComponent(_subjectCtrl.text);
    final body = Uri.encodeComponent(
      'Name: ${_nameCtrl.text}\n\n${_messageCtrl.text}',
    );
    final mailtoUri = Uri.parse(
      'mailto:sakshi.vishnoi3107@gmail.com?subject=$subject&body=$body',
    );

    try {
      if (await canLaunchUrl(mailtoUri)) {
        await launchUrl(mailtoUri);
      }
      setState(() {
        _isLoading = false;
        _submitted = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    color: AppColors.accentCyan),
                const SizedBox(width: 8),
                Text(
                  'Message sent! I\'ll get back to you soon.',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        );
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _launchSocial(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: AppSpacing.section,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                overline: 'Let\'s Talk',
                title: 'Get In Touch.',
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Have a project in mind, or just want to say hi? My inbox is always open.',
                style: AppTypography.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.xxl),

              isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildForm(),
                        const SizedBox(height: AppSpacing.xxl),
                        _buildSocialLinks(),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _buildForm()),
                        const SizedBox(width: AppSpacing.xxxl),
                        Expanded(flex: 2, child: _buildSocialLinks()),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    if (_submitted) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        decoration: BoxDecoration(
          color: AppColors.accentCyan.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: AppColors.accentCyanMuted),
        ),
        child: Column(
          children: [
            const Icon(Icons.check_circle_outline_rounded,
                color: AppColors.accentCyan, size: 48),
            const SizedBox(height: AppSpacing.md),
            Text("Message received!", style: AppTypography.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              "Thanks for reaching out. I'll get back to you at ${_emailCtrl.text}.",
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + Email row
          Row(
            children: [
              Expanded(
                child: _FormField(
                  controller: _nameCtrl,
                  label: 'Name',
                  hint: 'Your name',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Name is required' : null,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _FormField(
                  controller: _emailCtrl,
                  label: 'Email',
                  hint: 'your@email.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    final emailRegex =
                        RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(v)) return 'Enter a valid email';
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          _FormField(
            controller: _subjectCtrl,
            label: 'Subject',
            hint: 'What\'s this about?',
            validator: (v) =>
                v == null || v.isEmpty ? 'Subject is required' : null,
          ),
          const SizedBox(height: AppSpacing.md),

          _FormField(
            controller: _messageCtrl,
            label: 'Message',
            hint: 'Tell me about your project, opportunity, or just say hi...',
            maxLines: 5,
            validator: (v) =>
                v == null || v.isEmpty ? 'Message is required' : null,
          ),

          // Honeypot — hidden from humans, bots fill it
          Opacity(
            opacity: 0,
            child: SizedBox(
              height: 0,
              child: TextFormField(
                controller: _honeypotCtrl,
                decoration: const InputDecoration(labelText: 'Leave this empty'),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _submit,
              icon: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.background,
                      ),
                    )
                  : const Icon(Icons.send_rounded, size: 18),
              label: Text(_isLoading ? 'Sending…' : 'Send Message'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Or find me at', style: AppTypography.overline),
        const SizedBox(height: AppSpacing.lg),
        _SocialLink(
          icon: FontAwesomeIcons.github,
          label: 'GitHub',
          value: 'sakshiv3107',
          onTap: () => _launchSocial('https://github.com/sakshiv3107'),
        ),
        const SizedBox(height: AppSpacing.md),
        _SocialLink(
          icon: FontAwesomeIcons.linkedin,
          label: 'LinkedIn',
          value: 'sakshi-vishnoi',
          onTap: () => _launchSocial(
              'https://www.linkedin.com/in/sakshi-vishnoi-7770b2315/'),
        ),
        const SizedBox(height: AppSpacing.md),
        _SocialLink(
          icon: Icons.email_outlined,
          label: 'Email',
          value: 'sakshi.vishnoi3107@gmail.com',
          onTap: () =>
              _launchSocial('mailto:sakshi.vishnoi3107@gmail.com'),
        ),
        const SizedBox(height: AppSpacing.md),
        _SocialLink(
          icon: Icons.code_rounded,
          label: 'LeetCode',
          value: 'sakshiv31',
          onTap: () => _launchSocial('https://leetcode.com/u/sakshiv31/'),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Availability card
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.accentCyan.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.accentCyanMuted),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.accentCyan,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available for Internships',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Summer / Fall 2025 · Flutter & Mobile',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
    );
  }
}

class _SocialLink extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _SocialLink({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  State<_SocialLink> createState() => _SocialLinkState();
}

class _SocialLinkState extends State<_SocialLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.sm + 4),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.accentCyan.withOpacity(0.06)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered ? AppColors.accentCyanMuted : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: _hovered ? AppColors.accentCyan : AppColors.textMuted,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      widget.value,
                      style: AppTypography.bodySmall.copyWith(
                        color: _hovered
                            ? AppColors.accentCyan
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.open_in_new_rounded,
                size: 13,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

