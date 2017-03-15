enum SeqOp {
    case Prefix, DropFirst, Enumerated, DropWhile
}

private struct NextMethod<Iterator: IteratorProtocol> {
    init(for: Iterator) {}
    
    typealias _EnumeratedIterator = (count: Int, iterator: Iterator)
    typealias _EnumeratedElement = (offset: Int, element: Iterator.Element)
    typealias _CountingSequence = ComposedSequence<Iterator.Element, _EnumeratedIterator>
    
    func prefix(state: inout _EnumeratedIterator) -> Iterator.Element? {
        defer { state.count = state.count &- 1 }
        return (state.count > 0) ? state.iterator.next() : nil
    }
    
    func dropFirst(state: inout _EnumeratedIterator) -> Iterator.Element? {
        while state.count > 0 {
            guard state.iterator.next() != nil else { return nil }
            state.count = state.count &- 1
        }
        return state.iterator.next()
    }
    
    func enumerated(state: inout _EnumeratedIterator) -> _EnumeratedElement? {
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
    var _next: (inout State) -> Element?
    var _done = false
    
//    // <BaseIterator.Element, (count: Int, iterator: BaseIterator)>
//    init<BaseIterator : IteratorProtocol>(_ iterator: BaseIterator, prefix: Int) where BaseIterator.Element == Element, State == (count: Int, iterator: BaseIterator) {
//        _next = NextMethod(for:iterator).prefix
//        _state = (count: prefix, iterator: iterator)
//        self.init(.Prefix, state, next)
////        self.init(.Prefix, (count: prefix, iterator: iterator), NextMethod(for:iterator).prefix)
//    }
//    init<BaseIterator : IteratorProtocol>(_ iterator: BaseIterator, prefix: Int) {
//        self.init(_type: .Prefix, _state: (count: prefix, iterator: iterator), _next: NextMethod(for:iterator).prefix)
//    }

//    static func composePrefix<BaseIterator : IteratorProtocol>(_ prefix: Int, _ iterator: BaseIterator) -> ComposedSequence<BaseIterator.Element, (count: Int, iterator: BaseIterator)> {
//        return ComposedSequence(_type: .Prefix, _state: (prefix, iterator), _next: NextMethod(for:iterator).prefix)
//    }
}

func composePrefix<BaseIterator : IteratorProtocol>(_ prefix: Int, _ iterator: BaseIterator) -> ComposedSequence<BaseIterator.Element, (count: Int, iterator: BaseIterator)> {
    return ComposedSequence(.Prefix, (prefix, iterator), NextMethod(for:iterator).prefix)
}
func composeDropFirst<BaseIterator : IteratorProtocol>(_ n: Int, _ iterator: BaseIterator) -> ComposedSequence<BaseIterator.Element, (count: Int, iterator: BaseIterator)> {
    return ComposedSequence(.DropFirst, (n, iterator), NextMethod(for:iterator).dropFirst)
}
func composeEnumerated<BaseIterator : IteratorProtocol>(_ iterator: BaseIterator) -> ComposedSequence<(offset: Int, element: BaseIterator.Element), (count: Int, iterator: BaseIterator)> {
    return ComposedSequence(.Enumerated, (0, iterator), NextMethod(for:iterator).enumerated)
}
func composeDrop<BaseIterator : IteratorProtocol>(while predicate: @escaping (BaseIterator.Element) -> Bool, _ iterator: BaseIterator) -> ComposedSequence<BaseIterator.Element, DropWhileIterator<BaseIterator>> {
    return ComposedSequence(.DropWhile, DropWhileIterator(false, predicate, iterator), NextMethod(for:iterator).dropWhile)
}

extension  Sequence {
    public typealias _EnumeratedIterator = (count: Int, iterator: Iterator)
    public typealias _EnumeratedElement = (offset: Int, element: Iterator.Element)
    public typealias _CountingSequence = ComposedSequence<Iterator.Element, _EnumeratedIterator>
    public typealias _DropWhileSequence = ComposedSequence<Iterator.Element, DropWhileIterator<Iterator>>
    public typealias _Predicate = (Iterator.Element) -> Bool
    
    public func _enumerated() -> ComposedSequence<_EnumeratedElement, _EnumeratedIterator> {
        return composeEnumerated(makeIterator())
    }
    
    public func _dropFirst(_ n: Int) -> _CountingSequence {
        return composeDropFirst(n, makeIterator())
    }
    
    public func _prefix(_ n: Int) -> _CountingSequence {
        return composePrefix(n, makeIterator())
    }
    
    public func _drop(while predicate: @escaping _Predicate) -> _DropWhileSequence {
        return composeDrop(while: predicate, makeIterator())
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
