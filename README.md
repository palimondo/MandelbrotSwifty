# MandelbrotSwifty
This is an exploration of the performance of various semantically equivalent expressions of the algorithm that computes Mandelbrot Set. My original goal was to write the code in fully functional style, but the performance issues I have encountered made me explore the design space in search of a style that works well with the current Swift compiler. The project started in Swift 1.0 with point free style of functional programming (iteration primitives expressed as free functions `take`, `takeWhile`, `iterate` that returned `Generator`s). Later rewrite in Swift 3 converted this to the new `Iterator` protocol. Next variant included fluent interface style (`seq.prefix()`, `prefix(while:)`, etc.) and various hybrid approaches, all in search of something that would perform on par with the imperative code.

## Tags

* [swift-3.1 from May 2017](https://github.com/palimondo/MandelbrotSwifty/tree/swift-3.1/) - The state of experiment that compiled with Swift 3.1.
* [troubling-sequence, form June 2018](https://github.com/palimondo/MandelbrotSwifty/tree/troubling-sequence/) - The state of experiment as of writing [Troubling `Sequence`](https://forums.swift.org/t/troubling-sequence/13130) in Swift Forums.

## ToDo
* ✅<del>Migrate to Swift 4</del>
* Systematize the tested variant generation
* Evaluate the current state of performance
* Extract representative styles into set of benchmarks for the Swift Benchark Suite
