struct MandelbrotOrbiter : IteratorProtocol, Sequence {
    let c : ℂ;
    var z = ℂ(0)
    init(_ cc: ℂ) {
        c = cc
    }
    mutating func next() -> ℂ? {
        guard z.normal() < 2 else { return nil }
        z = z*z + c
        return z
    }
}

struct MandelbrotOrbitEnumerator : IteratorProtocol, Sequence {
    let c : ℂ;
    var z = ℂ(0)
    var i = 0
    init(_ cc: ℂ) {
        c = cc
    }
    mutating func next() -> Int? {
        guard ((z.normal() < 2) && (i < maxIter)) else { return nil }
        z = z*z + c
        i += 1
        return i
    }
}


func orbitCounter(_ c: ℂ) -> Int {
    var i = 0
    let orbital = sequence(first: ℂ(0), next: {z in
        i = i+1
        if (z.normal() < 2 && i < maxIter) {
            return z * z + c
        } else {
            return nil
        }
    })
    for _ in orbital {}
    return i
}

func _orbitCounter(_ c: ℂ) -> Int {
    var i = 0
    let orbital = sequence(first: ℂ(0), next: {z in
        i = i+1
        if (z.normal() < 2 && i < maxIter) {
            return z * z + c
        } else {
            return nil
        }
    })
    return orbital._length()
}


func orbitCounter2(_ c: ℂ) -> Int {
    var last: (Int, ℂ) = (0, ℂ(0))
    for x in sequence(first: ℂ(0), next: {z in z * z + c}).prefix(while: {$0.normal() < 2}).prefix(maxIter).enumerated() {
        last = x
    }
    return last.0 + 1
}

func orbital(_ c: ℂ) -> UnfoldFirstSequence<ℂ>{
    return sequence(first: ℂ(0), next: {z in
        guard z.normal() < 2 else { return nil }
        return z * z + c
    })
}

func orbitCounter3(_ c: ℂ) -> Int {
    //    let orbital = sequence(first: ℂ(0), next: {z in
    //        guard z.normal() < 2 else { return nil }
    //        return z * z + c
    //    })._prefix(maxIter)
    return orbital(c)._prefix(maxIter)._length()
}

