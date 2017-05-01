import Foundation

func memoryUsed() -> UInt64 {
    var info = mach_task_basic_info()
    var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
    
    let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
        $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
            task_info(mach_task_self_,
                      task_flavor_t(MACH_TASK_BASIC_INFO),
                      $0,
                      &count)
        }
    }
    
    if kerr == KERN_SUCCESS {
        return info.resident_size
    }
    else {
        return 0
    }
}

public func benchmark(_ closure: () -> Void) {
    let memoryBefore = memoryUsed()
    let beforeTime = Date()
    
    closure()
    
    let secondsElapsed = Date().timeIntervalSince(beforeTime)
    let memoryConsumed = Double(memoryUsed() - memoryBefore) / 1024.0 / 1024.0
    
    print("Operation took \(secondsElapsed) seconds and used \(memoryConsumed) MB of memory")
}
