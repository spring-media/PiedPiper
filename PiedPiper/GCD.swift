import Foundation

/// Internal struct for easy GCD usage
public struct GCD: GCDQueue {
  private static let mainQueue = GCD(queue: DispatchQueue.main)
  private static let backgroundQueue = GCD(queue: DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault))
  
  /**
  Asynchronously dispatches a closure on the main queue
   
  - parameter closure: The closure you want to dispatch on the queue
   
  - returns: The result of the execution of the closure
  */
  public static func main<T>(_ closure: ((Void) -> T)) -> AsyncDispatch<T> {
    return mainQueue.async(closure)
  }
  
  /**
   Asynchronously dispatches a closure on the default priority background queue
   
  - parameter closure: The closure you want to dispatch on the queue
   
  - returns: The result of the execution of the closure
  */
  static public func background<T>(_ closure: ((Void) -> T)) -> AsyncDispatch<T> {
    return backgroundQueue.async(closure)
  }
  
  /**
  Creates a new serial queue with the given name
   
  - parameter name: The name for the new queue
   
  - returns: The newly created GCDQueue
  */
  public static func serial(_ name: String) -> GCDQueue {
    return GCD(queue: DispatchQueue(label: name, attributes: DispatchQueueAttributes.serial))
  }
  
  /**
  Instantiates a new GCD value with a custom dispatch queue
   
  - parameter queue: The custom dispatch queue you want to use with this GCD value
  */
  public init(queue: DispatchQueue) {
    self.queue = queue
  }
  
  /// The GCD queue associated to this GCD value
  public let queue: DispatchQueue
}

/// An async dispatch operation
public class AsyncDispatch<T> {
  /// The inner async operation
  private(set) public var future: Future<T>
  
  init(operation: Future<T>) {
    self.future = operation
  }
  
  private func dispatchClosureAsync<O>(_ closure: (T) -> O, queue: GCDQueue) -> AsyncDispatch<O> {
    let innerResult = Promise<O>()
    let result = AsyncDispatch<O>(operation: innerResult.future)
    
    future.onSuccess { value in
      queue.async {
        innerResult.succeed(closure(value))
      }
    }
    
    return result
  }
  
  /**
  Chains a closure taking a T input and returning an O output on the main queue 
  
  - parameter closure: The closure you want to dispatch on the main queue
   
  - returns: An AsyncDispatch object. You can keep chaining async calls on this object
  */
  public func main<O>(_ closure: (T) -> O) -> AsyncDispatch<O> {
    return dispatchClosureAsync(closure, queue: GCD.mainQueue)
  }
  
  /**
  Chains a closure taking a T input and returning an O output on a background queue
   
  - parameter closure: The closure you want to dispatch on the background queue
   
  - returns: An AsyncDispatch object. You can keep chaining async calls on this object
  */
  public func background<O>(_ closure: (T) -> O) -> AsyncDispatch<O> {
    return dispatchClosureAsync(closure, queue: GCD.backgroundQueue)
  }
}

/// Abstracts a GCD queue
public protocol GCDQueue {
  /// The underlying dispatch_queue_t
  var queue: DispatchQueue { get }
}

extension GCDQueue {
  
  /**
  Dispatches a given closure on the queue asynchronously
   
  - parameter closure: The closure you want to dispatch on the queue
   
  - returns: An AsyncDispatch object. You can keep chaining async calls on this object
  */
  public func async<T>(_ closure: (Void) -> T) -> AsyncDispatch<T> {
    let innerResult = Promise<T>()
    let result = AsyncDispatch<T>(operation: innerResult.future)
    
    queue.async {
      innerResult.succeed(closure())
    }
    
    return result
  }
}
