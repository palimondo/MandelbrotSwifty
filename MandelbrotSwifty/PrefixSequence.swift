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
    
    /// Prefix defined with `sequence(state:_EnumeratedIterator)` and inline closure with defer
//    @inlinable
    @_inlineable
    public func _prefix(_ maxLength: Int) -> UnfoldSequence<Iterator.Element, _EnumeratedIterator> {
        return sequence(state: (maxLength, makeIterator()), next: {
            (state: inout _EnumeratedIterator) -> Iterator.Element? in
            defer { state.count -= 1 }
            return (state.count > 0) ? state.iterator.next() : nil
        })
    }
    
//    @usableFromInline
    @_versioned
    static internal func countDownNext(state: inout _EnumeratedIterator) -> Iterator.Element? {
        defer { state.count = state.count &- 1 }
        return (state.count > 0) ? state.iterator.next() : nil
    }

    /// Prefix defined with `sequence(state:_EnumeratedIterator)` and `countDownNext` function with defer
//    @inlinable
    @_inlineable
    public func __prefix(_ maxLength: Int) -> UnfoldSequence<Iterator.Element, _EnumeratedIterator> {
        return sequence(state: (maxLength, makeIterator()), next: Self.countDownNext)
    }
    
//    @usableFromInline
    @_versioned
    internal func countDownNext_(state: inout _EnumeratedIterator) -> Iterator.Element? {
        state.count = state.count &- 1
        return (0 <= state.count) ? state.iterator.next() : nil // <= because it counts down one step earlier
    }
    
    /// Prefix defined with `sequence(state:_EnumeratedIterator)` and `countDownNext` function without defer
//    @inlinable
    @_inlineable
    public func __prefix_(_ maxLength: Int) -> UnfoldSequence<Iterator.Element, _EnumeratedIterator> {
        return sequence(state: (maxLength, makeIterator()), next: countDownNext_)
    }
    
    /// Prefix defined within inline closure for `_AnyIterator.init`
//    @inlinable
    @_inlineable
    public func ___prefix(_ maxLength: Int) ->
        _AnyIterator<Iterator.Element> {
            var iterator = makeIterator()
            var count = maxLength
            
            return _AnyIterator {
                count -= 1
                return (0 <= count) ? iterator.next() : nil
            }
            
    }
    /// Prefix defined within inline closure for `AnyIterator.init`
//    @inlinable
    @_inlineable
    public func prefixAI(_ maxLength: Int) ->
        AnyIterator<Iterator.Element> {
            var iterator = makeIterator()
            var count = maxLength
            
            return AnyIterator {
                count -= 1
                return (0 <= count) ? iterator.next() : nil
            }
            
    }
}


