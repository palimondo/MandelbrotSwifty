extension Sequence {
    func _length() -> Int {
        return reduce(0, {$0.0 + 1})
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

