import Foundation
import RxSwift

public protocol Optionable {
    associatedtype Wrapped
    
    func forceUnwrap() -> Wrapped
    func unwrap(with defaultValue: Wrapped) -> Wrapped
    func isNil() -> Bool
}

extension Optional: Optionable {
    
    public func forceUnwrap() -> Wrapped {
        switch self {
        case .some(let value):
            return value
            
        case .none:
            fatalError()
        }
    }
    
    public func unwrap(with defaultValue: Wrapped) -> Wrapped {
        switch self {
        case .some(let value):
            return value
            
        case .none:
            return defaultValue
        }
    }
    
    public func isNil() -> Bool {
        switch self {
        case .some:
            return false
            
        case .none:
            return true
        }
    }
}

extension ObservableType where Element: Optionable {
    
    /// convert current stream to a bool value that indicates wheter value is nil
    public func isNil() -> Observable<Bool> {
        return map { wrapped -> Bool in wrapped.isNil() }
    }
    
    /// converts current stream with its unwrapped value (or `defaultValue` in case it's nil)
    public func unwrap(with defaultValue: Element.Wrapped) -> Observable<Element.Wrapped> {
        return map { wrapped -> Element.Wrapped in wrapped.unwrap(with: defaultValue) }
    }
    
    /// converts current stream with its unwrapped value
    public func unwrap() -> Observable<Element.Wrapped> {
        return filter { wrapped -> Bool in !wrapped.isNil() }
            .map { wrapped -> Element.Wrapped in wrapped.forceUnwrap() }
    }
}
