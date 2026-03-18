import Foundation

/// Colors can be used as views. Certain modifiers and views may also take colors as parameters.
///
/// There are different types of colors that can be used, but not all of them are supported by all
/// terminal emulators.
///
/// The named colors are ANSI colors. In many terminal emulators they are user-defined or part of a
/// theme, and bold text automatically uses the bright color variant.
public struct STColor: Hashable {
    private let data: Data

    private enum Data: Hashable {
        case ansi(ANSIColor)
        case xterm(XTermColor)
        case trueColor(TrueColor)
    }

    private init(data: Data) {
        self.data = data
    }

    static func ansi(_ color: ANSIColor) -> STColor {
        STColor(data: .ansi(color))
    }

    /// A low-resolution color from a 6 by 6 by 6 color cube. The red, green and blue components
    /// must be numbers between 0 and 5.
    public static func xterm(red: Int, green: Int, blue: Int) -> STColor {
        STColor(data: .xterm(.color(red: red, green: green, blue: blue)))
    }

    /// A grayscale color with white value between 0 and 23.
    public static func xterm(white: Int) -> STColor {
        STColor(data: .xterm(.grayscale(white: white)))
    }

    /// A 24-bit color value. The red, green and blue components must be numbers between 0 and 255.
    /// Not all terminals support this.
    public static func trueColor(red: Int, green: Int, blue: Int) -> STColor {
        STColor(data: .trueColor(TrueColor(red: red, green: green, blue: blue)))
    }

    #if !os(iOS)
    var foregroundEscapeSequence: String {
        switch data {
        case .ansi(let color):
            return EscapeSequence.setForegroundColor(color)
        case .trueColor(let color):
            return EscapeSequence.setForegroundColor(red: color.red, green: color.green, blue: color.blue)
        case .xterm(let color):
            return EscapeSequence.setForegroundColor(xterm: color.value)
        }
    }

    var backgroundEscapeSequence: String {
        switch data {
        case .ansi(let color):
            return EscapeSequence.setBackgroundColor(color)
        case .trueColor(let color):
            return EscapeSequence.setBackgroundColor(red: color.red, green: color.green, blue: color.blue)
        case .xterm(let color):
            return EscapeSequence.setBackgroundColor(xterm: color.value)
        }
    }
    #endif

    public static var `default`: STColor { STColor.ansi(.default) }

    public static var black: STColor { .ansi(.black) }
    public static var red: STColor { .ansi(.red) }
    public static var green: STColor { .ansi(.green) }
    public static var yellow: STColor { .ansi(.yellow) }
    public static var blue: STColor { .ansi(.blue) }
    public static var magenta: STColor { .ansi(.magenta) }
    public static var cyan: STColor { .ansi(.cyan) }
    public static var white: STColor { .ansi(.white) }

    public static var brightBlack: STColor { .ansi(.brightBlack) }
    public static var brightRed: STColor { .ansi(.brightRed) }
    public static var brightGreen: STColor { .ansi(.brightGreen) }
    public static var brightYellow: STColor { .ansi(.brightYellow) }
    public static var brightBlue: STColor { .ansi(.brightBlue) }
    public static var brightMagenta: STColor { .ansi(.brightMagenta) }
    public static var brightCyan: STColor { .ansi(.brightCyan) }
    public static var brightWhite: STColor { .ansi(.brightWhite) }

    public static var gray: STColor { .brightBlack }
}

struct ANSIColor: Hashable {
    let foregroundCode: Int
    let backgroundCode: Int

    static var `default`: ANSIColor { ANSIColor(foregroundCode: 39, backgroundCode: 49) }

    static var black: ANSIColor { ANSIColor(foregroundCode: 30, backgroundCode: 40) }
    static var red: ANSIColor { ANSIColor(foregroundCode: 31, backgroundCode: 41) }
    static var green: ANSIColor { ANSIColor(foregroundCode: 32, backgroundCode: 42) }
    static var yellow: ANSIColor { ANSIColor(foregroundCode: 33, backgroundCode: 43) }
    static var blue: ANSIColor { ANSIColor(foregroundCode: 34, backgroundCode: 44) }
    static var magenta: ANSIColor { ANSIColor(foregroundCode: 35, backgroundCode: 45) }
    static var cyan: ANSIColor { ANSIColor(foregroundCode: 36, backgroundCode: 46) }
    static var white: ANSIColor { ANSIColor(foregroundCode: 37, backgroundCode: 47) }

