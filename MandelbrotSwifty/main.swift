import Cocoa

let maxIter = 16 // asciiGradient.length

let side: (Int, Double, Double) -> StrideTo<Double> = {size, start, end in
    stride(from: start, to: end, by:(end-start)/Double(size))
}

let w = 640
let h = 320

let sideX = side(w, -2, 2) // 64 16
let sideY = side(h, -2, 2) // 32 8

let asciiGradient = Array(" .,:;|!([$O0*%#@".characters)
let toAscii: (Int) -> Character = { n in asciiGradient[n - 1]}

let grid = sideY.map({ y in sideX.map({ x in ℂ(x, i:y) }) })

func imperative(c: ℂ) -> Int {
    var z = ℂ(0)
    var i = 0;
    repeat {
        z = z*z + c
        i += 1
    } while (z.normal() < 2 && i < maxIter)
    return i
}

func renderMandelbrot (_ renderer: (ℂ) -> Int) -> String {
    return grid.map {
        String($0.map(renderer).map(toAscii))
        }.joined(separator: "\n")
}

func time<T>(_ fn: () -> T) -> (T, Double) {
    let start = CACurrentMediaTime()
    let result = fn();
    let stop = CACurrentMediaTime()
    return (result, stop - start)
}

func timeRendering(_ renderer: (ℂ) -> Int) -> (String, Double) {
    let start = CACurrentMediaTime()
    let result = renderMandelbrot(renderer)
    let stop = CACurrentMediaTime()
    return (result, stop - start)
}

func timeLoops(_ renderers: [(String, (ℂ) -> Int)]) {
    var timedLoops = [(String, Double)]()
    
    print("---Timing...")
    for (name, renderer) in renderers {
        let (art, timing) = timeRendering(renderer)
        assert(art.characters.count > 2000)
        print(String(format:"\(name) \t %.6fs", timing))
        timedLoops.append((name, timing))
    }
    print("---Results:")
    
    timedLoops.sort { $0.1 < $1.1 }
    let best = timedLoops[0]
    
    for (name, time) in timedLoops {
        print(String(format:"\(name) is %.2fx of \(best.0)", time / best.1))
    }
    
}

func reduceOrbiter(c: ℂ) -> Int {
    return MandelbrotOrbiter(c).prefix(maxIter).reduce(0, {i, _ in i + 1})
}
func orbiterLength(c: ℂ) -> Int {
        return length(MandelbrotOrbiter(c).prefix(maxIter))
}

func lastEnumeratedOrbiter(c: ℂ) -> Int {
        return MandelbrotOrbiter(c).prefix(maxIter).enumerated().last()!.0 + 1
}

func lastOrbiterEnumerated(c: ℂ) -> Int {
    return MandelbrotOrbiter(c).enumerated().prefix(maxIter).last()!.0 + 1
}

// XXX
//func lastOrbiterEnumerated2(c: ℂ) -> Int {
//    return MandelbrotOrbiter(c).enumerated().prefix(while: {$0 < maxIter}).last()!.0 + 1)
//}

func lastEnumeratedOrbitSequence(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c}).prefix(while: {$0.normal() < 2}).prefix(maxIter).enumerated().last()!.0 + 1
}

func lastEnumeratedOrbitSequence2(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c}).prefix(while: {$0.normal() < 2}).enumerated().prefix(maxIter).last()!.0 + 1
}

func lastEnumeratedOrbitSequence3(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c}).enumerated().prefix(while: {$1.normal() < 2 && $0 < maxIter}).last()!.0 + 1
}

func lastEnumeratedOrbitSequence4(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c}).enumerated()._prefix(while: {$1.normal() < 2 && $0 < maxIter}).last()!.0 + 1
}

func lastEnumeratedOrbitSequence4Length(c: ℂ) -> Int {
    return length(sequence(first: ℂ(0), next: {z in z * z + c}).enumerated()._prefix(while: {$1.normal() < 2 && $0 < maxIter}))
}

func lastEnumeratedOrbitSequence5(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c}).__enumerated().__prefix(while: {$1.normal() < 2 && $0 < maxIter}).last()!.0 + 1
}

func lastEnumeratedOrbitSequence6(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c}).__prefix(while: {$0.normal() < 2}).__prefix(maxIter).__enumerated().last()!.0 + 1
}

func lastEnumeratedOrbitSequence7(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})._enumerated()._prefix(while: {$1.normal() < 2 && $0 < maxIter}).last()!.0 + 1
}

func lastEnumeratedOrbitSequence8(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})._prefix(while: {$0.normal() < 2})._prefix(maxIter)._enumerated().last()!.0 + 1
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



let renderers = [
    ("imperative                      ", imperative),
    ("orbitCounter                    ", orbitCounter),
    ("_orbitCounter                   ", _orbitCounter),
    ("orbitCounter2                   ", orbitCounter2),
    ("orbitCounter3                   ", orbitCounter3),
    ("lastEnumeratedOrbitSequence     ", lastEnumeratedOrbitSequence),
    ("lastEnumeratedOrbitSequence2    ", lastEnumeratedOrbitSequence2),
    ("lastEnumeratedOrbitSequence3    ", lastEnumeratedOrbitSequence3),
    ("lastEnumeratedOrbitSequence4    ", lastEnumeratedOrbitSequence4),
//    ("lastEnumeratedOrbitSequence4Len ", lastEnumeratedOrbitSequence4Length),
    ("lastEnumeratedOrbitSequence5    ", lastEnumeratedOrbitSequence5),
//    ("lastEnumeratedOrbitSequence6    ", lastEnumeratedOrbitSequence6),
    ("lastEnumeratedOrbitSequence7    ", lastEnumeratedOrbitSequence7),
//    ("lastEnumeratedOrbitSequence8    ", lastEnumeratedOrbitSequence8),
    ("reduceOrbiter                   ", reduceOrbiter),
    ("orbiterLength                   ", orbiterLength),
    ("lastEnumeratedOrbiter           ", lastEnumeratedOrbiter),
    ("lastOrbiterEnumerated           ", lastOrbiterEnumerated),
// XXX    ("lastOrbiterEnumerated2          ", lastOrbiterEnumerated2),
//    ("maxEnumeratedOrbiter            ", maxEnumeratedOrbiter),
    ("lastOrbitEnumerator             ", lastOrbitEnumerator),
//    ("last1OrbitEnumerator            ", last1OrbitEnumerator),
    ("orbitEnumeratorLast             ", orbitEnumeratorLast),
    ("orbitEnumerator_Last            ", orbitEnumerator_Last),
    ("orbitFuncQuad                   ", __iterations >>> orbitFuncQuad),
    ("orbitFuncQuadrat                ", __iterations >>> orbitFuncQuadrat),
    ("orbitQuadClosure                ", __iterations >>> orbitQuadClosure),
    //    ("takeWhile take length iterate   ", iterations >>> orbit),
    //    ("takeWhile prefix length iterate ", _iterations >>> orbit),
    //    ("prefix prefix reduce iterate    ", __iterations >>> orbit),
    //    ("takeWhile take length sequence  ", iterations >>> _orbit),
    //    ("takeWhile prefix length sequence", _iterations >>> _orbit),
    ("prefix prefix reduce sequence   ", __iterations >>> _orbit)
]


timeLoops(renderers)

//let start = CACurrentMediaTime();
//
//let stop = CACurrentMediaTime()
//let timing = stop - start
//print(String(format:"Time:\t %.8fs", timing))

