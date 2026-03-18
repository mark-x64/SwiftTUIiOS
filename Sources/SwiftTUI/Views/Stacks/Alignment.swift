import Foundation

public enum STVerticalAlignment {
    case top
    case center
    case bottom
}

public enum STHorizontalAlignment {
    case leading
    case center
    case trailing
}

public struct STAlignment {
    public var horizontalAlignment: STHorizontalAlignment
    public var verticalAlignment: STVerticalAlignment

    public init(horizontalAlignment: STHorizontalAlignment, verticalAlignment: STVerticalAlignment) {
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
    }

    public static let top = STAlignment(horizontalAlignment: .center, verticalAlignment: .top)
    public static let bottom = STAlignment(horizontalAlignment: .center, verticalAlignment: .bottom)
    public static let center = STAlignment(horizontalAlignment: .center, verticalAlignment: .center)
    public static let topLeading = STAlignment(horizontalAlignment: .leading, verticalAlignment: .top)
    public static let leading = STAlignment(horizontalAlignment: .leading, verticalAlignment: .center)
    public static let bottomLeading = STAlignment(horizontalAlignment: .leading, verticalAlignment: .bottom)
    public static let topTrailing = STAlignment(horizontalAlignment: .trailing, verticalAlignment: .top)
    public static let trailing = STAlignment(horizontalAlignment: .trailing, verticalAlignment: .center)
    public static let bottomTrailing = STAlignment(horizontalAlignment: .trailing, verticalAlignment: .bottom)
}
