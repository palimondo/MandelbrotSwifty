// Prefix While (PrefixWhileSequence)

public struct PredicatedIterator<I: IteratorProtocol> {
    var predicate: (I.Element) -> Bool
    var iterator: I
    init(_ _predicate: @escaping (I.Element) -> Bool, _ _iterator: I) {
        predicate = _predicate
        iterator = _iterator
    }
}

extension Sequence {
    /// Prefix defined with `sequence` and predicate captured in the inline closure
    public func _prefix (
        while predicate: @escaping (Self.Iterator.Element) -> Bool) ->
        UnfoldSequence<Self.Iterator.Element, Self.Iterator> {
            return sequence(state: makeIterator(), next: {
                (myState: inout Iterator) -> Iterator.Element? in
                guard let next = myState.next() else { return nil }
                return predicate(next) ? next : nil
            })
    }
    
    public typealias Predicate = (Iterator.Element) -> Bool
//    public typealias PredicatedIterator = (predicate: Predicate, iterator: Self.Iterator)
    
    /// Prefix defined with `sequence`, inlined closure and predicate stored in `PredicatedIterator`
    public func __prefix (while predicate: @escaping Predicate) ->
        UnfoldSequence<Self.Iterator.Element, PredicatedIterator<Iterator>> {
            return sequence(state: PredicatedIterator(predicate, makeIterator()), next: {
                (state: inout PredicatedIterator<Iterator>) -> Iterator.Element? in
                guard let e = state.iterator.next() else { return nil }
                return state.predicate(e) ? e : nil
            })
    }

    private func nextMatch(state: inout PredicatedIterator<Iterator>) -> Iterator.Element? {
        guard let e = state.iterator.next() else { return nil }
        return state.predicate(e) ? e : nil
    }
    /// Prefix defined with `PredicatedIterator` and `nextMatch` function
    public func ___prefix (while predicate: @escaping Predicate) ->
        UnfoldSequence<Self.Iterator.Element, PredicatedIterator<Iterator>> {
            return sequence(state: PredicatedIterator(predicate, makeIterator()), next: nextMatch)
    }

    /// Prefix defined with inline `_AnyIterator`
    public func ____prefix (while predicate: @escaping Predicate) ->
        _AnyIterator<Iterator.Element> {
            var iterator = makeIterator()
            return _AnyIterator {
                guard let e = iterator.next() else { return nil }
                return predicate(e) ? e : nil
            }
    }
}
