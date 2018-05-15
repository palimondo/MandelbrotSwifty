@inline(__always)
func isPotentiallyInSet(c: ℂ) -> Bool {
    return c.isPotentiallyInSet()
}

@inline(__always)
func isPotentiallyInSet2(s: (Int, ℂ)) -> Bool {
    return s.1.isPotentiallyInSet() && s.0 < maxIter
}

typealias OrbitState = (z: ℂ, c: ℂ)

func orbit(state: inout OrbitState) -> ℂ? {
    let (z, c) = state
    state.z = z * z + c
    return z
}

@inline(__always)
func quadraticOrbit(c: ℂ) -> UnfoldSequence<ℂ, OrbitState> {
    return sequence(state: (ℂ(0), c), next: orbit)
}

func isPotentiallyInSet(i: Int, c: ℂ) -> Bool {
    return i < maxIter && c.isPotentiallyInSet()
}

func slpwpel(c: ℂ) -> Int {
    let s = sequence(first: ℂ(0), next: {z in z * z + c})
        .lazy
        .prefix(while: {$0.isPotentiallyInSet()})
    return s.prefix(maxIter) // TODO report bug: ambiguous #$%
        .enumerated()
        .last()!.0 + 1
}

func slpwepl(c: ℂ) -> Int {
    let s = sequence(first: ℂ(0), next: {z in z * z + c})
        .lazy
        .prefix(while: {$0.isPotentiallyInSet()})  // TODO report bug: ambiguous #$%
    return s.enumerated()
        .prefix(maxIter)
        .last()!.0 + 1
}

func selpwl(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        .enumerated()
        .lazy
        .prefix(while: {$1.isPotentiallyInSet() && $0 < maxIter})
        .last()!.0 + 1
}

func se_pwl(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        .enumerated()
        ._prefix(while: {$1.isPotentiallyInSet() && $0 < maxIter})
        .last()!.0 + 1
}

func selpwsc(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        .enumerated()
        .lazy
        .prefix(while: isPotentiallyInSet2) // Ambiguous use of 'isPotentiallyInSet'
        .count()
}

func se_pwsc(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        .enumerated()
        ._prefix(while: isPotentiallyInSet2) // Ambiguous use of 'isPotentiallyInSet'
        .count()
}

func selpwc(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        .enumerated()
        .lazy
        .prefix(while: {$1.isPotentiallyInSet() && $0 < maxIter})
        .count()
}

func _selpwc(c: ℂ) -> Int {
    return sequence(state: (ℂ(0), c), next: orbit)
        .enumerated()
        .lazy
        .prefix(while: {$1.isPotentiallyInSet() && $0 < maxIter})
        .count()
}

func se_pwc(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        .enumerated()
        ._prefix(while: {$1.isPotentiallyInSet() && $0 < maxIter})
        .count()
}

func lse_pw(c: ℂ) -> Int {
    return length(
        sequence(first: ℂ(0), next: {z in z * z + c})
            .enumerated()
            ._prefix(while: {$1.isPotentiallyInSet() && $0 < maxIter}))
}

func s__e__pwl(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        .__enumerated()
        .__prefix(while: {$1.isPotentiallyInSet() && $0 < maxIter})
        .last()!.0 + 1
}

func s__pw__p__el(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        .__prefix(while: {$0.isPotentiallyInSet()})
        .__prefix(maxIter)
        .__enumerated()
        .last()!.0 + 1
}

func s_e_pwl(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        ._enumerated()
        ._prefix(while: {$1.isPotentiallyInSet() && $0 < maxIter})
        .last()!.0 + 1
}

func s_pw_p_el(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        ._prefix(while: {$0.isPotentiallyInSet()})
        ._prefix(maxIter)
        ._enumerated()
        .last()!.0 + 1
}

func slpwpc(c: ℂ) -> Int {
    let s = sequence(first: ℂ(0), next: {z in z * z + c}).lazy
    return s
        .prefix(while: {$0.isPotentiallyInSet()})
        .prefix(maxIter)
        .count()
}

func sl_pw_pc(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        .lazy
        ._prefix(while: {$0.isPotentiallyInSet()})
        ._prefix(maxIter)
        .count()
}

func sl_pw__p_c(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        .lazy
        ._prefix(while: {$0.isPotentiallyInSet()})
        .__prefix_(maxIter)
        .count()
}

func _s_pw__p_c(c: ℂ) -> Int {
    return quadraticOrbit(c: c)
        ._prefix(while: {$0.isPotentiallyInSet()})
        .__prefix_(maxIter)
        .count()
}

func _s__pw__p_c(c: ℂ) -> Int {
    return quadraticOrbit(c: c)
        .__prefix(while: {$0.isPotentiallyInSet()})
        .__prefix_(maxIter)
        .count()
}

func slppwc(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        .lazy
        .prefix(maxIter)
        .prefix(while: {$0.isPotentiallyInSet()})
        .count()
}

func _slpwpc(c: ℂ) -> Int {
    return sequence(state: (ℂ(0), c), next: orbit)
        .lazy
        .prefix(while: {$0.isPotentiallyInSet()})
        .prefix(maxIter)
        .count()
}

func _slppwc(c: ℂ) -> Int {
    return sequence(state: (ℂ(0), c), next: orbit)
        .lazy
        .prefix(maxIter)
        .prefix(while: {$0.isPotentiallyInSet()})
        .count()
}

func _sl_pw_pc(c: ℂ) -> Int {
    return sequence(state: (ℂ(0), c), next: orbit)
        .lazy
        ._prefix(while: {$0.isPotentiallyInSet()})
        ._prefix(maxIter)
        .count()
}

