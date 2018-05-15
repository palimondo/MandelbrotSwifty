import Darwin

struct ComplexNumber {
    let Re, Im:  Double
    init(_ real: Double) { self.Re = real; self.Im = 0.0 }
    init(_ real: Double, i imaginary: Double) { self.Re = real; self.Im = imaginary }
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

extension ℂ {
    func isPotentiallyInSet() -> Bool {
        return (Re * Re + Im * Im) <= 4
    }
}	

let asciiGradient = Array(" .,:;|!([$O0*%#@")
func toAscii(_ n: Int) -> Character { return asciiGradient[n - 1] }
let maxIter = asciiGradient.count // 16
func side(_ size: Int, _ start: Double, _ end : Double) -> StrideThrough<Double> {
//    return stride(from: start, to: end, by: (end - start) / Double(size))
    return stride(from: start, through: end, by: (end - start) / Double(size))
}
let m = 1
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

func imperative(c: ℂ) -> Int {
    var z = ℂ(0)
    var i = 0;
    repeat {
        z = z*z + c
        i += 1
    } while (z.isPotentiallyInSet() && i < maxIter)
    return i
}

@inline(__always)
public func CheckResults(
    _ resultsMatch: Bool,
    file: StaticString = #file,
    function: StaticString = #function,
    line: Int = #line
    ) {
    guard _fastPath(resultsMatch) else {
        print("Incorrect result in \(function), \(file):\(line)")
        abort()
    }
}

@inline(never)
public func run_MandelbrotImperative(_ N: Int) {
    for _ in 1...N {
        let result = renderMandelbrot(imperative)
//        print(mandelbrotSet)
//        print(result)
        CheckResults(result == mandelbrotSet)
    }
}

let mandelbrotSet = """
                                .                                \n\
                     .......................                     \n\
                 ...............................                 \n\
              .....................................              \n\
           ...........................................           \n\
         ...............................................         \n\
        .........,,,,,,,,,,,,,,,.........................        \n\
      ......,,,,,,,,,,,,,:::;|;:::,,,......................      \n\
     ....,,,,,,,,,,,,,::::;;|(*@@::::,,,....................     \n\
    ..,,,,,,,,,,,,,::::::;;|*O@@[|;;:::,,,,..................    \n\
   ..,,,,,,,,,,,,:::::;|||!(@@@@@(!|;;::,,,,..................   \n\
  .,,,,,,,,,,,::::;;;|[@@0@@@@@@@@@$@$O;:,,,,,.................  \n\
  ,,,,,,,,,::;;;;;;||[0@@@@@@@@@@@@@@@[|;:,,,,,................  \n\
 ,,,,,:::;;|%(!((!!((@@@@@@@@@@@@@@@@@@@;::,,,,,................ \n\
 ,:::::;;;|![@@@@@@O*@@@@@@@@@@@@@@@@@@*;::,,,,,................ \n\
 ::::;||!(OO@@@@@@@@@@@@@@@@@@@@@@@@@@@|;::,,,,,................ \n\
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@O!|;::,,,,,,................\n\
 ::::;||!(OO@@@@@@@@@@@@@@@@@@@@@@@@@@@|;::,,,,,................ \n\
 ,:::::;;;|![@@@@@@O*@@@@@@@@@@@@@@@@@@*;::,,,,,................ \n\
 ,,,,,:::;;|%(!((!!((@@@@@@@@@@@@@@@@@@@;::,,,,,................ \n\
  ,,,,,,,,,::;;;;;;||[0@@@@@@@@@@@@@@@[|;:,,,,,................  \n\
  .,,,,,,,,,,,::::;;;|[@@0@@@@@@@@@$@$O;:,,,,,.................  \n\
   ..,,,,,,,,,,,,:::::;|||!(@@@@@(!|;;::,,,,..................   \n\
    ..,,,,,,,,,,,,,::::::;;|*O@@[|;;:::,,,,..................    \n\
     ....,,,,,,,,,,,,,::::;;|(*@@::::,,,....................     \n\
      ......,,,,,,,,,,,,,:::;|;:::,,,......................      \n\
        .........,,,,,,,,,,,,,,,.........................        \n\
         ...............................................         \n\
           ...........................................           \n\
              .....................................              \n\
                 ...............................                 \n\
                     .......................                     \n\
                                .                                \

"""

run_MandelbrotImperative(1)
