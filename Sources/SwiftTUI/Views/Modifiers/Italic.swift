import Foundation

public extension STView {
    func italic(_ isActive: Bool = true) -> some STView {
        environment(\.italic, isActive)
    }
}

private struct ItalicEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool { false }
}

extension EnvironmentValues {
    var italic: Bool {
        get { self[ItalicEnvironmentKey.self] }
        set { self[ItalicEnvironmentKey.self] = newValue }
    }
}
