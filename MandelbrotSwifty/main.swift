//
//  main.swift
//  MandelbrotSwifty
//
//  Created by Pavol Vaskovic on 30.01.17.
//  Copyright © 2017 Pavol Vaskovic. All rights reserved.
//

import Cocoa

//===--- Iterator & Sequence ----------------------------------------------===//

/// An iterator over the initial elements traversed by a base iterator that
/// satisfy a given predicate.
///
/// This is the associated iterator for the `LazyPrefixWhileSequence`,
/// `LazyPrefixWhileCollection`, and `LazyPrefixWhileBidirectionalCollection`
/// types.
public struct LazyPrefixWhileIterator<Base : IteratorProtocol> :
IteratorProtocol, Sequence {
    
    public mutating func next() -> Base.Element? {
        // Return elements from the base iterator until one fails the predicate.
        if !_predicateHasFailed, let nextElement = _base.next() {
            if _predicate(nextElement) {
                return nextElement
            } else {
                _predicateHasFailed = true
            }
        }
        return nil
    }
    
    internal init(_base: Base, predicate: @escaping (Base.Element) -> Bool) {
        self._base = _base
        self._predicate = predicate
    }
    
    internal var _predicateHasFailed = false
    internal var _base: Base
    internal let _predicate: (Base.Element) -> Bool
}

/// A sequence whose elements consist of the initial consecutive elements of
/// some base sequence that satisfy a given predicate.
public struct LazyPrefixWhileSequence<Base : Sequence> : LazySequenceProtocol {
    
    public typealias Elements = LazyPrefixWhileSequence
    
    public func makeIterator() -> LazyPrefixWhileIterator<Base.Iterator> {
        return LazyPrefixWhileIterator(
            _base: _base.makeIterator(), predicate: _predicate)
    }
    
    internal init(_base: Base, predicate: @escaping (Base.Iterator.Element) -> Bool) {
        self._base = _base
        self._predicate = predicate
    }
    
    internal var _base: Base
    internal let _predicate: (Base.Iterator.Element) -> Bool
}

//extension LazySequenceProtocol {
extension Sequence {
    /// Returns a lazy sequence of the initial consecutive elements that satisfy
    /// `predicate`.
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as
    ///   its argument and returns `true` if the element should be included or
    ///   `false` otherwise. Once `predicate` returns `false` it will not be
    ///   called again.
    public func prefix(
        while predicate: @escaping (Self.Iterator.Element) -> Bool
        ) -> LazyPrefixWhileSequence<Self> {
        return LazyPrefixWhileSequence(_base: self, predicate: predicate)
    }
}

func takeWhile<S : Sequence>(_ includeElement: @escaping (S.Iterator.Element) -> Bool, source: S) ->  AnyIterator<S.Iterator.Element> {
    var takeMore = true
    var g = source.makeIterator()
    
    return AnyIterator {
        if takeMore {
            if let e = g.next() {
                takeMore = includeElement(e)
                return takeMore ? e : .none
            }
        }
        return .none
    }
}

func take<S : Sequence>(_ count: Int, source: S) -> AnyIterator<S.Iterator.Element> {
    var i = 0
    var g = source.makeIterator()
    
    return AnyIterator {
        defer {i += 1;}
        return (i < count) ? g.next() : .none
    }
}

@_specialize(Int)
func iterate<A>(_ f: @escaping (A) -> A, x0: A) -> AnyIterator<A> {
    var x = x0
    return AnyIterator {
        defer {x = f(x)}
        return x
    }
}

func curry<A,B,R>(_ f: @escaping (A,B) -> R) -> (A) -> (B) -> R {
    return { a in { b in f(a,b) } }
}

func length<S: Sequence>(_ sequence: S) -> Int {
    return sequence.reduce(0, {i, _ in i + 1})
}

infix operator >>> : MultiplicationPrecedence // associativity: left
func >>> <A, B, C>(f: @escaping (B) -> C, g: @escaping (A) -> B) -> (A) -> C {
    return { x in f(g(x)) }
}

struct ComplexNumber {
    let Re: Double
    let Im: Double
    
    init() { self.Re = 0.0; self.Im = 0.0}
    init(_ real: Double) { self.Re = real; self.Im = 0.0 }
    init(i imaginary: Double) { self.Re = 0.0; self.Im = imaginary }
    init(_ real: Double, i imaginary: Double) {
        self.Re = real
        self.Im = imaginary
    }
    
    func normal() -> Double {
        return Re * Re + Im * Im
    }
    
    func asTuple() -> (real:Double, imaginary:Double) {
        return (Re, Im)
    }
}

typealias ℂ = ComplexNumber

func + (x: ℂ, y: ℂ) -> ℂ {
    let ((a, b), (c, d)) = ((x.Re, x.Im), (y.Re, y.Im))
    return ℂ(a + c, i: b + d)
}
func * (x: ℂ, y: ℂ) -> ℂ {
    let ((a, b), (c, d)) = ((x.Re, x.Im), (y.Re, y.Im))
    return ℂ(a*c - b*d, i:b*c + a*d)
}

extension Sequence {
    // Not to spec: missing throwing, noescape
    public func prefix2(
        while predicate: @escaping (Self.Iterator.Element) -> Bool) ->
        UnfoldSequence<Self.Iterator.Element, Self.Iterator> {
            return sequence(state: makeIterator(), next: {
                (myState: inout Iterator) -> Iterator.Element? in
                guard let next = myState.next() else { return nil }
                return predicate(next) ? next : nil
            })
    }
}


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

func orbitCounter2(_ c: ℂ) -> Int {
    var last: (Int, ℂ) = (0, ℂ(0))
    for x in sequence(first: ℂ(0), next: {z in z * z + c}).prefix(while: {$0.normal() < 2}).prefix(maxIter).enumerated() {
        last = x
    }
    return last.0 + 1
}

func orbitCounter3(_ c: ℂ) -> Int {
    var i = 0
    let orbital = sequence(first: ℂ(0), next: {z in
        if (z.normal() < 2) {
            return z * z + c
        } else {
            return nil
        }
    }).prefix(maxIter).enumerated()
    for (x, _) in orbital {
        i = x
    }
    return i + 1
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

extension Sequence {
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
    
    func _last() -> Iterator.Element? {
        var i = makeIterator()
        guard let first = i.next() else {return nil}
        return reduce(first, {$1})
    }
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
    return toAscii(sequence(first: ℂ(0), next: {z in z * z + c}).enumerated().prefix2(while: {$1.normal() < 2 && $0 < maxIter}).last()!.0 + 1)
}

func lastEnumeratedOrbitSequence4Length(c: ℂ)-> Character {
    return toAscii(length(sequence(first: ℂ(0), next: {z in z * z + c}).enumerated().prefix2(while: {$1.normal() < 2 && $0 < maxIter})))
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

func last1<S: Sequence>(_ sequence: S) -> S.Iterator.Element? {
    var i = sequence.makeIterator()
    return sequence.reduce(i.next(), {$1})
}

func lastOrbitEnumerator(c: ℂ) -> Character {
    return toAscii(last(MandelbrotOrbitEnumerator(c)))
}

func last1OrbitEnumerator(c: ℂ) -> Character {
    return toAscii(last1(MandelbrotOrbitEnumerator(c))!)
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
    ("nestedCall2                     ", nestedCall2),
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

