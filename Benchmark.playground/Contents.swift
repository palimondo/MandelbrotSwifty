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



@inline(never)
public func run_MandelbrotImperative(_ N: Int) {
    let s = 0 ..< sequenceCount
    for _ in 1...20*N {
        for _ in 1...reps {
            var result = 0
            for element in s.dropLast(dropCount) {
                result += element
            }
            CheckResults(result == sumCount,
                         "IncorrectResults in DropLastCountableRange: \(result) != \(sumCount)")
        }
    }
}

fileprivate struct MySequence: Sequence {
    let range: CountableRange<Int>
    public func makeIterator() -> IndexingIterator<CountableRange<Int>> {
        return range.makeIterator()
    }
}

@inline(never)
public func run_MandelbrotSwifty(_ N: Int) {
    let s = MySequence(range: 0 ..< sequenceCount)
    for _ in 1...20*N {
        for _ in 1...reps {
            var result = 0
            for element in s.dropLast(dropCount) {
                result += element
            }
            CheckResults(result == sumCount,
                         "IncorrectResults in DropLastSequence: \(result) != \(sumCount)")
        }
    }
}


let expectedResult : StaticString = ""
    + "                                .                                \n"
    + "                     .......................                     \n"
    + "                 ...............................                 \n"
    + "              .....................................              \n"
    + "           ...........................................           \n"
    + "         ...............................................         \n"
    + "        .........,,,,,,,,,,,,,,,.........................        \n"
    + "      ......,,,,,,,,,,,,,:::;|;:::,,,......................      \n"
    + "     ....,,,,,,,,,,,,,::::;;|(*@@::::,,,....................     \n"
    + "    ..,,,,,,,,,,,,,::::::;;|*O@@[|;;:::,,,,..................    \n"
    + "   ..,,,,,,,,,,,,:::::;|||!(@@@@@(!|;;::,,,,..................   \n"
    + "  .,,,,,,,,,,,::::;;;|[@@0@@@@@@@@@$@$O;:,,,,,.................  \n"
    + "  ,,,,,,,,,::;;;;;;||[0@@@@@@@@@@@@@@@[|;:,,,,,................  \n"
    + " ,,,,,:::;;|%(!((!!((@@@@@@@@@@@@@@@@@@@;::,,,,,................ \n"
    + " ,:::::;;;|![@@@@@@O*@@@@@@@@@@@@@@@@@@*;::,,,,,................ \n"
    + " ::::;||!(OO@@@@@@@@@@@@@@@@@@@@@@@@@@@|;::,,,,,................ \n"
    + "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@O!|;::,,,,,,................\n"
    + " ::::;||!(OO@@@@@@@@@@@@@@@@@@@@@@@@@@@|;::,,,,,................ \n"
    + " ,:::::;;;|![@@@@@@O*@@@@@@@@@@@@@@@@@@*;::,,,,,................ \n"
    + " ,,,,,:::;;|%(!((!!((@@@@@@@@@@@@@@@@@@@;::,,,,,................ \n"
    + "  ,,,,,,,,,::;;;;;;||[0@@@@@@@@@@@@@@@[|;:,,,,,................  \n"
    + "  .,,,,,,,,,,,::::;;;|[@@0@@@@@@@@@$@$O;:,,,,,.................  \n"
    + "   ..,,,,,,,,,,,,:::::;|||!(@@@@@(!|;;::,,,,..................   \n"
    + "    ..,,,,,,,,,,,,,::::::;;|*O@@[|;;:::,,,,..................    \n"
    + "     ....,,,,,,,,,,,,,::::;;|(*@@::::,,,....................     \n"
    + "      ......,,,,,,,,,,,,,:::;|;:::,,,......................      \n"
    + "        .........,,,,,,,,,,,,,,,.........................        \n"
    + "         ...............................................         \n"
    + "           ...........................................           \n"
    + "              .....................................              \n"
    + "                 ...............................                 \n"
    + "                     .......................                     \n"
    + "                                .                                "
