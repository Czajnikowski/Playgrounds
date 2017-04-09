/*:
 
 # Break Out of `reduce`
 
 This is a playground that accompanies my [blog post](http://127.0.0.1:4000/2017/04/08/break-out-of-reduce.html).
 
 ## First approach:
*/
import Foundation

let collection = (1 ... 5)

extension Sequence {
    func reduce<Result>(
        _ initialResult: Result,
        _ nextPartialResult: (Result, Self.Iterator.Element) throws -> Result,
        until conditionPassForResult: (Result) -> Bool
        ) rethrows -> Result {
        
        return try reduce(
            initialResult,
            {
                if conditionPassForResult($0) {
                    return $0
                }
                else {
                    return try nextPartialResult($0, $1)
                }
            }
        )
    }
}

print(collection.reduce(0, +, until: { partialSum in partialSum > 5 }))
/*:
 ## Final solution:
 */
enum BreakConditionError<Result>: Error {
    case conditionPassedWithResult(Result)
}

//extension Sequence {
//    func reduce<Result>(
//        _ initialResult: Result,
//        _ nextPartialResult: (Result, Self.Iterator.Element) throws -> Result,
//        until conditionPassFor: (Result, Self.Iterator.Element) -> Bool
//        ) rethrows -> Result {
//        
//        do {
//            return try reduce(
//                initialResult,
//                {
//                    if conditionPassFor($0, $1) {
//                        throw BreakConditionError
//                            .conditionPassedWithResult($0)
//                    }
//                    else {
//                        return try nextPartialResult($0, $1)
//                    }
//                }
//            )
//        }
//        catch BreakConditionError<Result>
//            .conditionPassedWithResult(let result) {
//                return result
//        }
//    }
//}
//
//print(collection.reduce(0, +, until: { partialSum, _ in partialSum > 5 }))
/*:
 ## A `while` variation:
 */
extension Sequence {
    func reduce<Result>(
        _ initialResult: Result,
        _ nextPartialResult: (Result, Self.Iterator.Element) throws -> Result,
        while conditionPassForResult: (Result, Self.Iterator.Element) -> Bool
        ) rethrows -> Result {
        
        do {
            return try reduce(
                initialResult,
                {
                    let _nextPartialResult = try nextPartialResult($0, $1)
                    if conditionPassForResult(_nextPartialResult, $1) {
                        return _nextPartialResult
                    }
                    else {
                        throw BreakConditionError
                            .conditionPassedWithResult($0)
                    }
                }
            )
        }
        catch BreakConditionError<Result>
            .conditionPassedWithResult(let result) {
                return result
        }
    }
}

print(collection.reduce(0, +, while: { partialSum, _ in partialSum < 5 }))
