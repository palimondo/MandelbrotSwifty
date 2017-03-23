struct MandelbrotOrbiter : IteratorProtocol, Sequence {
    let c : ℂ;
    var z = ℂ(0)
    init(_ cc: ℂ) {
        c = cc
    }
    mutating func next() -> ℂ? {
        guard z.isPotentiallyInSet() else { return nil }
        z = z*z + c
        return z
    }
//    public mutating func makeIterator() -> MandelbrotOrbiter {
//        z = ℂ(0)
//        return self
//    }
}

struct MandelbrotOrbitEnumerator : IteratorProtocol, Sequence {
    let c : ℂ;
    var z = ℂ(0)
    var i = 0
    init(_ cc: ℂ) {
        c = cc
    }
    mutating func next() -> Int? {
        guard (z.isPotentiallyInSet() && (i < maxIter)) else { return nil }
        z = z*z + c
        i += 1
        return i
    }
}



func reduceOrbiter(c: ℂ) -> Int {
    return MandelbrotOrbiter(c).prefix(maxIter).reduce(0, {i, _ in i + 1})
}
func orbiterLength(c: ℂ) -> Int {
    return length(MandelbrotOrbiter(c).prefix(maxIter))
    // TODO compare with seq._length
}

func lastEnumeratedOrbiter(c: ℂ) -> Int {
    return MandelbrotOrbiter(c).prefix(maxIter).enumerated().last()!.0 + 1
}

func lastOrbiterEnumerated(c: ℂ) -> Int {
    return MandelbrotOrbiter(c).enumerated().prefix(maxIter).last()!.0 + 1
}

func lastOrbiterEnumerated2(c: ℂ) -> Int {
    return MandelbrotOrbiter(c).enumerated().lazy.prefix(while: {$0.0 < maxIter}).last()!.0 + 1
}

func lastOrbiterEnumerated_2(c: ℂ) -> Int {
    return MandelbrotOrbiter(c).enumerated()._prefix(while: {$0.0 < maxIter})._last()!.0 + 1
}

func maxEnumeratedOrbiter(c: ℂ) -> Int {
    return MandelbrotOrbiter(c).prefix(maxIter).enumerated().max(by: {$0.0 < $1.0})!.offset + 1
}

func lastOrbitEnumerator(c: ℂ) -> Int {
    return last(MandelbrotOrbitEnumerator(c))
}

func orbitEnumeratorLast(c: ℂ) -> Int {
    return MandelbrotOrbitEnumerator(c).last()!
}

func orbitEnumerator_Last(c: ℂ) -> Int {
    return MandelbrotOrbitEnumerator(c)._last()!
}

func orbitEnumerator__Last(c: ℂ) -> Int {
    return MandelbrotOrbitEnumerator(c).__last()!
}

let swiftyCustom = [
//    ("reduceOrbiter                   ", reduceOrbiter),
//    ("orbiterLength                   ", orbiterLength),
    
//    ("lastEnumeratedOrbiter           ", lastEnumeratedOrbiter),
//    ("lastOrbiterEnumerated           ", lastOrbiterEnumerated),

    ("lastOrbiterEnumerated2          ", lastOrbiterEnumerated2),
    ("lastOrbiterEnumerated_2         ", lastOrbiterEnumerated_2),
//    ("maxEnumeratedOrbiter            ", maxEnumeratedOrbiter),
    ("lastOrbitEnumerator             ", lastOrbitEnumerator),
    ("orbitEnumeratorLast             ", orbitEnumeratorLast),
    ("orbitEnumerator_Last            ", orbitEnumerator_Last),
    ("orbitEnumerator__Last           ", orbitEnumerator__Last),
]
