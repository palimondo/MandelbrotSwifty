enum SeqOp {
    case Prefix, DropFirst, Enumerated, DropWhile
}

private struct NextMethod<Iterator: IteratorProtocol> {
    init(for: Iterator) {}
    
    typealias _EnumeratedElement = (offset: Int, element: Iterator.Element)
    typealias _CountingIterator = (count: Int, iterator: Iterator)
    typealias _CountingSequence = ComposedSequence<Iterator.Element, _CountingIterator>
    
    func prefix(state: inout _CountingIterator) -> Iterator.Element? {
        defer { state.count = state.count &- 1 }
        return (state.count > 0) ? state.iterator.next() : nil
    }
    
    func dropFirst(state: inout _CountingIterator) -> Iterator.Element? {
        while state.count > 0 {
            guard state.iterator.next() != nil else { return nil }
            state.count = state.count &- 1
        }
        return state.iterator.next()
    }
    
    func enumerated(state: inout _CountingIterator) -> _EnumeratedElement? {
        guard let element = state.iterator.next() else { return nil }
        defer { state.count += 1 }
        return (state.count, element)
    }
    
    func dropWhile(state: inout DropWhileIterator<Iterator>) -> Iterator.Element? {
        guard state.predicateHasFailed else {
            while let nextElement = state.iterator.next() {
                guard state.predicate(nextElement) else {
                    state.predicateHasFailed = true
                    return nextElement
                }
            }
            return nil // exhausted underlying sequence
        }
        return state.iterator.next()
    }
}

public struct DropWhileIterator<I: IteratorProtocol> {
    var predicateHasFailed: Bool
    var predicate: (I.Element) -> Bool
    var iterator: I
    init(_ _predicateHasFailed: Bool, _ _predicate: @escaping (I.Element) -> Bool, _ _iterator: I) {
        predicateHasFailed = _predicateHasFailed
        predicate = _predicate
        iterator = _iterator
    }
}

public struct ComposedSequence<Element, State> : Sequence, IteratorProtocol {
    public mutating func next() -> Element? {
        guard !_done else { return nil }
        if let elt = _next(&_state) {
            return elt
        } else {
            _done = true
            return nil
        }
    }
    
    init(_ type: SeqOp, _ state: State, _ next: @escaping (inout State) -> Element?) {
        _type = type
        _state = state
        _next = next
    }
    
    let _type: SeqOp
    var _state: State
    let _next: (inout State) -> Element?
    var _done = false
    
    static func foo<T>(x: T, y: State, z: Element) -> ComposedSequence<Element, State> {
        return ComposedSequence(.Prefix, y, {_ in return z})
    }

    static func prefix<I : IteratorProtocol>(_ prefix: Int, _ iterator: I) -> ComposedSequence<I.Element, (count: Int, iterator: I)> {
        return ComposedSequence<I.Element, (count: Int, iterator: I)>(.Prefix, (prefix, iterator), NextMethod(for:iterator).prefix)
    }
    static func dropFirst<I : IteratorProtocol>(_ n: Int, _ iterator: I) -> ComposedSequence<I.Element, (count: Int, iterator: I)> {
        return ComposedSequence<I.Element, (count: Int, iterator: I)>(.DropFirst, (n, iterator), NextMethod(for:iterator).dropFirst)
    }
    static func enumerated<I : IteratorProtocol>(_ iterator: I) -> ComposedSequence<(offset: Int, element: I.Element), (count: Int, iterator: I)> {
        return ComposedSequence<(offset: Int, element: I.Element), (count: Int, iterator: I)>(.Enumerated, (0, iterator), NextMethod(for:iterator).enumerated)
    }
    static func drop<I : IteratorProtocol>(while predicate: @escaping (I.Element) -> Bool, _ iterator: I) -> ComposedSequence<I.Element, DropWhileIterator<I>>  {
        return ComposedSequence<I.Element, DropWhileIterator<I>>(.DropWhile, DropWhileIterator(false, predicate, iterator), NextMethod(for:iterator).dropWhile)
    }
}

extension Sequence {
    public typealias _EnumeratedIterator = (count: Int, iterator: Iterator)
    public typealias _EnumeratedElement = (offset: Int, element: Iterator.Element)
    public typealias _CountingSequence = ComposedSequence<Iterator.Element, _EnumeratedIterator>
    public typealias _DropWhileSequence = ComposedSequence<Iterator.Element, DropWhileIterator<Iterator>>
    public typealias _Predicate = (Iterator.Element) -> Bool
    
    typealias _Compose = ComposedSequence<Any, Any>
    
    public func _enumerated() -> ComposedSequence<_EnumeratedElement, _EnumeratedIterator> {
        return _Compose.enumerated(makeIterator())
    }
    
    public func _dropFirst(_ n: Int) -> _CountingSequence {
        return _Compose.dropFirst(n, makeIterator())
    }
    
    public func _prefix(_ n: Int) -> _CountingSequence {
        return _Compose.prefix(n, makeIterator())
}
    
    public func _drop(while predicate: @escaping _Predicate) -> _DropWhileSequence {
        return _Compose.drop(while: predicate, makeIterator())
    }
}

let ys = [1, 2, 3]
ys._prefix(1)._prefix(1)

ys._enumerated()
Array(ys._enumerated())
ys._dropFirst(1)
Array(ys._dropFirst(1))
ys._prefix(2)
Array(ys._prefix(2))
ys._drop(while:{$0 < 2})
let predicate: (Int) -> Bool = {$0 < 2}
Array(ys._drop(while:predicate))
