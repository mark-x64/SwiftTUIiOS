import Foundation

public extension STView {
    func strikethrough(_ isActive: Bool = true) -> some STView {
        environment(\.strikethrough, isActive)
    }
}

private struct StrikethroughEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool { false }
}

extension EnvironmentValues {
    var strikethrough: Bool {
        get { self[StrikethroughEnvironmentKey.self] }
        set { self[StrikethroughEnvironmentKey.self] = newValue }
    }
}
