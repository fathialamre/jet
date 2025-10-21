/// Loading style types for controlling how loading states are displayed
///
/// This enum provides different strategies for showing loading states in your app.
///
/// Example usage:
/// ```dart
/// JetBuilder.list(
///   context: context,
///   provider: postsProvider,
///   loadingStyle: LoadingStyle.skeleton,
///   itemBuilder: (post, index) => PostCard(post: post),
/// )
/// ```
enum LoadingStyle {
  /// Shows the default loading indicator (CircularProgressIndicator)
  ///
  /// This is the standard Flutter loading indicator that appears
  /// centered on the screen during loading states.
  normal,

  /// Shows skeleton loading animation
  ///
  /// Displays a skeleton version of your UI with shimmer/pulse effects
  /// to give users a preview of the content structure while loading.
  /// Requires the skeletonizer package.
  skeleton,

  /// Shows no loading indicator
  ///
  /// The widget will show nothing (or content) during loading states.
  /// Useful when you want to handle loading states manually or when
  /// the content itself handles the loading state.
  none,
}
