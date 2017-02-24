
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


let swiftyComposed = [
    ("lastEnumeratedOrbitSequence     ", lastEnumeratedOrbitSequence),
    ("lastEnumeratedOrbitSequence2    ", lastEnumeratedOrbitSequence2),
    ("lastEnumeratedOrbitSequence3    ", lastEnumeratedOrbitSequence3),
    ("lastEnumeratedOrbitSequence4    ", lastEnumeratedOrbitSequence4),
    //    ("lastEnumeratedOrbitSequence4Len ", lastEnumeratedOrbitSequence4Length),
    ("lastEnumeratedOrbitSequence5    ", lastEnumeratedOrbitSequence5),
    //    ("lastEnumeratedOrbitSequence6    ", lastEnumeratedOrbitSequence6),
    ("lastEnumeratedOrbitSequence7    ", lastEnumeratedOrbitSequence7),
    //    ("lastEnumeratedOrbitSequence8    ", lastEnumeratedOrbitSequence8),
]
