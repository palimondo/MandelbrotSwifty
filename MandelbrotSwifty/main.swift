//
//  main.swift
//  MandelbrotSwifty
//
//  Created by Pavol Vaskovic on 30.01.17.
//  Copyright © 2017 Pavol Vaskovic. All rights reserved.
//

import Cocoa

let quadrat: (ℂ, ℂ) -> ℂ = {c, z in z*z + c}

let orbit: (ℂ) -> AnyIterator<ℂ> = {c in iterate(curry(quadrat)(c), x0: ℂ(0))}

let maxIter = 16 // asciiGradient.length

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

let iterations: (AnyIterator<ℂ>) -> Int = {seq in
    length(takeWhile({z in z.normal() < 2}, source: take(maxIter, source: seq)))
}
let _iterations: (AnyIterator<ℂ>) -> Int = {seq in
    length(takeWhile({z in z.normal() < 2}, source: seq.prefix(maxIter)))
}
let __iterations: (AnyIterator<ℂ>) -> Int = {seq in
    seq.prefix(maxIter).prefix(while: {z in z.normal() < 2}).reduce(0, {i, _ in i + 1})
}
//let _orbit = {z in sequence(first: ℂ(0), next: curry({c, z in z*z + c})(z))}
let _orbit = {c in AnyIterator(sequence(first: ℂ(0), next: curry({c, z in z*z + c})(c)))}

func quad(_ c: ℂ, _ z: ℂ) -> ℂ { return z*z + c }
let orbitFuncQuad = {c in AnyIterator(sequence(first: ℂ(0), next: curry(quad)(c)))}
let orbitFuncQuadrat = {c in AnyIterator(sequence(first: ℂ(0), next: curry(quadrat)(c)))}

func quadC(_ c: ℂ) -> (ℂ) -> ℂ { return {z in z*z + c}}
let orbitQuadClosure = {c in AnyIterator(sequence(first: ℂ(0), next: quadC(c)))}


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

func imperative(c: ℂ) -> Character {
    var z = ℂ(0)
    var i = 0;
    repeat {
        z = z*z + c
        i += 1
    } while (z.normal() < 2 && i < maxIter)
    return toAscii(i)
}

func renderMandelbrot (_ renderer: (ℂ) -> Character) -> String {
    return grid.map {
        String($0.map(renderer))
        }.joined(separator: "\n")
}

func time<T>(_ fn: () -> T) -> (T, Double) {
    let start = CACurrentMediaTime()
    let result = fn();
    let stop = CACurrentMediaTime()
    return (result, stop - start)
}

func timeRendering(_ renderer: (ℂ) -> Character) -> (String, Double) {
    let start = CACurrentMediaTime()
    let result = renderMandelbrot(renderer)
    let stop = CACurrentMediaTime()
    return (result, stop - start)
}

