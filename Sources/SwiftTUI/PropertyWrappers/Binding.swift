import Foundation

@propertyWrapper
public struct STBinding<T> {
    let get: () -> T
    let set: (T) -> Void

    public init(get: @escaping () -> T, set: @escaping (T) -> Void) {
        self.get = get
        self.set = set
    }

    public var wrappedValue: T {
        get { get() }
        nonmutating set { set(newValue) }
    }

    public var projectedValue: STBinding<T> { self }
}