func s_pw_pc(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        ._prefix(while: {$0.isPotentiallyInSet()})
        ._prefix(maxIter)
        .count()
}

func _sl_p_pwc(c: ℂ) -> Int {
    return sequence(state: (ℂ(0), c), next: orbit)
        .lazy
        ._prefix(maxIter)
        ._prefix(while: {$0.isPotentiallyInSet()})
        .count()
}

func s_p_pwc(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        ._prefix(maxIter)
        ._prefix(while: {$0.isPotentiallyInSet()})
        .count()
}

func s_e_pwc(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        ._enumerated()
        ._prefix(while: {$0 < maxIter && $1.isPotentiallyInSet()})
        .count()
}

func s_e_pwsc(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        ._enumerated()
        ._prefix(while: isPotentiallyInSet)
        .count()
}

func _s_e_pwc(c: ℂ) -> Int {
    return quadraticOrbit(c: c)
        ._enumerated()
        ._prefix(while: {$0 < maxIter && $1.isPotentiallyInSet()})
        .count()
}

func _s_e_pwsc(c: ℂ) -> Int {
    return quadraticOrbit(c: c)
        ._enumerated()
        ._prefix(while: isPotentiallyInSet)
        .count()
}

func _s_e___pwc(c: ℂ) -> Int {
    return quadraticOrbit(c: c)
        .__enumerated_()
        .__prefix(while: {$0 < maxIter && $1.isPotentiallyInSet()})
        .count()
}

func _s_e___pwsc(c: ℂ) -> Int {
    return quadraticOrbit(c: c)
        .__enumerated_()
        .__prefix(while: isPotentiallyInSet)
        .count()
}

func _s_e____pwsc(c: ℂ) -> Int {
    return quadraticOrbit(c: c)
        .__enumerated_()
        .___prefix(while: isPotentiallyInSet)
        .count()
}

func sl__pw__pc(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        .lazy
        .__prefix(while: {$0.isPotentiallyInSet()})
        .__prefix(maxIter)
        .count()
}

func sl__pws__pc(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        .lazy
        .__prefix(while: isPotentiallyInSet)
        .__prefix(maxIter)
        .count()
}

func sl__pws__p_c(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        .lazy
        .__prefix(while: isPotentiallyInSet)
        .__prefix_(maxIter)
        .count()
}

func _s__pws__pc(c: ℂ) -> Int {
    return quadraticOrbit(c: c)
        .__prefix(while: isPotentiallyInSet)
        .__prefix(maxIter)
        .count()
}

func _s__pws__p_c(c: ℂ) -> Int {
    return quadraticOrbit(c: c)
        .__prefix(while: isPotentiallyInSet)
        .__prefix_(maxIter)
        .count()
}

func sl__pw___pc(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        .lazy
        .__prefix(while: {$0.isPotentiallyInSet()})
        .___prefix(maxIter)
        .count()
}


func sl__pws___pc(c: ℂ) -> Int {
    return sequence(first: ℂ(0), next: {z in z * z + c})
        .lazy
        .__prefix(while: isPotentiallyInSet)
        .___prefix(maxIter)
        .count()
}



let swiftyComposed = [
//    ("slpwpel                         ", slpwpel),
//    ("slpwepl                         ", slpwepl),
//    ("selpwl                          ", selpwl),
//    ("se_pwl                          ", se_pwl),
    ("selpwc                          ", selpwc),
    ("_selpwc                         ", _selpwc),
    ("selpwsc                         ", selpwsc),
    ("se_pwsc                         ", se_pwsc),
//    ("se_pwc                          ", se_pwc),
//    ("lse_pw                          ", lse_pw),
//    ("s__e__pwl                       ", s__e__pwl),
//    ("s__pw__p__el                    ", s__pw__p__el),
//    ("s_e_pwl                         ", s_e_pwl),
//    ("s_pw_p_el                       ", s_pw_p_el),
//    ("slpwpc                          ", slpwpc),
//    ("s_pw_pc                         ", s_pw_pc),
    ("sl_pw_pc                        ", sl_pw_pc),
    ("sl_pw__p_c                      ", sl_pw__p_c),
    ("_s_pw__p_c                      ", _s_pw__p_c),
    ("_s__pw__p_c                     ", _s__pw__p_c),
//    ("_slpwpc                         ", _slpwpc),
//    ("_sl_pw_pc                       ", _sl_pw_pc),
//    ("slppwc                          ", slppwc),
//    ("_slppwc                         ", _slppwc),
    ("_sl_p_pwc                       ", _sl_p_pwc),
//    ("s_p_pwc                         ", s_p_pwc),
//    ("sl__pw__pc                      ", sl__pw__pc),
//    ("sl__pw___pc                     ", sl__pw___pc),
    ("sl__pws__pc                     ", sl__pws__pc),
    ("sl__pws__p_c                    ", sl__pws__p_c),
    ("_s__pws__pc                     ", _s__pws__pc),
    ("_s__pws__p_c                    ", _s__pws__p_c),
//    ("sl__pws___pc                    ", sl__pws___pc),
    ("s_e_pwc                         ", s_e_pwc),
    ("s_e_pwsc                        ", s_e_pwsc),
    ("_s_e_pwc                        ", _s_e_pwc),
    ("_s_e_pwsc                       ", _s_e_pwsc),
    ("_s_e___pwc                      ", _s_e___pwc),
    ("_s_e___pwsc                     ", _s_e___pwsc),
    ("_s_e____pwsc                    ", _s_e____pwsc),
    // TODO create variant with __enumerated (sequence based), that fuses like se_pwl
]
