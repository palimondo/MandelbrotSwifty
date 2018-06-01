//
//  transducers.swift
//  MandelbrotSwifty
//
//  Created by Pavol Vaskovic on 10/05/2018.
//  Copyright © 2018 Pavol Vaskovic. All rights reserved.
//

import Foundation

//type Reducer[A, R] = ((R, A) => R)

protocol RX {
    associatedtype Element
    associatedtype Result
//    var rx: (Element, Result) -> Result { get }
    typealias Reducer = (Element, Result) -> Result
}

//protocol TX {
//    associatedtype A : RX.Reducer
//    associatedtype B : RX.Reducer
//    
//}
//func ~><A: TX.Reducer, B: TX.Reducer>() ->

//type Transducer[A, B] = (Reducer[B, R] => Reducer[A, R]) forSome { type R }

