import Cocoa

let asciiGradient = Array(" .,:;|!([$O0*%#@")
//let toAscii: (Int) -> Character = { n in asciiGradient[n - 1]}
func toAscii(_ n: Int) -> Character { return asciiGradient[n - 1] }


let maxIter = asciiGradient.count // 16

//let side: (Int, Double, Double) -> StrideTo<Double> = {size, start, end in
//    stride(from: start, to: end, by: (end - start) / Double(size))
//}
func side(_ size: Int, _ start: Double, _ end : Double) -> StrideTo<Double> {
    return stride(from: start, to: end, by: (end - start) / Double(size))
}
let m = 10 // use 1 when printing art
let w = 64 * m
let h = 32 * m

let sideX = side(w, -2, 2)
let sideY = side(h, -2, 2)

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
        assert(art.count > 2000)
        print(String(format:"\(name) \t %.6fs", timing))
//        print(art)
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
    } while (z.isPotentiallyInSet() && i < maxIter)
    return i
}


func imperativeJulia(z: ℂ) -> Int {
    var z = z
    //    var c = ℂ(-0.75) // Sam Marco
    //    var c = ℂ(-0.391, i:-0.587) // Siegel disk
    //    var c = ℂ(-0.123, i: 0.745) // Douady's rabbit
    let c = ℂ(1 - 1.6180339887498948482)
    var i = 0;
    repeat {
        z = z*z + c
        i += 1
    } while (z.isPotentiallyInSet() && i < maxIter)
    return i
}

func julia(_ c: ℂ) -> (ℂ) -> Int {
    return { z in
        return sequence(first: z, next: {z in
            guard z.isPotentiallyInSet() else {return nil}
            return z * z + c
        }).enumerated().lazy.prefix(while: {$0.0 < maxIter}).last()!.0 + 1
    }
}

func mandelbrot(_ c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in
        guard z.isPotentiallyInSet() else {return nil}
        return z * z + c
    }).enumerated().lazy.prefix(while: {$0.0 < maxIter}).last()!.0 + 1
}

func mandelbrot_(_ c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in
        guard z.isPotentiallyInSet() else {return nil}
        return z * z + c
    }).lazy.prefix(maxIter).count()
}

func mandelbrot__(_ c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in
        guard z.isPotentiallyInSet() else {return nil}
        return z * z + c
    }).__prefix_(maxIter).count()
}


let douadysRabbit: (ℂ) -> Int = julia(ℂ(-0.123, i: 0.745))
let siegelDisk: (ℂ) -> Int = julia(ℂ(-0.391, i:-0.587))
let sanMarco: (ℂ) -> Int = julia(ℂ(-0.75))
let phiThing: (ℂ) -> Int = julia(ℂ(1 - 1.6180339887498948482))

let allRenderers =
    [("imperative                      ", imperative)]
//    + [
//        ("douadysRabbit                   ", douadysRabbit),
//       ("siegelDisk                      ", siegelDisk),
//       ("sanMarco                        ", sanMarco),
//       ("phiThing                        ", phiThing),
//       ("imperativeJulia                 ", imperativeJulia)]
    + [("mandelbrot                      ", mandelbrot),
       ("mandelbrot_                     ", mandelbrot_),
       ("mandelbrot__                    ", mandelbrot__)]
    + swiftyFused
    + swiftyCustom
    + swiftyComposed
//    + functional
    + [("imperative'                     ", imperative)]

timeLoops(allRenderers)

//let start = CACurrentMediaTime();
//
//let stop = CACurrentMediaTime()
//let timing = stop - start
//print(String(format:"Time:\t %.8fs", timing))

