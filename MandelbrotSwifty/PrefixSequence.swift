// Prefix
let p = ys.prefix(2)

func take<S : Sequence>(_ count: Int, source: S) -> AnyIterator<S.Iterator.Element> {
    var i = 0
    var g = source.makeIterator()
    
    return AnyIterator {
        defer { i += 1 }
        return (i < count) ? g.next() : .none
    }
}

let pt = (take(2, source: ys))

extension Sequence {
    
    public typealias _EnumeratedIterator = (count: Int, iterator: Iterator)
    
    public func _prefix(_ maxLength: Int) -> UnfoldSequence<Iterator.Element, _EnumeratedIterator> {
        return sequence(state: (maxLength, makeIterator()), next: {
            (state: inout _EnumeratedIterator) -> Iterator.Element? in
            defer { state.count -= 1 }
            return (state.count > 0) ? state.iterator.next() : nil
        })
    }
    
    public func __prefix(_ maxLength: Int) -> UnfoldSequence<Iterator.Element, _EnumeratedIterator> {
        func countDownNext(state: inout _EnumeratedIterator) -> Iterator.Element? {
            defer { state.count = state.count &- 1 }
            return (state.count > 0) ? state.iterator.next() : nil
        }
        return sequence(state: (maxLength, makeIterator()), next: countDownNext)
    }
}

let pp = Array(ys._prefix(2))
let ppp = Array(ys.__prefix(2))

