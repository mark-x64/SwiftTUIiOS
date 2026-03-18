import Foundation

public extension STView {
    func underline(_ isActive: Bool = true) -> some STView {
        environment(\.underline, isActive)
    }
}

private struct UnderlineEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool { false }
}

extension EnvironmentValues {
    var underline: Bool {
        get { self[UnderlineEnvironmentKey.self] }
        set { self[UnderlineEnvironmentKey.self] = newValue }
    }
}
