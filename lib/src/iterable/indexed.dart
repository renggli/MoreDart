library more.iterable.indexed;

/// Returns a [Indexed] iterable
///
/// By default the index is zero based, but an arbitrary [offset] can be
/// provided.
///
/// For example, the expression
///
///     indexed(['a', 'b'], offset: 1)
///       .map((each) => '${each.value}-${each.index}')
///       .join(', ');
///
/// returns
///
///     'a-1, b-2'
///
Iterable<Indexed<E>> indexed<E>(Iterable<E> elements, {int offset = 0}) sync* {
  for (var element in elements) {
    yield Indexed<E>(offset++, element);
  }
}

/// An indexed value.
class Indexed<E> {
  /// The index of the value in the iterable.
  final int index;

  /// The actual value.
  final E value;

  Indexed(this.index, this.value);

  @override
  String toString() => '$index: $value';
}
