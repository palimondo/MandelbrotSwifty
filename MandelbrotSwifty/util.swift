extension Sequence {
    
    public func count() -> Int {
        return reduce(0, {i, _ in i + 1})
    }
    
    func last() -> Iterator.Element?
    {
        var i = makeIterator()
        guard var lastOne = i.next() else {
            return nil
        }
        while let element = i.next() {
            lastOne = element
        }
        return lastOne
    }
    
//    @_transparent
    @inline(__always)
    func _last() -> Iterator.Element? {
        var i = makeIterator()
        return reduce(i.next(), {$1})
    }
    
//    @_transparent
    @inline(__always)
    func __last() -> Iterator.Element? {
        var i = makeIterator()
        return __reduce(i.next(), {$0 = $1})
    }
    
    public func _reduce<Result>(
        _ initialResult: Result,
        _ nextPartialResult:
        (_ partialResult: inout Result, Iterator.Element) throws -> ()
        ) rethrows -> Result {
        var accumulator = initialResult
        for element in self {
            try nextPartialResult(&accumulator, element)
        }
        return accumulator
    }
    
    func __reduce<A>(_ initial: A, _ combine: (inout A, Iterator.Element) -> ()) -> A {
        var result = initial
        for element in self {
            combine(&result, element)
        }
        return result
    }
}

func last<S: Sequence>(_ sequence: S) -> S.Iterator.Element {
    var i = sequence.makeIterator()
    return sequence.reduce(i.next()!, {$1})
}

// ripped-off from _ClosureBasedIterator
public struct _AnyIterator<Element> : IteratorProtocol, Sequence {
    let _next: () -> Element?
    public init(_ next: @escaping () -> Element?) {
        _next = next
    }
    public func next() -> Element? {
        // FIXME test for nil result and always return nil thereafter
        return _next()
    }
}

func _sequence<T>(first: T, next: @escaping (T) -> T?) -> _AnyIterator<T> {
    var value : T? = first
    var firstValue = true
    return _AnyIterator {
        guard !firstValue else { firstValue = false; return value }
        value = value.flatMap(next)
        return value
    }
}

func _sequence<T, State>(state: State, next: @escaping (inout State) -> T?) -> _AnyIterator<T> {
    var state = state
    var done = false
    return _AnyIterator {
        guard !done else { return nil }
        if let elt = next(&state) {
            return elt
        } else {
            done = true
            return nil
        }
    }
}
