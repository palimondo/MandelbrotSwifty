// How many core Iterators/Sequences can be implemented as UnfoldSequence? At what performance costs?

let xs = ["a", "b", "c"]
let ys = stride(from: 4, through: 1, by: -1)
let zs: Array<Int> = []
Array(ys)

/*
// Enumerator (EnumeratedSequence)
xs.enumerated()
let e = Array(xs.enumerated())
e[1].offset
e[1].element

extension Sequence {
    
    public typealias _EnumeratedIterator = (count: Int, iterator: Self.Iterator)
    public typealias _EnumeratedElement = (offset: Int, element: Self.Iterator.Element)
    
    public func _enumerated () ->
        UnfoldSequence<_EnumeratedElement, _EnumeratedIterator> {
            return sequence(state: (0, makeIterator()), next: {
                (state: inout _EnumeratedIterator) -> _EnumeratedElement? in
                guard let element = state.iterator.next() else { return nil }
                defer { state.count += 1 }
                return (state.count, element)
            })
    }

    public func __enumerated () ->
        UnfoldSequence<_EnumeratedElement, _EnumeratedIterator> {
            func enumerateNext(state: inout _EnumeratedIterator) -> _EnumeratedElement? {
                guard let element = state.iterator.next() else { return nil }
                defer { state.count += 1 }
                return (state.count, element)
            }
            return sequence(state: (0, makeIterator()), next: enumerateNext)
    }
}

xs._enumerated()
let ee = Array(xs._enumerated())

xs.__enumerated()
let eee = Array(xs.__enumerated())
 
 */
/*
// Zip (Zip2Sequence)
let z = zip(xs, ys)
Array(zip(xs, ys))
Array(zip(xs, zs))

public typealias _Zip2Iterator<S1: Sequence, S2: Sequence> = (S1.Iterator, S2.Iterator)
public typealias _ZippedElement<S1: Sequence, S2: Sequence> = (S1.Iterator.Element, S2.Iterator.Element)

public func _zip<S1: Sequence, S2: Sequence>(_ s1: S1, _ s2: S2) -> UnfoldSequence<_ZippedElement<S1, S2>, _Zip2Iterator<S1, S2>> {
    return sequence(state: (s1.makeIterator(), s2.makeIterator()), next: {
        (state: inout _Zip2Iterator<S1, S2>) -> _ZippedElement<S1, S2>? in
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

public func __zip<S1: Sequence, S2: Sequence>(_ s1: S1, _ s2: S2) -> UnfoldSequence<_ZippedElement<S1, S2>, _Zip2Iterator<S1, S2>> {
    func zipNext(state: inout _Zip2Iterator<S1, S2>) -> _ZippedElement<S1, S2>? {
        guard
            let e1 = state.0.next(),
            let e2 = state.1.next() else {
                return nil
        }
        return (e1, e2)
    }
    return sequence(state: (s1.makeIterator(), s2.makeIterator()), next: zipNext)
}

let zzz = __zip(xs, ys)
Array(__zip(xs, ys))
Array(__zip(xs, zs))
*/

/*
// Prefix
let p = ys.prefix(2)
Array(p)

func take<S : Sequence>(_ count: Int, source: S) -> AnyIterator<S.Iterator.Element> {
    var i = 0
    var g = source.makeIterator()
    
    return AnyIterator {
        defer { i += 1 }
        return (i < count) ? g.next() : .none
    }
}

Array(take(2, source: ys))

extension Sequence {
    
    public typealias _EnumeratedIterator = (count: Int, iterator: Iterator)
    
    public func _prefix(_ maxLength: Int) ->
        UnfoldSequence<Iterator.Element, _EnumeratedIterator> {
            return sequence(state: (maxLength, makeIterator()), next: {
                (state: inout _EnumeratedIterator) -> Iterator.Element? in
                defer { state.count -= 1 }
                return (state.count > 0) ? state.iterator.next() : nil
            })
    }
    
    public func __prefix(_ maxLength: Int) ->
        UnfoldSequence<Iterator.Element, _EnumeratedIterator> {
            func countDownNext(state: inout _EnumeratedIterator) -> Iterator.Element? {
                defer { state.count -= 1 }
                return (state.count > 0) ? state.iterator.next() : nil
            }
            return sequence(state: (maxLength, makeIterator()), next: countDownNext)
    }
}

ys._prefix(2)
let pp = Array(ys._prefix(2))
Array(zs._prefix(2))

ys.__prefix(2)
let ppp = Array(ys.__prefix(2))
Array(zs.__prefix(2))
*/

// Prefix While (PrefixWhileSequence)

// Drop First

Array(ys.dropFirst(2))
/*
 while _dropped < _limit {
 if _iterator.next() == nil {
 _dropped = _limit
 return nil
 }
 _dropped += 1
 }
 return _iterator.next()
 
 // from map<T> -- could be useful for ring buffer?
 
 let initialCapacity = underestimatedCount
 var result = ContiguousArray<T>()
 result.reserveCapacity(initialCapacity)
 
*/
extension Sequence {
    
    public typealias _EnumeratedIterator = (count: Int, iterator: Iterator)
    
    public func _dropFirst(_ n: Int) ->
        UnfoldSequence<Iterator.Element, _EnumeratedIterator> {
            return sequence(state: (n, makeIterator()), next: {
                (state: inout _EnumeratedIterator) -> Iterator.Element? in
                while state.count > 0 {
                    guard state.iterator.next() != nil else { return nil }
                    state.count -= 1
                }
                return state.iterator.next()
            })
    }
    
    public func __dropFirst(_ n: Int) ->
        UnfoldSequence<Iterator.Element, _EnumeratedIterator> {
            func dropNext(state: inout _EnumeratedIterator) -> Iterator.Element? {
                while state.count > 0 {
                    guard state.iterator.next() != nil else { return nil }
                    state.count -= 1
                }
                return state.iterator.next()
            }
            return sequence(state: (n, makeIterator()), next: dropNext)
    }
}
Array(ys._dropFirst(2))
Array(ys.__dropFirst(2))

// Drop While

// Stride ??
