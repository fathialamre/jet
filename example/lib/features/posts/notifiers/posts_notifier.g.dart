// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postsNotifierHash() => r'7592274e6d303eb5525c6de49297323f84fbd535';

/// See also [postsNotifier].
@ProviderFor(postsNotifier)
final postsNotifierProvider =
    AutoDisposeFutureProvider<List<PostResponse>>.internal(
      postsNotifier,
      name: r'postsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$postsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PostsNotifierRef = AutoDisposeFutureProviderRef<List<PostResponse>>;
String _$postDetailsHash() => r'9bbd9ea6d03985facf1f77216a85c80c8ac66ab6';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [postDetails].
@ProviderFor(postDetails)
const postDetailsProvider = PostDetailsFamily();

/// See also [postDetails].
class PostDetailsFamily extends Family<AsyncValue<PostResponse>> {
  /// See also [postDetails].
  const PostDetailsFamily();

  /// See also [postDetails].
  PostDetailsProvider call(int id) {
    return PostDetailsProvider(id);
  }

  @override
  PostDetailsProvider getProviderOverride(
    covariant PostDetailsProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'postDetailsProvider';
}

/// See also [postDetails].
class PostDetailsProvider extends AutoDisposeFutureProvider<PostResponse> {
  /// See also [postDetails].
  PostDetailsProvider(int id)
    : this._internal(
        (ref) => postDetails(ref as PostDetailsRef, id),
        from: postDetailsProvider,
        name: r'postDetailsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$postDetailsHash,
        dependencies: PostDetailsFamily._dependencies,
        allTransitiveDependencies: PostDetailsFamily._allTransitiveDependencies,
        id: id,
      );

  PostDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<PostResponse> Function(PostDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostDetailsProvider._internal(
        (ref) => create(ref as PostDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PostResponse> createElement() {
    return _PostDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostDetailsProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PostDetailsRef on AutoDisposeFutureProviderRef<PostResponse> {
  /// The parameter `id` of this provider.
  int get id;
}

class _PostDetailsProviderElement
    extends AutoDisposeFutureProviderElement<PostResponse>
    with PostDetailsRef {
  _PostDetailsProviderElement(super.provider);

  @override
  int get id => (origin as PostDetailsProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
