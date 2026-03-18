import Foundation

public extension STView {
    func foregroundColor(_ color: STColor) -> some STView {
        environment(\.foregroundColor, color)
    }
}

private struct ForegroundColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color { .default }
}

extension EnvironmentValues {
    var foregroundColor: Color {
        get { self[ForegroundColorEnvironmentKey.self] }
        set { self[ForegroundColorEnvironmentKey.self] = newValue }
    }
}
