import Foundation

extension Optional where Wrapped: Any {
    public var nsObject: NSObject {
        return self as! NSObject
    }
}
