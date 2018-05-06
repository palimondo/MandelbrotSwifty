indirect public enum SeqOp<Element> {
    case Base(AnyIterator<Element>)
    case Empty
    case Prefix(SeqOp, Int)
    case DropFirst(SeqOp, Int)
//    case Enumerated(SeqOp, Int)
}

extension SeqOp {
    init<S: Sequence>(_ seq: S) where S.Iterator.Element == Element {
        self = .Base(AnyIterator(seq.makeIterator()))
    }
}

extension SeqOp : IteratorProtocol {
    public typealias _CountingIterator = (iterator: SeqOp<Element>, count: Int)
    public typealias _EnumetratedElement = (offset: Int, element: Element)
    
    private func _nextPrefixCountDown(state: inout _CountingIterator) -> Element? {
        defer { state.count = state.count &- 1 }
        return (state.count > 0) ? state.iterator.next() : nil
    }
    
    private func _nextDropFirst(state: inout _CountingIterator) -> Element? {
        while state.count > 0 {
            guard state.iterator.next() != nil else { return nil }
            state.count = state.count &- 1
        }
        return state.iterator.next()
    }
    private func _nextEnumerated(state: inout _CountingIterator) -> _EnumetratedElement? {
        guard let element = state.iterator.next() else { return nil }
        defer { state.count += 1 }
        return (state.count, element)
    }
    
    public mutating func next() -> Element? {
        switch self {
        case .Empty:
            return nil
            
        case .Base(let iterator):
            let elm = iterator.next()
            self = .Base(iterator)
            return elm
        case .Prefix(let iterator, let count):
            var state : _CountingIterator = (iterator, count)
            guard let elm = _nextPrefixCountDown(state: &state) else { return empty() }
            self = .Prefix(state.iterator, state.count)
            return elm
            
        case .DropFirst(let iterator, let count):
            var state : _CountingIterator = (iterator, count)
            guard let elm = _nextDropFirst(state: &state) else { return empty() }
            self = .DropFirst(state.iterator, state.count)
            return elm
            
//        case _:
//            break
        }
    }
    
    mutating func empty() -> Element? {
        self = .Empty
        return nil
    }
}

extension SeqOp : Sequence {
    
}

extension Sequence  {
    //typealias SubSequence = SeqOp<Iterator.Element>
    
    // init<S: Sequence>(_ seq: S) where S.Iterator == Iterator {
    public func _prefix(_ maxLength: Int) -> SeqOp<Iterator.Element> {
        self
        switch self {
        case .Prefix(let iterator, let count) as SeqOp<Iterator.Element>:
            return .Prefix(iterator, Swift.min(count, maxLength))
        default:
            return .Prefix(SeqOp(self), maxLength)
        }
    }
    
    public func _dropFirst(_ n: Int) -> SeqOp<Iterator.Element> {
        self
        switch self {
        case .DropFirst(let iterator, let count) as SeqOp<Iterator.Element>:
            return .DropFirst(iterator, count + n)
        default:
            return .DropFirst(SeqOp(self), n)
        }
    }
    
    //public func _dropLast(_ n: Int) -> SeqOp<Iterator.Element> {
    //public func _suffix(_ maxLength: Int) -> SeqOp<Iterator.Element> {
    //public func split(maxSplits: Int, omittingEmptySubsequences: Bool, whereSeparator isSeparator: (Iterator.Element) throws -> Bool) rethrows -> [SeqOp<Iterator.Element>] {
}
//var y : SeqOp<Int> = [1,2,3,4,5,6,7,8,9]._prefix(8)._dropFirst(1)._dropFirst(3)._prefix(7)._dropFirst(4)
//Array(y)
//y
let x = [1,2,3,4,5,6,7,8,9]._prefix(8)._prefix(7)._prefix(6)._prefix(5)._prefix(4)
//Array(x)
var xx = x
xx.next()
xx.next()
xx.next()
xx.next()
xx.next()

Array(SeqOp([1,2,3]))
SeqOp([1,2,3])
Array([1,2,3]._prefix(2))
[1,2,3]._prefix(2)
Array([1,2,3]._dropFirst(1))
[1,2,3]._dropFirst(1)
Array([1,2,3]._prefix(2)._dropFirst(1))
[1,2,3]._prefix(2)._dropFirst(1)
Array([1,2,3]._dropFirst(1)._prefix(1))
[1,2,3]._dropFirst(1)._prefix(1)
Array([1,2,3]._dropFirst(1)._prefix(1))

let yy = [1,2,3,4,5,6,7,8,9]._prefix(6)._dropFirst(4)
Array(yy)

