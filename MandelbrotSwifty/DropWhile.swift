// Drop While

//let dw = ys.drop(while: {$0 > 2})
//dw


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

extension Sequence {
    
    //    public typealias DropWhileIterator = (predicateHasFailed: Bool, predicate: (Iterator.Element) -> Bool, iterator: Iterator)
    
    public func _drop(while predicate: @escaping (Iterator.Element) -> Bool) -> UnfoldSequence<Iterator.Element, DropWhileIterator<Iterator>> {
        return sequence(state: DropWhileIterator(false, predicate, makeIterator()), next: {
            (state: inout DropWhileIterator) -> Iterator.Element? in
            guard state.predicateHasFailed else {
                while let nextElement = state.iterator.next() {
                    if !predicate(nextElement) {
                        state.predicateHasFailed = true
                        return nextElement
                    }
                }
                return nil
            }
            return state.iterator.next()
        })
    }
    
    internal func dropWhile(state: inout DropWhileIterator<Iterator>) -> Iterator.Element? {
        guard state.predicateHasFailed else {
            while let nextElement = state.iterator.next() {
                if !state.predicate(nextElement) {
                    state.predicateHasFailed = true
                    return nextElement
                }
            }
            return nil
        }
        return state.iterator.next()
    }
    
    public func __drop(while predicate: @escaping (Iterator.Element) -> Bool) -> UnfoldSequence<Iterator.Element, DropWhileIterator<Iterator>> {
        return sequence(state: DropWhileIterator(false, predicate, makeIterator()), next: dropWhile)
    }
    
    public func ___drop(while predicate: @escaping (Iterator.Element) -> Bool) -> _AnyIterator<Iterator.Element> {
        var predicateHasFailed = false
        var iterator = makeIterator()
        
        return _AnyIterator {
            guard predicateHasFailed else {
                while let nextElement = iterator.next() {
                    guard predicate(nextElement) else {
                        predicateHasFailed = true
                        return nextElement
                    }
                }
                return nil // exhausted underlying sequence
            }
            return iterator.next()
        }
    }
}

