/// Typical Result enumeration (aka Either)
public enum Result<T> {
  /// The result contains a Success value
  case success(T)
  
  /// The result contains an error
  case Error(ErrorProtocol)
  
  /// The result was cancelled
  case cancelled
  
  /// The success value of this result, if any
  public var value: T? {
    if case .success(let result) = self {
      return result
    } else {
      return nil
    }
  }
  
  /// The error of this result, if any
  public var error: ErrorProtocol? {
    if case .Error(let issue) = self {
      return issue
    } else {
      return nil
    }
  }
}
