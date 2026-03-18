import Foundation

public protocol STEnvironmentKey {
    associatedtype Value
    static var defaultValue: Value { get }
}

public struct STEnvironmentValues {
    var values: [ObjectIdentifier: Any] = [:]
    public subscript<K: STEnvironmentKey>(key: K.Type) -> K.Value {
        get { values[ObjectIdentifier(key)] as? K.Value ?? K.defaultValue }
        set { values[ObjectIdentifier(key)] = newValue }
    }
}

@propertyWrapper
public struct STEnvironment<T>: AnyEnvironment {
    let keyPath: KeyPath<STEnvironmentValues, T>

    public init(_ keyPath: KeyPath<STEnvironmentValues, T>) {
        self.keyPath = keyPath
    }

    var valueReference = EnvironmentReference()

    public var wrappedValue: T {
        get {
            guard let node = valueReference.node else {
                assertionFailure("Attempting to access @Environment variable before view is instantiated")
                return EnvironmentValues()[keyPath: keyPath]
            }
            let environmentValues = makeEnvironment(node: node, transform: { _ in })
            return environmentValues[keyPath: self.keyPath]
        }
        set {}
    }

    private func makeEnvironment(node: Node, transform: (inout EnvironmentValues) -> Void) -> EnvironmentValues {
        if let parent = node.parent {
            return makeEnvironment(node: parent) {
                node.environment?(&$0)
                transform(&$0)
            }
        }
        var environmentValues = EnvironmentValues()
        node.environment?(&environmentValues)
        transform(&environmentValues)
        return environmentValues
    }
}

protocol AnyEnvironment {
    var valueReference: EnvironmentReference { get }
}

class EnvironmentReference {
    weak var node: Node?
}
