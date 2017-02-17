// Prefix While (PrefixWhileSequence)

extension Sequence {
    // Not to spec: missing throwing, noescape
    public func _prefix (
        while predicate: @escaping (Self.Iterator.Element) -> Bool) ->
        UnfoldSequence<Self.Iterator.Element, Self.Iterator> {
            return sequence(state: makeIterator(), next: {
                (myState: inout Iterator) -> Iterator.Element? in
                guard let next = myState.next() else { return nil }
                return predicate(next) ? next : nil
            })
    }
    
    public typealias Predicate = (Self.Iterator.Element) -> Bool
    public typealias PredicatedIterator = (predicate: Predicate, iterator: Self.Iterator)
    
    public func __prefix (while predicate: @escaping Predicate) ->
        UnfoldSequence<Self.Iterator.Element, PredicatedIterator> {
            func nextMatch(state: inout PredicatedIterator) -> Iterator.Element? {
                guard
                    let e = state.iterator.next()
                    else { return nil }
                return state.predicate(e) ? e : nil
            }
            return sequence(state: (predicate, makeIterator()), next: nextMatch)
    }
    
    internal func nextMatch(state: inout PredicatedIterator) -> Iterator.Element? {
        guard
            let e = state.iterator.next()
            else { return nil }
        return state.predicate(e) ? e : nil
    }
    
    
    public func ___prefix (while predicate: @escaping Predicate) ->
        UnfoldSequence<Self.Iterator.Element, PredicatedIterator> {
            return sequence(state: (predicate, makeIterator()), next: nextMatch)
    }
}

let pw = Array(ys._prefix(while: {$0 > 2}))
let ppw = Array(ys.__prefix(while: {$0 > 2}))
let pppw = Array(ys.___prefix(while: {$0 > 2}))