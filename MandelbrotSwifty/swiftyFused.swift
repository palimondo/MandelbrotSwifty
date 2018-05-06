
func orbitCounter(_ c: ℂ) -> Int {
    var i = 0
    let orbital = sequence(first: ℂ(0), next: {z in
        i = i+1
        if (z.isPotentiallyInSet() && i < maxIter) {
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
        if (z.isPotentiallyInSet() && i < maxIter) {
            return z * z + c
        } else {
            return nil
        }
    })
    return orbital.count()
}

func orbitEnumerated(_ c: ℂ) -> Int {
    let orbital = sequence(first: ℂ(0), next: {z in
        guard z.isPotentiallyInSet() else {return nil}
        return z * z + c
    })
    return orbital.enumerated().lazy.prefix(while: {$0.0 < maxIter}).last()!.0 + 1
}

func orbitEnumerated2(_ c: ℂ) -> Int {
    let orbital = sequence(first: ℂ(0), next: {z in
        guard z.isPotentiallyInSet() else {return nil}
        return z * z + c
    })
    return orbital.enumerated().lazy.prefix(while: {$0.0 < maxIter})._last()!.0 + 1
}

func orbitEnumerated_2(_ c: ℂ) -> Int {
    let orbital = sequence(first: ℂ(0), next: {z in
        guard z.isPotentiallyInSet() else {return nil}
        return z * z + c
    })
    return orbital.enumerated()._prefix(while: {$0.0 < maxIter}).__last()!.0 + 1
}

func orbit_Enumerated_2(_ c: ℂ) -> Int {
    let orbital = sequence(first: ℂ(0), next: {z in
        guard z.isPotentiallyInSet() else {return nil}
        return z * z + c
    })
    return orbital._enumerated().lazy.prefix(while: {$0.0 < maxIter}).__last()!.0 + 1
}

func orbitEnumerated3(_ c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in
        guard z.isPotentiallyInSet() else {return nil}
        return z * z + c
    })
        .enumerated().lazy
        .prefix(while: {$0.0 < maxIter})
        ._last()!.0 + 1
}

func orbitCounter2(_ c: ℂ) -> Int {
    var last: (Int, ℂ) = (0, ℂ(0))
    let s = sequence(first: ℂ(0), next: {z in z * z + c}).lazy
    for x in s
        .prefix(while: {$0.isPotentiallyInSet()})
        .prefix(maxIter)
        .enumerated() {
        last = x
    }
    return last.0 + 1
}

func orbital(_ c: ℂ) -> UnfoldFirstSequence<ℂ>{
    return sequence(first: ℂ(0), next: {z in
        guard z.isPotentiallyInSet() else { return nil }
        return z * z + c
    })
}

func orbitCounter3(_ c: ℂ) -> Int {
    //    let orbital = sequence(first: ℂ(0), next: {z in
    //        guard z.isPotentiallyInSet() else { return nil }
    //        return z * z + c
    //    })._prefix(maxIter)
    return orbital(c)._prefix(maxIter).count()
}


func orbital__Enumerated(_ c: ℂ) -> Int {
    let orbital = sequence(first: ℂ(0), next: {z in
        guard z.isPotentiallyInSet() else {return nil}
        return z * z + c
    })
    return orbital.__enumerated().__prefix(while: {$0.0 < maxIter}).last()!.0 + 1
}
func __orbital__Enumerated(_ c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c}).__prefix(while:{z in z.isPotentiallyInSet()}).__prefix(maxIter).__enumerated().last()!.0 + 1
}

let swiftyFused = [
    ("orbitCounter                    ", orbitCounter),
    ("_orbitCounter                   ", _orbitCounter),
    ("orbitEnumerated                 ", orbitEnumerated),
    ("orbitEnumerated2                ", orbitEnumerated2),
    ("orbitEnumerated_2               ", orbitEnumerated_2),
    ("orbit_Enumerated_2              ", orbit_Enumerated_2),
    ("orbitEnumerated3                ", orbitEnumerated3),
//    ("orbitCounter2                   ", orbitCounter2),
//    ("orbitCounter3                   ", orbitCounter3),
    ("orbitalEnumerated_C             ", orbitalEnumerated_C),
    ("orbital__Enumerated             ", orbital__Enumerated),
    ("__orbital__Enumerated           ", __orbital__Enumerated),
]

func orbitalEnumerated_C(_ c: ℂ) -> Int {
    return _sequence(first: ℂ(0), next: {z in
        guard z.isPotentiallyInSet() else {return nil}
        return z * z + c
    })
        .enumerated()
        .lazy
        .prefix(while: {$0.0 < maxIter})
        .last()!.0 + 1
}