func timeLoops(_ renderers: [(String, (ℂ) -> Character)]) {
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

func nestedCall(c: ℂ) -> Character {
    return toAscii(orbitCounter(c))
}
func _nestedCall(c: ℂ) -> Character {
    return toAscii(_orbitCounter(c))
}
func nestedCall2(c: ℂ) -> Character {
    return toAscii(orbitCounter2(c))
}
func nestedCall3(c: ℂ) -> Character {
    return toAscii(orbitCounter3(c))
}

func reduceOrbiter(c: ℂ) -> Character {
    return toAscii(MandelbrotOrbiter(c).prefix(maxIter).reduce(0, {i, _ in i + 1}))
}
func orbiterLength(c: ℂ) -> Character {
        return toAscii(length(MandelbrotOrbiter(c).prefix(maxIter)))
}

func lastEnumeratedOrbiter(c: ℂ) -> Character {
        return toAscii(MandelbrotOrbiter(c).prefix(maxIter).enumerated().last()!.0 + 1)
}

func lastOrbiterEnumerated(c: ℂ) -> Character {
    return toAscii(MandelbrotOrbiter(c).enumerated().prefix(maxIter).last()!.0 + 1)
}

// XXX
//func lastOrbiterEnumerated2(c: ℂ) -> Character {
//    return toAscii(MandelbrotOrbiter(c).enumerated().prefix(while: {$0 < maxIter}).last()!.0 + 1)
//}

func lastEnumeratedOrbitSequence(c: ℂ)-> Character {
    return toAscii(sequence(first: ℂ(0), next: {z in z * z + c}).prefix(while: {$0.normal() < 2}).prefix(maxIter).enumerated().last()!.0 + 1)
}

func lastEnumeratedOrbitSequence2(c: ℂ)-> Character {
    return toAscii(sequence(first: ℂ(0), next: {z in z * z + c}).prefix(while: {$0.normal() < 2}).enumerated().prefix(maxIter).last()!.0 + 1)
}

func lastEnumeratedOrbitSequence3(c: ℂ)-> Character {
    return toAscii(sequence(first: ℂ(0), next: {z in z * z + c}).enumerated().prefix(while: {$1.normal() < 2 && $0 < maxIter}).last()!.0 + 1)
}

func lastEnumeratedOrbitSequence4(c: ℂ)-> Character {
    return toAscii(sequence(first: ℂ(0), next: {z in z * z + c}).enumerated()._prefix(while: {$1.normal() < 2 && $0 < maxIter}).last()!.0 + 1)
}

func lastEnumeratedOrbitSequence4Length(c: ℂ)-> Character {
    return toAscii(length(sequence(first: ℂ(0), next: {z in z * z + c}).enumerated()._prefix(while: {$1.normal() < 2 && $0 < maxIter})))
}

func lastEnumeratedOrbitSequence5(c: ℂ)-> Character {
    return toAscii(sequence(first: ℂ(0), next: {z in z * z + c}).__enumerated().__prefix(while: {$1.normal() < 2 && $0 < maxIter}).last()!.0 + 1)
}

func lastEnumeratedOrbitSequence6(c: ℂ)-> Character {
    return toAscii(sequence(first: ℂ(0), next: {z in z * z + c}).__prefix(while: {$0.normal() < 2}).__prefix(maxIter).__enumerated().last()!.0 + 1)
}

func lastEnumeratedOrbitSequence7(c: ℂ)-> Character {
    return toAscii(sequence(first: ℂ(0), next: {z in z * z + c})._enumerated()._prefix(while: {$1.normal() < 2 && $0 < maxIter}).last()!.0 + 1)
}

func lastEnumeratedOrbitSequence8(c: ℂ)-> Character {
    return toAscii(sequence(first: ℂ(0), next: {z in z * z + c})._prefix(while: {$0.normal() < 2})._prefix(maxIter)._enumerated().last()!.0 + 1)
}

func maxEnumeratedOrbiter(c: ℂ) -> Character {
    return toAscii(MandelbrotOrbiter(c).prefix(maxIter).enumerated().max(by: {$0.0 < $1.0})!.offset + 1)
}

func last<S: Sequence>(_ sequence: S) -> S.Iterator.Element {
    var i = sequence.makeIterator()
    return sequence.reduce(i.next()!, {$1})
}

func lastOrbitEnumerator(c: ℂ) -> Character {
    return toAscii(last(MandelbrotOrbitEnumerator(c)))
}

func orbitEnumeratorLast(c: ℂ) -> Character {
    return toAscii(MandelbrotOrbitEnumerator(c).last()!)
}

func orbitEnumerator_Last(c: ℂ) -> Character {
    return toAscii(MandelbrotOrbitEnumerator(c)._last()!)
}

let renderers = [
    ("imperative                      ", imperative),
    ("nestedCall                      ", nestedCall),
    ("_nestedCall                     ", _nestedCall),
    ("nestedCall2                     ", nestedCall2),
    ("nestedCall3                     ", nestedCall3),
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
]

//let renderers = [
//    ("imperative                      ", imperative),
//    ("nestedCall                      ", nestedCall),
//    ("nestedCall2                     ", nestedCall2),
//    ("nestedCall3                     ", nestedCall3),
//    ("orbitFuncQuad                   ", toAscii >>> __iterations >>> orbitFuncQuad),
//    ("orbitFuncQuadrat                ", toAscii >>> __iterations >>> orbitFuncQuadrat),
//    ("orbitQuadClosure                ", toAscii >>> __iterations >>> orbitQuadClosure),
////    ("takeWhile take length iterate   ", toAscii >>> iterations >>> orbit),
////    ("takeWhile prefix length iterate ", toAscii >>> _iterations >>> orbit),
////    ("prefix prefix reduce iterate    ", toAscii >>> __iterations >>> orbit),
////    ("takeWhile take length sequence  ", toAscii >>> iterations >>> _orbit),
////    ("takeWhile prefix length sequence", toAscii >>> _iterations >>> _orbit),
//    ("prefix prefix reduce sequence   ", toAscii >>> __iterations >>> _orbit)
//]

timeLoops(renderers)

//let start = CACurrentMediaTime();
//
//let stop = CACurrentMediaTime()
//let timing = stop - start
//print(String(format:"Time:\t %.8fs", timing))