    static var brightBlack: ANSIColor { ANSIColor(foregroundCode: 90, backgroundCode: 100) }
    static var brightRed: ANSIColor { ANSIColor(foregroundCode: 91, backgroundCode: 101) }
    static var brightGreen: ANSIColor { ANSIColor(foregroundCode: 92, backgroundCode: 102) }
    static var brightYellow: ANSIColor { ANSIColor(foregroundCode: 93, backgroundCode: 103) }
    static var brightBlue: ANSIColor { ANSIColor(foregroundCode: 94, backgroundCode: 104) }
    static var brightMagenta: ANSIColor { ANSIColor(foregroundCode: 95, backgroundCode: 105) }
    static var brightCyan: ANSIColor { ANSIColor(foregroundCode: 96, backgroundCode: 106) }
    static var brightWhite: ANSIColor { ANSIColor(foregroundCode: 97, backgroundCode: 107) }
}

struct XTermColor: Hashable {
    let value: Int

    static func color(red: Int, green: Int, blue: Int) -> XTermColor {
        guard red >= 0, red < 6, green >= 0, green < 6, blue >= 0, blue < 6 else {
            fatalError("Color values must lie between 1 and 5")
        }
        let offset = 16 // system colors
        return XTermColor(value: offset + (6 * 6 * red) + (6 * green) + blue)
    }

    static func grayscale(white: Int) -> XTermColor {
        guard white >= 0, white < 24 else {
            fatalError("Color value must lie between 1 and 24")
        }
        let offset = 16 + (6 * 6 * 6)
        return XTermColor(value: offset + white)
    }
}

struct TrueColor: Hashable {
    let red: Int
    let green: Int
    let blue: Int
}

#if canImport(UIKit)
import UIKit

extension STColor {
    var uiColor: UIColor {
        switch data {
        case .ansi(let color):
            return color.uiColor
        case .xterm(let color):
            return color.uiColor
        case .trueColor(let color):
            return UIColor(
                red: CGFloat(color.red) / 255.0,
                green: CGFloat(color.green) / 255.0,
                blue: CGFloat(color.blue) / 255.0,
                alpha: 1.0
            )
        }
    }
}

extension ANSIColor {
    var uiColor: UIColor {
        switch foregroundCode {
        case 39: return UIColor(white: 0.78, alpha: 1.0) // default fg: light gray
        case 30: return .black
        case 31: return UIColor(red: 0.8, green: 0, blue: 0, alpha: 1.0)
        case 32: return UIColor(red: 0, green: 0.8, blue: 0, alpha: 1.0)
        case 33: return UIColor(red: 0.8, green: 0.8, blue: 0, alpha: 1.0)
        case 34: return UIColor(red: 0, green: 0, blue: 0.8, alpha: 1.0)
        case 35: return UIColor(red: 0.8, green: 0, blue: 0.8, alpha: 1.0)
        case 36: return UIColor(red: 0, green: 0.8, blue: 0.8, alpha: 1.0)
        case 37: return UIColor(white: 0.75, alpha: 1.0)
        case 90: return UIColor(white: 0.5, alpha: 1.0)
        case 91: return UIColor(red: 1.0, green: 0.33, blue: 0.33, alpha: 1.0)
        case 92: return UIColor(red: 0.33, green: 1.0, blue: 0.33, alpha: 1.0)
        case 93: return UIColor(red: 1.0, green: 1.0, blue: 0.33, alpha: 1.0)
        case 94: return UIColor(red: 0.33, green: 0.33, blue: 1.0, alpha: 1.0)
        case 95: return UIColor(red: 1.0, green: 0.33, blue: 1.0, alpha: 1.0)
        case 96: return UIColor(red: 0.33, green: 1.0, blue: 1.0, alpha: 1.0)
        case 97: return .white
        default: return UIColor(white: 0.78, alpha: 1.0)
        }
    }

    var backgroundUIColor: UIColor {
        switch backgroundCode {
        case 49: return .black // default bg
        default: return uiColor
        }
    }
}

extension XTermColor {
    var uiColor: UIColor {
        let index = value
        if index < 16 {
            // System colors — map through ANSIColor
            let fgCodes = [30, 31, 32, 33, 34, 35, 36, 37, 90, 91, 92, 93, 94, 95, 96, 97]
            let ansi = ANSIColor(foregroundCode: fgCodes[index], backgroundCode: 0)
            return ansi.uiColor
        } else if index < 232 {
            // 6x6x6 color cube
            let adjusted = index - 16
            let r = adjusted / 36
            let g = (adjusted % 36) / 6
            let b = adjusted % 6
            return UIColor(
                red: r == 0 ? 0 : CGFloat(55 + 40 * r) / 255.0,
                green: g == 0 ? 0 : CGFloat(55 + 40 * g) / 255.0,
                blue: b == 0 ? 0 : CGFloat(55 + 40 * b) / 255.0,
                alpha: 1.0
            )
        } else {
            // Grayscale ramp: 232-255 -> 8, 18, ..., 238
            let gray = CGFloat(8 + 10 * (index - 232)) / 255.0
            return UIColor(white: gray, alpha: 1.0)
        }
    }
}
#endif
