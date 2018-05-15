// Enumerator (EnumeratedSequence)

extension Sequence {
    
//    public typealias _EnumeratedIterator = (count: Int, iterator: Self.Iterator)
    public typealias _EnumeratedElement = (offset: Int, element: Self.Iterator.Element)
    
    public func _enumerated () ->
        UnfoldSequence<_EnumeratedElement, _EnumeratedIterator> {
            return sequence(state: (0, makeIterator()), next: {
                (state: inout _EnumeratedIterator) -> _EnumeratedElement? in
                guard let element = state.iterator.next() else { return nil }
                defer { state.count += 1 }
                return (state.count, element)
            })
    }
    
    private func enumerateNext(state: inout _EnumeratedIterator) -> _EnumeratedElement? {
        guard let element = state.iterator.next() else { return nil }
        defer { state.count = state.count &+ 1 }
        return (state.count, element)
    }
    
    public func __enumerated() ->
        UnfoldSequence<_EnumeratedElement, _EnumeratedIterator> {
            return sequence(state: (0, makeIterator()), next: enumerateNext)
    }
    
    private func enumerateNext_(state: inout _EnumeratedIterator) -> _EnumeratedElement? {
        guard let element = state.iterator.next() else { return nil }
        let count = state.count
        state.count = state.count &+ 1
        return (count, element)
    }
    
    public func __enumerated_() ->
        UnfoldSequence<_EnumeratedElement, _EnumeratedIterator> {
            return sequence(state: (0, makeIterator()), next: enumerateNext_)
    }
    
    public func ___enumerated() -> _AnyIterator<(Int, Iterator.Element)> {
        var count = 0
        var iterator = makeIterator()
        
        return _AnyIterator {
            guard let element = iterator.next() else { return nil }
            defer { count =  count &+ 1 }
            return (count, element)
        }
    }
}

