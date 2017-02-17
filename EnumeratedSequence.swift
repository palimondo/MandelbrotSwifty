// Enumerator (EnumeratedSequence)

extension Sequence {
    
    public typealias _EnumeratedIterator = (count: Int, iterator: Self.Iterator)
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
    
    public func __enumerated () ->
        UnfoldSequence<_EnumeratedElement, _EnumeratedIterator> {
            func enumerateNext(state: inout _EnumeratedIterator) -> _EnumeratedElement? {
                guard let element = state.iterator.next() else { return nil }
                defer { state.count = state.count &+ 1 }
                return (state.count, element)
            }
            return sequence(state: (0, makeIterator()), next: enumerateNext)
    }
}

let e = Array(xs.enumerated())

let ee = Array(xs._enumerated())

let eee = Array(xs.__enumerated())
