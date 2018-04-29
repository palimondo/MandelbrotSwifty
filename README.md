# MandelbrotSwifty
This is an exploration of the performance of various semantically equivalent expressions of the algorithm that computes Mandelbrot Set. My original goal was to write the code in fully functional style, but the performance issues I have encountered made me explore the design space in search of a style that works well with the current Swift compiler. The project started in Swift 1.0 with point free style of functional programming (iteration primitives expressed as free functions `take`, `takeWhile`, `iterate` that returned `Generator`s). Later rewrite in Swift 3 converted this to the new `Iterator` protocol. Next variant included fluent interface style (`seq.prefix()`, `prefix(while:)`, etc.) and various hybrid approaches, all in search of something that would perform on par with the imperative code.

## ToDo
* Migrate to Swift 4
* Evaluate the current state of performance
