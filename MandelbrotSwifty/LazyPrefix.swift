//===--- Iterator & Sequence ----------------------------------------------===//

/// An iterator over the initial elements traversed by a base iterator that
/// satisfy a given predicate.
///
/// This is the associated iterator for the `LazyPrefixSequence`,...
/// types.
public struct LazyPrefixIterator<Base : IteratorProtocol> :
IteratorProtocol, Sequence {
    
    public mutating func next() -> Base.Element? {
        guard _countRemaining > 0,
            let nextElement = _base.next() else {
                _countRemaining = 0
                return nil
        }
        _countRemaining = _countRemaining &- 1
        return nextElement
    }
    
    internal init(_base: Base, maxLength: Int) {
        self._base = _base
        self._countRemaining = maxLength
    }
    
    internal var _base: Base
    internal var _countRemaining: Int
}

/// A sequence whose elements consist of the initial consecutive elements of
/// some base sequence that satisfy a given predicate.
public struct LazyPrefixSequence<Base : Sequence> : LazySequenceProtocol {
    
    public typealias Elements = LazyPrefixSequence
    
    public func makeIterator() -> LazyPrefixIterator<Base.Iterator> {
        return LazyPrefixIterator(
            _base: _base.makeIterator(), maxLength: _maxLength)
    }
    
    internal init(_base: Base, maxLength: Int) {
        self._base = _base
        self._maxLength = maxLength
    }
    
    internal var _base: Base
    internal let _maxLength: Int
}

extension LazySequenceProtocol {
    public func prefixL(_ maxLength: Int) -> LazyPrefixSequence<Self> {
        return LazyPrefixSequence(_base: self, maxLength: maxLength)
    }
}
