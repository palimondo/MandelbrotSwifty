// Zip (Zip2Sequence)

public typealias _Zip2Iterator<S1: Sequence, S2: Sequence> = (S1.Iterator, S2.Iterator)
public typealias _ZippedElement<S1: Sequence, S2: Sequence> = (S1.Iterator.Element, S2.Iterator.Element)

public func _zip<S1: Sequence, S2: Sequence>(_ s1: S1, _ s2: S2) -> UnfoldSequence<_ZippedElement<S1, S2>, _Zip2Iterator<S1, S2>> {
    return sequence(state: (s1.makeIterator(), s2.makeIterator()), next: {
        (state: inout _Zip2Iterator<S1, S2>) -> _ZippedElement<S1, S2>? in
        guard
            let e1 = state.0.next(),
            let e2 = state.1.next()
            else { return nil }
        return (e1, e2)
    })
}

public func __zip<S1: Sequence, S2: Sequence>(_ s1: S1, _ s2: S2) -> UnfoldSequence<_ZippedElement<S1, S2>, _Zip2Iterator<S1, S2>> {
    func zipNext(state: inout _Zip2Iterator<S1, S2>) -> _ZippedElement<S1, S2>? {
        guard
            let e1 = state.0.next(),
            let e2 = state.1.next()
            else { return nil }
        return (e1, e2)
    }
    return sequence(state: (s1.makeIterator(), s2.makeIterator()), next: zipNext)
}


public func ___zip<S1: Sequence, S2: Sequence>(_ s1: S1, _ s2: S2) -> _AnyIterator<(S1.Iterator.Element, S2.Iterator.Element)> {
    var i1 = s1.makeIterator()
    var i2 = s2.makeIterator()
    return _AnyIterator {
        guard let e1 = i1.next(), let e2 = i2.next()
            else { return nil }
        return (e1, e2)
    }
}
