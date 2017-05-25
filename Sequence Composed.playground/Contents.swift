public struct PredicatedIterator<I: IteratorProtocol> {
    var predicateHasFailed: Bool
    let predicate: (I.Element) -> Bool
    var iterator: I
    init(_ _predicateHasFailed: Bool, _ _predicate: @escaping (I.Element) -> Bool, _ _iterator: I) {
        predicateHasFailed = _predicateHasFailed
        predicate = _predicate
        iterator = _iterator
    }
}

public struct ComposedSequence<Element, State> : Sequence, IteratorProtocol {
    enum SeqOp {
        case Prefix, DropFirst, Enumerated, DropWhile, PrefixWhile
    }

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
    
    init<I : IteratorProtocol>(prefix: Int, _ iterator: I) where Element == I.Element, State == (count: Int, iterator: I) {
        func _prefix(state: inout State) -> Element? {
            defer { state.count = state.count &- 1 }
            return (state.count > 0) ? state.iterator.next() : nil
        }
        self.init(.Prefix, (prefix, iterator), _prefix)
    }
    
    init<I : IteratorProtocol>(dropFirst n: Int, _ iterator: I) where Element == I.Element, State == (count: Int, iterator: I) {
        func _dropFirst(state: inout State) -> Element? {
            while state.count > 0 {
                guard state.iterator.next() != nil else { return nil }
                state.count = state.count &- 1
            }
            return state.iterator.next()
        }
        self.init(.DropFirst, (n, iterator), _dropFirst)
    }
    
    init<I : IteratorProtocol>(enumerated iterator: I) where Element == (offset: Int, element: I.Element), State == (count: Int, iterator: I) {
        func _enumerated(state: inout State) -> Element? {
            guard let element = state.iterator.next() else { return nil }
            defer { state.count += 1 }
            return (state.count, element)
        }
        self.init(.Enumerated, (0, iterator), _enumerated)
    }

    init<I : IteratorProtocol>(dropWhile predicate: @escaping (I.Element) -> Bool, _ iterator: I) where Element == I.Element, State == PredicatedIterator<I> {
        func _dropWhile(state: inout State) -> Element? {
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
        self.init(.DropWhile, PredicatedIterator(false, predicate, iterator), _dropWhile)
    }
    
    init<I: IteratorProtocol>(prefixWhile predicate: @escaping (I.Element) -> Bool, _ iterator: I) where Element == I.Element, State == PredicatedIterator<I> {
        func _prefix(state: inout State) -> Element? {
            guard let e = state.iterator.next() else { return nil }
            return state.predicate(e) ? e : nil
        }
        self.init(.PrefixWhile, PredicatedIterator(false, predicate, iterator), _prefix)
    }
    
    // TODO test is this would work
    public func prefix(_ maxLength: Int) -> AnySequence<Element> {
        return AnySequence(self)
    }
}

extension Sequence {
    public typealias _CountingIterator = (count: Int, iterator: Iterator)
    public typealias _CountingSequence = ComposedSequence<Iterator.Element, _CountingIterator>
    
    public func _dropFirst(_ n: Int) -> _CountingSequence {
        return ComposedSequence(dropFirst: n, makeIterator())
    }
    
    public func _prefix(_ n: Int) -> _CountingSequence {
        return ComposedSequence(prefix: n, makeIterator())
    }
    
    public typealias _Predicate = (Iterator.Element) -> Bool
    public typealias _PredicatedSequence = ComposedSequence<Iterator.Element, PredicatedIterator<Iterator>>

    public func _drop(while predicate: @escaping _Predicate) -> _PredicatedSequence {
        return ComposedSequence(dropWhile: predicate, makeIterator())
    }

    public func _prefix(while predicate: @escaping _Predicate) -> _PredicatedSequence {
        return ComposedSequence(prefixWhile: predicate, makeIterator())
    }

    public typealias _EnumeratedElement = (offset: Int, element: Iterator.Element)
    public typealias _EnumeratedSequence = ComposedSequence<_EnumeratedElement, _CountingIterator>
    
    public func _enumerated() -> _EnumeratedSequence {
        return ComposedSequence(enumerated: makeIterator())
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
Array(ys._prefix(while:predicate))
