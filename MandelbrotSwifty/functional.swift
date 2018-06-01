let quadrat: (ℂ, ℂ) -> ℂ = {c, z in z*z + c}

let orbit: (ℂ) -> AnyIterator<ℂ> = {c in iterate(curry(quadrat)(c), x0: ℂ(0))}

let iterations: (AnyIterator<ℂ>) -> Int = {seq in
    length(takeWhile({z in z.isPotentiallyInSet()}, source: take(maxIter, source: seq)))
}
let _iterations: (AnyIterator<ℂ>) -> Int = {seq in
    length(takeWhile({z in z.isPotentiallyInSet()}, source: seq.prefix(maxIter)))
}
let iterations2: (AnyIterator<ℂ>) -> Int = {seq in
    length(_takeWhile({z in z.isPotentiallyInSet()}, source: take(maxIter, source: seq)))
}
let _iterations2: (AnyIterator<ℂ>) -> Int = {seq in
    length(_takeWhile({z in z.isPotentiallyInSet()}, source: seq.prefix(maxIter)))
}
let __iterations: (AnyIterator<ℂ>) -> Int = {seq in
    seq.prefix(maxIter).lazy.prefix(while: {z in z.isPotentiallyInSet()}).reduce(0, {i, _ in i + 1})
}

let ___iterations: (AnyIterator<ℂ>) -> Int = {seq in
    seq.lazy.prefix(maxIter).prefix(while: {z in z.isPotentiallyInSet()}).reduce(0, {i, _ in i + 1})
}

let iterations__:(UnfoldSequence<ℂ, (ℂ?, Bool)>) -> Int = { seq in
    length(takeWhile__(while: {z in z.isPotentiallyInSet()}, seq: take__(maxIter, seq: seq)))
}

let iterations_:(UnfoldSequence<ℂ, (ℂ?, Bool)>) -> Int = { seq in
    length(takeWhile_(while: {z in z.isPotentiallyInSet()}, seq: take_(maxIter, seq: seq)))
}

let iterationsCount = { c in length(
    takeWhile__(while: {z in z.isPotentiallyInSet()},
                seq: take__(maxIter, seq:
                    sequence(first: ℂ(0), next: {z in z * z + c}))))
}

//let _orbit = {z in sequence(first: ℂ(0), next: curry({c, z in z*z + c})(z))}
let _orbit = {c in AnyIterator(sequence(first: ℂ(0), next: curry({c, z in z*z + c})(c)))}
let orbit_ = {c in sequence(first: ℂ(0), next: {z in z * z + c}) }

func quad(_ c: ℂ, _ z: ℂ) -> ℂ { return z*z + c }
let orbitFuncQuad = {c in AnyIterator(sequence(first: ℂ(0), next: curry(quad)(c)))}
let orbitFuncQuadrat = {c in AnyIterator(sequence(first: ℂ(0), next: curry(quadrat)(c)))}

func quadC(_ c: ℂ) -> (ℂ) -> ℂ { return {z in z*z + c}}
let orbitQuadClosure = {c in AnyIterator(sequence(first: ℂ(0), next: quadC(c)))}

let functional = [
    ("orbitFuncQuad                   ", __iterations >>> orbitFuncQuad),
    ("orbit__ ___iterations           ", ___iterations >>> orbit),
    ("orbitFuncQuadrat                ", __iterations >>> orbitFuncQuadrat),
    ("orbitQuadClosure                ", __iterations >>> orbitQuadClosure),
    ("takeWhile take length iterate   ", iterations >>> orbit),
    ("takeWhile prefix length iterate ", _iterations >>> orbit),
    ("_takeWhile take length iterate  ", iterations2 >>> orbit),
    ("_takeWhile prefix length iterate", _iterations2 >>> orbit),
    ("prefix prefix reduce iterate    ", __iterations >>> orbit),
    ("takeWhile take length sequence  ", iterations >>> _orbit),
    ("takeWhile prefix length sequence", _iterations >>> _orbit),
    ("prefix prefix reduce sequence   ", __iterations >>> _orbit),
    ("takeWhile_ take_ length sequence", iterations_ >>> orbit_),
    ("takeWhile__ take__ len. sequence", iterations__ >>> orbit_),
    ("iterationsCount functional comp.", iterationsCount),
]
