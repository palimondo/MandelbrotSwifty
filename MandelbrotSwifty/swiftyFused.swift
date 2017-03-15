
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

func orbitEnumerated(_ c: ℂ) -> Int {
    let orbital = sequence(first: ℂ(0), next: {z in
        guard z.normal() < 2 else {return nil}
        return z * z + c
    })
    return orbital.enumerated().prefix(while: {$0.0 < maxIter}).last()!.0 + 1
}

func orbitEnumerated2(_ c: ℂ) -> Int {
    let orbital = sequence(first: ℂ(0), next: {z in
        guard z.normal() < 2 else {return nil}
        return z * z + c
    })
    return orbital.enumerated().prefix(while: {$0.0 < maxIter})._last()!.0 + 1
}

func orbitEnumerated_2(_ c: ℂ) -> Int {
    let orbital = sequence(first: ℂ(0), next: {z in
        guard z.normal() < 2 else {return nil}
        return z * z + c
    })
    return orbital.enumerated()._prefix(while: {$0.0 < maxIter}).__last()!.0 + 1
}

func orbit_Enumerated_2(_ c: ℂ) -> Int {
    let orbital = sequence(first: ℂ(0), next: {z in
        guard z.normal() < 2 else {return nil}
        return z * z + c
    })
    return orbital._enumerated().prefix(while: {$0.0 < maxIter}).__last()!.0 + 1
}

//func orbitEnumerated3(_ c: ℂ) -> Int {
//    let orbital = sequence(first: ℂ(0), next: {z in
//        guard z.normal() < 2 else {return nil}
//        return z * z + c
//    })
//    return orbital.enumerated().prefix(while: {$0.0 < maxIter}).__last()!.0 + 1
//}
func orbitEnumerated3(_ c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in
        guard z.normal() < 2 else {return nil}
        return z * z + c
    })
        .enumerated()
        .prefix(while: {$0.0 < maxIter})
        ._last()!.0 + 1
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

let swiftyFused = [
    ("orbitCounter                    ", orbitCounter),
    ("_orbitCounter                   ", _orbitCounter),
// TODO - this doesn't optimize, but lastOrbiterEnumerated2 does
    ("orbitEnumerated                 ", orbitEnumerated),
    ("orbitEnumerated2                ", orbitEnumerated2),
    ("orbitEnumerated_2               ", orbitEnumerated_2),
    ("orbit_Enumerated_2              ", orbit_Enumerated_2),
    ("orbitEnumerated3                ", orbitEnumerated3),
//    ("orbitCounter2                   ", orbitCounter2),
//    ("orbitCounter3                   ", orbitCounter3),
    ("orbitalEnumerated_C             ", orbitalEnumerated_C),
]

func orbitalEnumerated_C(_ c: ℂ) -> Int {
    return _sequence(first: ℂ(0), next: {z in
        guard z.normal() < 2 else {return nil}
        return z * z + c
    })
        .enumerated()
        .prefix(while: {$0.0 < maxIter})
        .last()!.0 + 1
}


