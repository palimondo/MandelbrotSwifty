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

/* 
 TODO
    Systematically compare all implementations:
    
    - divide them by the complexity of nesting
    - pay attention to struct vs class (impact on ARC)
    - does Optional<Int> get boxed?
 
    - compare iteration counting using side-effect, enumeration and reduction
        + MandelbrotOrbiteEnumerator vs. MandelbrotOrbiter.[reduce, enumerated, length]
 
    - global function vs. closure ( func vs. let = {} )
    - function vs. extenstion method
    - order of sequence modifiers (enumerated.prefix vs. prefix.enumerated etc.)
    - inlining
    - specialization
    - currying using function vs. inline closure
    - >>> operator vs. incline closure
    
    Styles: Functional, default Sequence implementation,  alternative implementation with UnfoldSequence, AnySequence/Iterator
 
     - try own _AnyIterator/Sequence implementations that is just the struct ClosureBasedIterator/Sequence (avoiding Boxing class in stdlib implementations)
 
 */

func imperative(c: ℂ) -> Int {
    var z = ℂ(0)
    var i = 0;
    repeat {
        z = z*z + c
        i += 1
    } while (z.normal() < 2 && i < maxIter)
    return i
}

let allRenderers = [("imperative                      ", imperative)]
    + swiftyFused
    + swiftyCustom
    + swiftyComposed

timeLoops(allRenderers)

//let start = CACurrentMediaTime();
//
//let stop = CACurrentMediaTime()
//let timing = stop - start
//print(String(format:"Time:\t %.8fs", timing))

