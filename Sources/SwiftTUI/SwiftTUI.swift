// MARK: - Backward-compatible typealiases
//
// On macOS (terminal usage): both original names and ST-prefixed names are public.
// On iOS: only ST-prefixed names are public; original names are internal
// (prevents conflicts with SwiftUI).

// Views
#if os(iOS) || os(tvOS)
typealias View = STView
typealias ViewBuilder = STViewBuilder
typealias VStack = STVStack
typealias HStack = STHStack
typealias ZStack = STZStack
typealias Text = STText
typealias Button = STButton
typealias TextField = STTextField
typealias Spacer = STSpacer
typealias Divider = STDivider
typealias ScrollView = STScrollView
typealias GeometryReader = STGeometryReader
typealias Color = STColor
typealias ForEach = STForEach
typealias Group = STGroup
typealias EmptyView = STEmptyView

// Property wrappers
typealias State = STState
typealias Binding = STBinding
typealias Environment = STEnvironment
typealias EnvironmentKey = STEnvironmentKey
typealias EnvironmentValues = STEnvironmentValues

// Layout
typealias Alignment = STAlignment
typealias HorizontalAlignment = STHorizontalAlignment
typealias VerticalAlignment = STVerticalAlignment
#else
public typealias View = STView
public typealias ViewBuilder = STViewBuilder
public typealias VStack = STVStack
public typealias HStack = STHStack
public typealias ZStack = STZStack
public typealias Text = STText
public typealias Button = STButton
public typealias TextField = STTextField
public typealias Spacer = STSpacer
public typealias Divider = STDivider
public typealias ScrollView = STScrollView
public typealias GeometryReader = STGeometryReader
public typealias Color = STColor
public typealias ForEach = STForEach
public typealias Group = STGroup
public typealias EmptyView = STEmptyView

// Property wrappers
public typealias State = STState
public typealias Binding = STBinding
public typealias Environment = STEnvironment
public typealias EnvironmentKey = STEnvironmentKey
public typealias EnvironmentValues = STEnvironmentValues

// Layout
public typealias Alignment = STAlignment
public typealias HorizontalAlignment = STHorizontalAlignment
public typealias VerticalAlignment = STVerticalAlignment
#endif

// ObservedObject (Combine-dependent)
#if canImport(Combine)
    #if os(iOS) || os(tvOS)
    typealias ObservedObject = STObservedObject
    #else
    public typealias ObservedObject = STObservedObject
    #endif
#endif
