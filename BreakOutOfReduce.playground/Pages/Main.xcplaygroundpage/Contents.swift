/*:
 
 # Break Out of `reduce`
 
 This is a playground that accompanies my [blog post](https://medium.com/@Czajnikowski/break-out-of-reduce-5a0cbbbf5e71).
 
 ## First approach:
*/
import Foundation

let collection = (1 ... 50)

//extension Sequence {
//    func reduce<Result>(
//        _ initialResult: Result,
//        _ nextPartialResult: (Result, Self.Iterator.Element) throws -> Result,
//        until conditionPassForResult: (Result) -> Bool
//        ) rethrows -> Result {
//
//        return try reduce(
//            initialResult,
//            {
//                if conditionPassForResult($0) {
//                    return $0
//                }
//                else {
//                    return try nextPartialResult($0, $1)
//                }
//            }
//        )
//    }
//}
//
//print(collection.reduce(0, +, until: { partialSum in partialSum > 5 }))
/*:
 ## Final solution:
 */
struct BreakConditionError<Result>: Error {
    let result: Result
}

extension Sequence {
    func reduce<Result>(
        _ initialResult: Result,
        _ nextPartialResult: (Result, Self.Iterator.Element) throws -> Result,
        until conditionPassFor: (Result, Self.Iterator.Element) -> Bool
        ) rethrows -> Result {
        
        do {
            return try reduce(
                initialResult,
                {
                    if conditionPassFor($0, $1) {
                        throw BreakConditionError(result: $0)
                    }
                    else {
                        return try nextPartialResult($0, $1)
                    }
                }
            )
        }
        catch let error as BreakConditionError<Result> {
            return error.result
        }
    }
}

print(collection.reduce(0, +, until: { partialSum, _ in partialSum > 5 }))
/*:
 ## A `while` variation:
 */
extension Sequence {
    func reduce<Result>(
        _ initialResult: Result,
        _ nextPartialResult: (Result, Self.Iterator.Element) throws -> Result,
        while conditionPassFor: (Result, Self.Iterator.Element) -> Bool
        ) rethrows -> Result {

        do {
            return try reduce(
                initialResult,
                {
                    let _nextPartialResult = try nextPartialResult($0, $1)
                    if conditionPassFor(_nextPartialResult, $1) {
                        return _nextPartialResult
                    }
                    else {
                        throw BreakConditionError(result: $0)
                    }
                }
            )
        }
        catch let error as BreakConditionError<Result> {
            return error.result
        }
    }
}

print(collection.reduce(0, +, while: { partialSum, _ in partialSum < 5 }))
