import Foundation

@resultBuilder
public struct STViewBuilder {
    public static func buildBlock() -> STEmptyView { STEmptyView() }

    public static func buildBlock<Content: STView>(_ content: Content) -> Content { content }

    public static func buildIf<V: STView>(_ content: V)  -> V  { content }

    public static func buildEither<TrueContent: STView, FalseContent: STView>(first: TrueContent) -> _ConditionalView<TrueContent, FalseContent> {
        _ConditionalView(content: .a(first))
    }

    public static func buildEither<TrueContent: STView, FalseContent: STView>(second: FalseContent) -> _ConditionalView<TrueContent, FalseContent> {
        _ConditionalView(content: .b(second))
    }

    public static func buildBlock<C0: STView, C1: STView>(_ c0: C0, _ c1: C1) -> TupleView2<C0, C1> {
        TupleView2(content: (c0, c1))
    }

    public static func buildBlock<C0: STView, C1: STView, C2: STView>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleView3<C0, C1, C2> {
        TupleView3(content: (c0, c1, c2))
    }

    public static func buildBlock<C0: STView, C1: STView, C2: STView, C3: STView>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> TupleView4<C0, C1, C2, C3> {
        TupleView4(content: (c0, c1, c2, c3))
    }

    public static func buildBlock<C0: STView, C1: STView, C2: STView, C3: STView, C4: STView>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> TupleView5<C0, C1, C2, C3, C4> {
        TupleView5(content: (c0, c1, c2, c3, c4))
    }

    public static func buildBlock<C0: STView, C1: STView, C2: STView, C3: STView, C4: STView, C5: STView>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> TupleView6<C0, C1, C2, C3, C4, C5> {
        TupleView6(content: (c0, c1, c2, c3, c4, c5))
    }

    public static func buildBlock<C0: STView, C1: STView, C2: STView, C3: STView, C4: STView, C5: STView, C6: STView>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> TupleView7<C0, C1, C2, C3, C4, C5, C6> {
        TupleView7(content: (c0, c1, c2, c3, c4, c5, c6))
    }

    public static func buildBlock<C0: STView, C1: STView, C2: STView, C3: STView, C4: STView, C5: STView, C6: STView, C7: STView>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> TupleView8<C0, C1, C2, C3, C4, C5, C6, C7> {
        TupleView8(content: (c0, c1, c2, c3, c4, c5, c6, c7))
    }

    public static func buildBlock<C0: STView, C1: STView, C2: STView, C3: STView, C4: STView, C5: STView, C6: STView, C7: STView, C8: STView>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> TupleView9<C0, C1, C2, C3, C4, C5, C6, C7, C8> {
        TupleView9(content: (c0, c1, c2, c3, c4, c5, c6, c7, c8))
    }

    public static func buildBlock<C0: STView, C1: STView, C2: STView, C3: STView, C4: STView, C5: STView, C6: STView, C7: STView, C8: STView, C9: STView>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> TupleView10<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9> {
        TupleView10(content: (c0, c1, c2, c3, c4, c5, c6, c7, c8, c9))
    }

}
