// How many core Iterators/Sequences can be implemented as UnfoldSequence? At what performance costs?

let xs = ["a", "b", "c"]
let ys = [4, 3, 2, 1]
let zs: Array<Int> = []

// Enumerator (EnumeratedSequence)
let e = Array(xs.enumerated())

extension Sequence {
    public func _enumerated () -> 
        UnfoldSequence<(Int, Self.Iterator.Element), (count: Int, iterator: Self.Iterator)> {
            return sequence(state: (0, makeIterator()), next: {
                (state: inout (count: Int, iterator: Self.Iterator)) -> (Int, Self.Iterator.Element)? in
                guard let element = state.iterator.next() else { return nil }
                defer { state.count += 1 }
                return (offset: state.count, element: element)
            })
    }
}
xs._enumerated()
let ee = Array(xs._enumerated())

extension Sequence {
    public func __enumerated () -> 
        AnySequence<(Int, Self.Iterator.Element)> {
            return AnySequence(sequence(state: (0, makeIterator()), next: {
                (state: inout (count: Int, iterator: Self.Iterator)) -> (Int, Self.Iterator.Element)? in
                guard let element = state.iterator.next() else { return nil }
                defer { state.count += 1 }
                return (offset: state.count, element: element)
            }))
    }
}
xs.__enumerated()
let eee = Array(xs.__enumerated())

// Zip (Zip2Sequence)
let z = zip(xs, ys)
Array(zip(xs, ys))
Array(zip(xs, zs))

public func _zip<S1: Sequence, S2: Sequence>(_ s1: S1, _ s2: S2) -> UnfoldSequence<(S1.Iterator.Element, S2.Iterator.Element), (S1.Iterator, S2.Iterator)> {
    return sequence(state: (s1.makeIterator(), s2.makeIterator()), next: { (state: inout (S1.Iterator, S2.Iterator)) -> (S1.Iterator.Element, S2.Iterator.Element)? in
        guard let e1 = state.0.next(),
            let e2 = state.1.next() else {
                return nil
        }
        return (e1, e2)
    })
}
let zz = _zip(xs, ys)
Array(_zip(xs, ys))
Array(_zip(xs, zs))

public func __zip<S1: Sequence, S2: Sequence>(_ s1: S1, _ s2: S2) -> AnySequence<(S1.Iterator.Element, S2.Iterator.Element)> {
    return AnySequence(sequence(state: (s1.makeIterator(), s2.makeIterator()), next: { (state: inout (S1.Iterator, S2.Iterator)) -> (S1.Iterator.Element, S2.Iterator.Element)? in
        guard let e1 = state.0.next(),
            let e2 = state.1.next() else {
                return nil
        }
        return (e1, e2)
    }))
}
let zzz = __zip(xs, ys)
Array(__zip(xs, ys))
Array(__zip(xs, zs))

// Prefix

// Prefix While (PrefixWhileSequence)

// Drop First ?!?!

// Drop

// Drop While
