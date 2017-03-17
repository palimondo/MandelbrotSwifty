#if !swift(>=3.1)
//===--- Iterator & Sequence ----------------------------------------------===//

/// An iterator over the initial elements traversed by a base iterator that
/// satisfy a given predicate.
///
/// This is the associated iterator for the `LazyPrefixWhileSequence`,
/// `LazyPrefixWhileCollection`, and `LazyPrefixWhileBidirectionalCollection`
/// types.
public struct LazyPrefixWhileIterator<Base : IteratorProtocol> :
IteratorProtocol, Sequence {
    
    public mutating func next() -> Base.Element? {
        // Return elements from the base iterator until one fails the predicate.
        if !_predicateHasFailed, let nextElement = _base.next() {
            if _predicate(nextElement) {
                return nextElement
            } else {
                _predicateHasFailed = true
            }
        }
        return nil
    }
    
    internal init(_base: Base, predicate: @escaping (Base.Element) -> Bool) {
        self._base = _base
        self._predicate = predicate
    }
    
    internal var _predicateHasFailed = false
    internal var _base: Base
    internal let _predicate: (Base.Element) -> Bool
}

/// A sequence whose elements consist of the initial consecutive elements of
/// some base sequence that satisfy a given predicate.
public struct LazyPrefixWhileSequence<Base : Sequence> : LazySequenceProtocol {
    
    public typealias Elements = LazyPrefixWhileSequence
    
    public func makeIterator() -> LazyPrefixWhileIterator<Base.Iterator> {
        return LazyPrefixWhileIterator(
            _base: _base.makeIterator(), predicate: _predicate)
    }
    
    internal init(_base: Base, predicate: @escaping (Base.Iterator.Element) -> Bool) {
        self._base = _base
        self._predicate = predicate
    }
    
    internal var _base: Base
    internal let _predicate: (Base.Iterator.Element) -> Bool
}

extension LazySequenceProtocol {
//extension Sequence {
    /// Returns a lazy sequence of the initial consecutive elements that satisfy
    /// `predicate`.
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as
    ///   its argument and returns `true` if the element should be included or
    ///   `false` otherwise. Once `predicate` returns `false` it will not be
    ///   called again.
    public func prefix(
        while predicate: @escaping (Self.Iterator.Element) -> Bool
        ) -> LazyPrefixWhileSequence<Self> {
        return LazyPrefixWhileSequence(_base: self, predicate: predicate)
    }
}
#endif
