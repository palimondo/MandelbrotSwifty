
//enum SeqOp<Element> : IteratorProtocol, Sequence {
//    case Base(iterator: AnyIterator<Element>) {
//        public func next() -> Element? {
//            return iterator.next()
//        }
//    }
//}

indirect enum SeqOp<Iterator: IteratorProtocol> {
    case Base(Iterator)
    case Prefix(Iterator, Int)
}

extension SeqOp {
    init<S: Sequence>(_ seq: S) where S.Iterator == Iterator {
        self = .Base(seq.makeIterator())
    }
}

extension SeqOp : IteratorProtocol, Sequence {
//    typealias SubSequence = SeqOp<Iterator>
    
//    private func countDownNext(count: inout Int, iterator: inout Iterator) -> Iterator.Element? {
//        defer { count = count &- 1 }
//        return (count > 0) ? iterator.next() : nil
//    }
    
    private func countDownNext(state: inout (iterator: Iterator, count: Int)) -> Iterator.Element? {
        defer { state.count = state.count &- 1 }
        return (state.count > 0) ? state.iterator.next() : nil
    }
    
    mutating func next() -> Iterator.Element? {
        switch self {
        case .Base(var iterator):
            let element = iterator.next()
            self = .Base(iterator)
            return element
            
        case .Prefix(let iterator, let count):
            var state = (iterator: iterator, count: count)
            let element = countDownNext(state: &state)
            self = .Prefix(state.iterator, state.count)
            return element
        }
    }
    
//    public func prefix(_ maxLength: Int) -> AnyIterator<Iterator.Element> {
//        let p = SeqOp<Iterator>.Prefix(self, count: maxLength)
//        return AnyIterator(p)
//    }
//}
//
//extension SeqOp : Sequence {
////        func makeIterator() -> AnyIterator<Iterator.Element> {
////            return AnyIterator(self)
////        }
//    func makeIterator() -> SeqOp<Iterator> {
//        return self
//    }
}

extension Sequence {
    
    
    
//    public func _prefix(_ maxLength: Int) -> AnyIterator<Iterator.Element> {
//        switch self {
//        case SeqOp<Iterator>:
//            <#code#>
//        default:
//            return AnyIterator(SeqOp(self).prefix(maxLength))
//        }
//    }
}

SeqOp([1,2,3])
Array(SeqOp([1,2,3]))
Array(SeqOp.Prefix([1,2,3].makeIterator(), 2))
