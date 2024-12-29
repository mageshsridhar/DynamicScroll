//
//  HorizontalScrollView.swift
//  Dynamic Scroll
//
//  Created by Magesh Sridhar on 12/29/24.
//

import SwiftUI

struct HorizontalScrollView: View {
    @State private var scrollViewWidth: CGFloat = 0
    @State private var proportion: CGFloat = 0
    @Binding var currentIndex : Int
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 3) {
                ForEach(0...4, id: \.self) { i in
                    ImageView(i: i)
                        .id(i)
                }
            }.background(
                GeometryReader { geo in
                    let scrollLength = geo.size.width - scrollViewWidth
                    let rawProportion = -geo.frame(in: .named("scroll")).minX / scrollLength
                    let proportion = min(max(rawProportion, 0), 1)
                    
                    Color.clear
                        .preference(
                            key: ScrollProportion.self,
                            value: proportion
                        )
                        .onPreferenceChange(ScrollProportion.self) { proportion in
                            self.proportion = proportion
                            withAnimation(.spring()) {
                                currentIndex = Int(proportion * 4)
                            }
                        }
                }
            )
            .scrollTargetLayout()
        }
            .background(
                GeometryReader { geo in
                    Color.clear.onAppear {
                        scrollViewWidth = geo.size.width
                    }
                }
            )
            .coordinateSpace(name: "scroll")
            .frame(maxHeight: 491)
            .scrollTargetBehavior(.viewAligned)
    }
}
