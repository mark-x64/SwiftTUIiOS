import Foundation

public protocol STView {
    associatedtype Body: STView
    @STViewBuilder var body: Body { get }
}

extension Never: STView {
    public var body: Never {
        fatalError()
    }

    public typealias Body = Never
}
