import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ServerErrorWidget extends StatefulWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final String? retryButtonText;
  final Color? primaryColor;
  final Color? backgroundColor;
  final bool showAnimation;
  final EdgeInsetsGeometry? padding;
  final double? iconSize;

  const ServerErrorWidget({
    super.key,
    this.title,
    this.message,
    this.onRetry,
    this.retryButtonText,
    this.primaryColor,
    this.backgroundColor,
    this.showAnimation = true,
    this.padding,
    this.iconSize,
  });

  @override
  State<ServerErrorWidget> createState() => _ServerErrorWidgetState();
}

class _ServerErrorWidgetState extends State<ServerErrorWidget> {
  bool _isRetrying = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final primaryColor = widget.primaryColor ?? theme.colorScheme.error;
    final backgroundColor = widget.backgroundColor ?? theme.scaffoldBackgroundColor;

    // Responsive sizing
    final isSmallScreen = screenWidth < 400;
    final isMediumScreen = screenWidth >= 400 && screenWidth < 600;

    final responsiveIconSize =
        widget.iconSize ??
        (isSmallScreen
            ? 100.0
            : isMediumScreen
            ? 120.0
            : 140.0);
    final responsivePadding = widget.padding ?? EdgeInsets.symmetric(horizontal: isSmallScreen ? 16.0 : 24.0, vertical: isSmallScreen ? 24.0 : 32.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 200, maxWidth: constraints.maxWidth),
          padding: responsivePadding,
          decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(16)),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight > 200 ? constraints.maxHeight - (responsivePadding.vertical) : 200),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated error icon with floating effect
                    _buildAnimatedIcon(primaryColor, backgroundColor, responsiveIconSize),

                    SizedBox(height: isSmallScreen ? 24 : 32),

                    // Title
                    _buildTitle(theme, isSmallScreen, isMediumScreen),

                    SizedBox(height: isSmallScreen ? 16 : 20),

                    // Message
                    _buildMessage(theme, isSmallScreen, isMediumScreen),

                    SizedBox(height: isSmallScreen ? 28 : 36),

                    // Retry button (no annoying animation)
                    if (widget.onRetry != null) _buildRetryButton(primaryColor, isSmallScreen, isMediumScreen),

                    SizedBox(height: isSmallScreen ? 16 : 20),

                    // Additional help text
                    _buildHelpText(theme, isSmallScreen),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedIcon(Color primaryColor, Color backgroundColor, double iconSize) {
    final iconWidget = Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: primaryColor.withOpacity(0.1),
        border: Border.all(color: primaryColor.withOpacity(0.3), width: 2),
        boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.1), blurRadius: 20, spreadRadius: 5)],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Floating background circles
          Container(
                width: iconSize * 0.7,
                height: iconSize * 0.7,
                decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor.withOpacity(0.05)),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0), duration: 2000.ms, curve: Curves.easeInOut)
              .then()
              .scale(begin: const Offset(1.0, 1.0), end: const Offset(0.8, 0.8), duration: 2000.ms, curve: Curves.easeInOut),

          // Main server icon
          Icon(
            Icons.cloud_off_outlined,
            size: iconSize * 0.4,
            color: primaryColor,
          ).animate().fade(duration: 600.ms, curve: Curves.easeOut).scale(begin: const Offset(0.5, 0.5), duration: 800.ms, curve: Curves.elasticOut),

          // Warning indicator
          Positioned(
            right: iconSize * 0.12,
            top: iconSize * 0.12,
            child: Container(
              width: iconSize * 0.25,
              height: iconSize * 0.25,
              decoration: BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
                border: Border.all(color: backgroundColor, width: 3),
                boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.3), blurRadius: 8, spreadRadius: 2)],
              ),
              child: Icon(Icons.priority_high_rounded, color: Colors.white, size: iconSize * 0.15),
            ).animate(delay: 400.ms).fade(duration: 300.ms).scale(begin: const Offset(0, 0), duration: 500.ms, curve: Curves.elasticOut),
          ),
        ],
      ),
    );

    return widget.showAnimation
        ? iconWidget.animate().fadeIn(duration: 800.ms, curve: Curves.easeOut).slideY(begin: 0.3, duration: 800.ms, curve: Curves.easeOutBack)
        : iconWidget;
  }

  Widget _buildTitle(ThemeData theme, bool isSmallScreen, bool isMediumScreen) {
    final titleWidget = Flexible(
      child: Text(
        widget.title ?? 'title'.tr(),
        style: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
          fontSize:
              isSmallScreen
                  ? 24
                  : isMediumScreen
                  ? 28
                  : 32,
          letterSpacing: -0.5,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );

    return widget.showAnimation
        ? titleWidget.animate(delay: 200.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2, duration: 600.ms, curve: Curves.easeOut)
        : titleWidget;
  }

  Widget _buildMessage(ThemeData theme, bool isSmallScreen, bool isMediumScreen) {
    final messageWidget = Flexible(
      child: Text(
        widget.message ?? 'message'.tr(),
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.7),
          height: 1.5,
          fontSize:
              isSmallScreen
                  ? 16
                  : isMediumScreen
                  ? 17
                  : 18,
        ),
        textAlign: TextAlign.center,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
    );

    return widget.showAnimation
        ? messageWidget.animate(delay: 400.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2, duration: 600.ms, curve: Curves.easeOut)
        : messageWidget;
  }

  Widget _buildRetryButton(Color primaryColor, bool isSmallScreen, bool isMediumScreen) {
    final buttonWidget = SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed:
            _isRetrying
                ? null
                : () async {
                  setState(() => _isRetrying = true);

                  // Add a small delay to show the loading state
                  await Future.delayed(const Duration(milliseconds: 300));

                  widget.onRetry!();

                  if (mounted) {
                    setState(() => _isRetrying = false);
                  }
                },
        icon:
            _isRetrying
                ? SizedBox(
                  width: isSmallScreen ? 18 : 20,
                  height: isSmallScreen ? 18 : 20,
                  child: const CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                )
                : Icon(Icons.refresh_rounded, size: isSmallScreen ? 20 : 22),
        label: Text(
          _isRetrying ? 'retry_loading'.tr() : (widget.retryButtonText ?? 'retry_button'.tr()),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize:
                isSmallScreen
                    ? 16
                    : isMediumScreen
                    ? 17
                    : 18,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: primaryColor.withOpacity(0.7),
          padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 28 : 36, vertical: isSmallScreen ? 16 : 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: _isRetrying ? 2 : 6,
          shadowColor: primaryColor.withOpacity(0.3),
        ),
      ),
    );

    return widget.showAnimation
        ? buttonWidget
            .animate(delay: 600.ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.2, duration: 600.ms, curve: Curves.easeOut)
            .then()
            .shimmer(duration: 1500.ms, color: Colors.white.withOpacity(0.3))
        : buttonWidget;
  }

  Widget _buildHelpText(ThemeData theme, bool isSmallScreen) {
    final helpWidget = Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.help_outline_rounded, size: isSmallScreen ? 16 : 18, color: theme.colorScheme.onSurface.withOpacity(0.5)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'help_text'.tr(),
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: isSmallScreen ? 14 : 15),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );

    return widget.showAnimation ? helpWidget.animate(delay: 800.ms).fadeIn(duration: 600.ms) : helpWidget;
  }
}

