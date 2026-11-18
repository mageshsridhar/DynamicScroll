//
//  PagedScrollView.swift
//  Dynamic Scroll
//
//  Created by Magesh Sridhar on 12/29/24.
//

import SwiftUI

struct ScrollProportion: PreferenceKey {
    static let defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

/// A paging image carousel that scrolls along `axis` and reports which image is showing.
struct PagedScrollView: View {
    let axis: Axis
    @Binding var currentIndex: Int

    /// Visible length of the scroll view along `axis`.
    @State private var viewportLength: CGFloat = 0

    private var stack: AnyLayout {
        axis == .horizontal
            ? AnyLayout(HStackLayout(spacing: 3))
            : AnyLayout(VStackLayout(spacing: 0))
    }

    private func length(of size: CGSize) -> CGFloat {
        axis == .horizontal ? size.width : size.height
    }

    var body: some View {
        ScrollView(axis == .horizontal ? .horizontal : .vertical, showsIndicators: false) {
            stack {
                ForEach(0..<ImageView.count, id: \.self) { i in
                    ImageView(i: i)
                        .id(i)
                }
            }
            .background(
                GeometryReader { geo in
                    let frame = geo.frame(in: .named("scroll"))
                    let scrolled = axis == .horizontal ? -frame.minX : -frame.minY
                    let scrollLength = length(of: geo.size) - viewportLength
                    let proportion = min(max(scrolled / scrollLength, 0), 1)

                    Color.clear
                        .preference(key: ScrollProportion.self, value: proportion)
                        .onPreferenceChange(ScrollProportion.self) { proportion in
                            // Rounded, not truncated: vertical pages are slightly taller than the
                            // viewport, so page 2 measures as 1.99 and would otherwise report page 1.
                            withAnimation(.spring()) {
                                currentIndex = Int((proportion * CGFloat(ImageView.count - 1)).rounded())
                            }
                        }
                }
            )
            .scrollTargetLayout()
        }
        .frame(maxHeight: 491)
        .background(
            GeometryReader { geo in
                Color.clear.onAppear {
                    viewportLength = length(of: geo.size)
                }
            }
        )
        .coordinateSpace(name: "scroll")
        .scrollTargetBehavior(.viewAligned)
    }
}
