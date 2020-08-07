import '../../ordering.dart';

class NullsLastOrdering<T> extends Ordering<T?> {
  final Ordering<T> ordering;

  const NullsLastOrdering(this.ordering);

  @override
  int compare(T? a, T? b) {
    if (a == null) {
      return 1;
    } else if (b == null) {
      return -1;
    } else {
      return ordering.compare(a, b);
    }
  }

  @override
  Ordering<T?> get reversed => ordering.reversed.nullsFirst;

  @override
  Ordering<T?> get nullsFirst => ordering.nullsFirst;

  @override
  Ordering<T?> get nullsLast => this;
}
