import 'package:dart_kollection/dart_kollection.dart';
import 'package:test/test.dart';

import '../test/assert_dart.dart';

void main() {
  group("mutableSet", () {
    testMutableSet(
      <T>([arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9]) =>
          mutableSetOf(
              arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9),
      <T>(iterable) => mutableSetFrom(iterable),
    );
  });
  group("KMutableSet", () {
    testMutableSet(
      <T>([arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9]) =>
          KMutableSet.of(
              arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9),
      <T>(iterable) => KMutableSet.from(iterable),
    );
  });
  group("KHashSet", () {
    testMutableSet(
      <T>([arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9]) =>
          KHashSet.of(
              arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9),
      <T>(iterable) => KHashSet.from(iterable),
      ordered: false,
    );
  });
  group("KLinkedSet", () {
    testMutableSet(
      <T>([arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9]) =>
          KLinkedSet.of(
              arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9),
      <T>(iterable) => KLinkedSet.from(iterable),
    );
  });
}

void testMutableSet(
    KMutableSet<T> Function<T>(
            [T arg0,
            T arg1,
            T arg2,
            T arg3,
            T arg4,
            T arg5,
            T arg6,
            T arg7,
            T arg8,
            T arg9])
        mutableSetOf,
    KMutableSet<T> Function<T>(Iterable<T> iterable) mutableSetFrom,
    {bool ordered = true}) {
  test("mutableSetOf automatically removes duplicates", () {
    final set = mutableSetOf("a", "b", "a", "c");
    expect(set.size, 3);
  });

  test("hashSetOf automatically removes duplicates", () {
    final set = hashSetOf("a", "b", "a", "c");
    expect(set.size, 3);
  });

  if (ordered) {
    test("mutableSetOf iterates in order as specified", () {
      final set = mutableSetOf("a", "b", "c");
      final iterator = set.iterator();
      expect(iterator.hasNext(), isTrue);
      expect(iterator.next(), "a");
      expect(iterator.hasNext(), isTrue);
      expect(iterator.next(), "b");
      expect(iterator.hasNext(), isTrue);
      expect(iterator.next(), "c");
      expect(iterator.hasNext(), isFalse);
      final e = catchException(() => iterator.next());
      expect(e, TypeMatcher<NoSuchElementException>());
    });
  } else {
    test("throws at end", () {
      final set = mutableSetOf("a", "b", "c");
      final iterator = set.iterator();
      expect(iterator.hasNext(), isTrue);
      iterator.next();
      expect(iterator.hasNext(), isTrue);
      iterator.next();
      expect(iterator.hasNext(), isTrue);
      iterator.next();
      expect(iterator.hasNext(), isFalse);
      final e = catchException(() => iterator.next());
      expect(e, TypeMatcher<NoSuchElementException>());
    });
  }

  test("using the internal dart set allows mutation - empty", () {
    final kset = mutableSetOf();
    expect(kset.isEmpty(), isTrue);
    kset.set.add("asdf");
    // unchanged
    expect(kset.isEmpty(), isFalse);
    expect(kset, setOf("asdf"));
  });

  test("using the internal dart set allows mutation", () {
    final kset = mutableSetOf("a");
    expect(kset, setOf("a"));
    kset.set.add("b");
    // unchanged
    expect(kset, setOf("a", "b"));
  });

  test("clear", () {
    final list = mutableSetOf(["a", "b", "c"]);
    list.clear();
    expect(list.isEmpty(), isTrue);
  });

  group("remove", () {
    test("remove item when found", () {
      final list = mutableSetOf("a", "b", "c");
      final result = list.remove("b");
      expect(list, setOf("a", "c"));
      expect(result, isTrue);
    });
    test("don't remove item when not found", () {
      final list = mutableSetOf("a", "b", "c");
      final result = list.remove("x");
      expect(list, setOf("a", "b", "c"));
      expect(result, isFalse);
    });
  });

  group("removeAll", () {
    test("remove item when found", () {
      final list = mutableSetOf("paul", "john", "max", "lisa");
      final result = list.removeAll(listOf("paul", "max"));
      expect(list, setOf("john", "lisa"));
      expect(result, isTrue);
    });
    test("remove only found when found", () {
      final list = mutableSetOf("paul", "john", "max", "lisa");
      final result = list.removeAll(listOf("paul", "max", "tony"));
      expect(list, setOf("john", "lisa"));
      expect(result, isTrue);
    });

    test("removeAll requires elements to be non null", () {
      final e =
          catchException<ArgumentError>(() => mutableSetOf().removeAll(null));
      expect(e.message, allOf(contains("null"), contains("elements")));
    });
  });
}
