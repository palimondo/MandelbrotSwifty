// Prefix
let p = ys.prefix(2)

//func take<S : Sequence>(_ count: Int, source: S) -> AnyIterator<S.Iterator.Element> {
//    var i = 0
//    var g = source.makeIterator()
//    
//    return AnyIterator {
//        defer { i += 1 }
//        return (i < count) ? g.next() : .none
//    }
//}
//
//let pt = (take(2, source: ys))

extension Sequence {
    
//    public typealias _EnumeratedIterator = (count: Int, iterator: Iterator)
    
    public func _prefix(_ maxLength: Int) -> UnfoldSequence<Iterator.Element, _EnumeratedIterator> {
        return sequence(state: (maxLength, makeIterator()), next: {
            (state: inout _EnumeratedIterator) -> Iterator.Element? in
            defer { state.count -= 1 }
            return (state.count > 0) ? state.iterator.next() : nil
        })
    }
    
    private func countDownNext(state: inout _EnumeratedIterator) -> Iterator.Element? {
        defer { state.count = state.count &- 1 }
        return (state.count > 0) ? state.iterator.next() : nil
    }
    
    public func __prefix(_ maxLength: Int) -> UnfoldSequence<Iterator.Element, _EnumeratedIterator> {
        return sequence(state: (maxLength, makeIterator()), next: countDownNext)
    }

    public func ___prefix(_ maxLength: Int) ->
        _AnyIterator<Iterator.Element> {
            var iterator = makeIterator()
            var count = maxLength
            
            return _AnyIterator {
                count -= 1
                return (0 <= count) ? iterator.next() : nil
            }

    }
}


