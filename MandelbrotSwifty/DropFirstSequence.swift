// Drop First

extension Sequence {
    
    public typealias _EnumeratedIterator = (count: Int, iterator: Iterator)
    
    public func _dropFirst(_ n: Int) ->
        UnfoldSequence<Iterator.Element, _EnumeratedIterator> {
            return sequence(state: (n, makeIterator()), next: {
                (state: inout _EnumeratedIterator) -> Iterator.Element? in
                while state.count > 0 {
                    guard state.iterator.next() != nil else { return nil }
                    state.count -= 1
                }
                return state.iterator.next()
            })
    }
    
    public func __dropFirst(_ n: Int) ->
        UnfoldSequence<Iterator.Element, _EnumeratedIterator> {
            func dropNext(state: inout _EnumeratedIterator) -> Iterator.Element? {
                while state.count > 0 {
                    guard state.iterator.next() != nil else { return nil }
                    state.count = state.count &- 1
                }
                return state.iterator.next()
            }
            return sequence(state: (n, makeIterator()), next: dropNext)
    }
    
    public func ___dropFirst(_ n: Int) -> _AnyIterator<Iterator.Element> {
        var count = n
        var iterator = makeIterator()
        
        return _AnyIterator {
            while count > 0 {
                if iterator.next() == nil {
                    return nil
                }
                count -= 1
            }
            return iterator.next()
        }
    }
}
