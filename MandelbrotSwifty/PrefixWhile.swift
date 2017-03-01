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
    
    public func __prefix (while predicate: @escaping Predicate) ->
        UnfoldSequence<Self.Iterator.Element, PredicatedIterator<Iterator>> {
            return sequence(state: PredicatedIterator(predicate, makeIterator()), next: {
                (state: inout PredicatedIterator<Iterator>) -> Iterator.Element? in
                guard let e = state.iterator.next() else { return nil }
                return state.predicate(e) ? e : nil
            })
    }

    internal func nextMatch(state: inout PredicatedIterator<Iterator>) -> Iterator.Element? {
        guard let e = state.iterator.next() else { return nil }
        return state.predicate(e) ? e : nil
    }
    
    public func ___prefix (while predicate: @escaping Predicate) ->
        UnfoldSequence<Self.Iterator.Element, PredicatedIterator<Iterator>> {
            return sequence(state: PredicatedIterator(predicate, makeIterator()), next: nextMatch)
    }

    public func ____prefix (while predicate: @escaping Predicate) ->
        _AnyIterator<Iterator.Element> {
            var iterator = makeIterator()
            return _AnyIterator {
                guard let e = iterator.next() else { return nil }
                return predicate(e) ? e : nil
            }
    }
}
