func takeWhile<S : Sequence>(_ includeElement: @escaping (S.Iterator.Element) -> Bool, source: S) ->  AnyIterator<S.Iterator.Element> {
    var takeMore = true
    var g = source.makeIterator()
    
    return AnyIterator {
        if takeMore {
            if let e = g.next() {
                takeMore = includeElement(e)
                return takeMore ? e : .none
            }
        }
        return .none
    }
}

func _takeWhile<S : Sequence>(
    _ includeElement: @escaping (S.Iterator.Element) -> Bool,
    source: S
    ) ->  AnyIterator<S.Iterator.Element> {
    var takeMore = true
    var it = source.makeIterator()
    
    return AnyIterator {
        guard takeMore, let e = it.next() else { return nil }
        takeMore = includeElement(e)
        return takeMore ? e : nil
    }
}

func takeWhile_<S: Sequence>(while predicate: @escaping (S.Element) -> Bool, seq: S) -> AnySequence<S.Element> {
    return AnySequence(sequence(state: PredicatedIterator(predicate, seq.makeIterator()), next: {
        (state: inout PredicatedIterator) -> S.Element? in
        guard let e = state.iterator.next() else { return nil }
        return state.predicate(e) ? e : nil
    }))
}

func takeWhile__<S: Sequence>(
    while predicate: @escaping (S.Element) -> Bool,
    seq: S
    ) -> UnfoldSequence<S.Element, PredicatedIterator<S.Iterator>> {
    return sequence(
        state: PredicatedIterator(predicate, seq.makeIterator()),
        next: { (state: inout PredicatedIterator) -> S.Element? in
            guard let e = state.iterator.next() else { return nil }
            return state.predicate(e) ? e : nil
    })
}

func take<S : Sequence>(_ count: Int, source: S) -> AnyIterator<S.Iterator.Element> {
    var i = 0
    var g = source.makeIterator()
    
    return AnyIterator {
        defer {i += 1;}
        return (i < count) ? g.next() : .none
    }
}

public func take_<S: Sequence>(_ maxLength: Int, seq: S) -> AnySequence<S.Element> {
    return AnySequence(sequence(state: (maxLength, seq.makeIterator()), next: {
        (state: inout (count: Int, iterator: S.Iterator)) -> S.Element? in
        defer { state.count -= 1 }
        return (state.count > 0) ? state.iterator.next() : nil
    }))
}

public func take__<S: Sequence>(_ maxLength: Int, seq: S) -> UnfoldSequence<S.Element, (count: Int, iterator: S.Iterator)> {
    return sequence(state: (maxLength, seq.makeIterator()), next: {
        (state: inout (count: Int, iterator: S.Iterator)) -> S.Element? in
        defer { state.count -= 1 }
        return (state.count > 0) ? state.iterator.next() : nil
    })
}

@_specialize(where A == Int)
func iterate<A>(_ f: @escaping (A) -> A, x0: A) -> AnyIterator<A> {
    var x = x0
    return AnyIterator {
        defer {x = f(x)}
        return x
    }
}

func curry<A,B,R>(_ f: @escaping (A,B) -> R) -> (A) -> (B) -> R {
    return { a in { b in f(a,b) } }
}

func length<S: Sequence>(_ sequence: S) -> Int {
    return sequence.reduce(0, {i, _ in i + 1})
}

infix operator >>> : MultiplicationPrecedence // associativity: left
func >>> <A, B, C>(f: @escaping (B) -> C, g: @escaping (A) -> B) -> (A) -> C {
    return { x in f(g(x)) }
}