// Usage Examples:

// Basic usage
class BasicServerErrorExample extends StatelessWidget {
  const BasicServerErrorExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ServerErrorWidget(
          onRetry: () {
            print('Retrying...');
          },
        ),
      ),
    );
  }
}

// Customized usage
class CustomServerErrorExample extends StatelessWidget {
  const CustomServerErrorExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ServerErrorWidget(
          title: 'Network Error',
          message: 'Unable to connect to our servers.\nCheck your internet connection and try again.',
          retryButtonText: 'Reconnect',
          primaryColor: Colors.indigo,
          backgroundColor: Colors.grey[50],
          iconSize: 160,
          onRetry: () {
            print('Reconnecting...');
          },
        ),
      ),
    );
  }
}

// Full screen error page
class FullScreenServerError extends StatelessWidget {
  const FullScreenServerError({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: ServerErrorWidget(
          title: 'Something went wrong',
          message: "Our servers are temporarily unavailable.\nWe're working to fix this issue.",
          retryButtonText: 'Refresh',
          primaryColor: Theme.of(context).colorScheme.error,
          onRetry: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

// Card format with custom styling
class CardServerErrorExample extends StatelessWidget {
  const CardServerErrorExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My App')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 12,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ServerErrorWidget(
            title: 'Data Unavailable',
            message: "We couldn't load your content.\nPlease try again.",
            retryButtonText: 'Reload',
            primaryColor: Colors.deepPurple,
            onRetry: () {
              print('Reloading data...');
            },
          ),
        ),
      ),
    );
  }
}
