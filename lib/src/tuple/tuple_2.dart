library more.tuple.tuple_2;

import 'package:more/tuple.dart';

/// Tuple with 2 elements.
class Tuple2<T0, T1> extends Tuple {
  final T0 value0;
  final T1 value1;

  const Tuple2(this.value0, this.value1);

  static Tuple2<T, T> fromList<T>(List<T> list) => Tuple2(list[0], list[1]);

  @override
  int get length => 2;

  Tuple2<T, T1> with0<T>(T value) => Tuple2(value, value1);

  Tuple2<T0, T> with1<T>(T value) => Tuple2(value0, value);

  @override
  Tuple3<T, T0, T1> addFirst<T>(T value) => addAt0(value);

  @override
  Tuple3<T0, T1, T> addLast<T>(T value) => addAt2(value);

  Tuple3<T, T0, T1> addAt0<T>(T value) => Tuple3(value, value0, value1);

  Tuple3<T0, T, T1> addAt1<T>(T value) => Tuple3(value0, value, value1);

  Tuple3<T0, T1, T> addAt2<T>(T value) => Tuple3(value0, value1, value);

  @override
  Tuple1<T1> removeFirst() => removeAt0();

  @override
  Tuple1<T0> removeLast() => removeAt1();

  Tuple1<T1> removeAt0() => Tuple1(value1);

  Tuple1<T0> removeAt1() => Tuple1(value0);

  @override
  Iterable get iterable sync* {
    yield value0;
    yield value1;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tuple2 && value0 == other.value0 && value1 == other.value1);

  @override
  int get hashCode => 376088004 ^ value0.hashCode ^ value1.hashCode;
}
