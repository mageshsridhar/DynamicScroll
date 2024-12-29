//
//  VerticalScrollView.swift
//  Dynamic Scroll
//
//  Created by Magesh Sridhar on 12/29/24.
//

import SwiftUI

struct VerticalScrollView: View {
    @State private var scrollViewHeight: CGFloat = 0
    @State private var proportion: CGFloat = 0
    @Binding var currentIndex : Int
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(0...4, id: \.self) { i in
                    ImageView(i: i)
                        .id(i)
                }
            }
            .background(
                GeometryReader { geo in
                    let scrollLength = geo.size.height - scrollViewHeight
                    let rawProportion = -geo.frame(in: .named("scroll")).minY / scrollLength
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
            ).scrollTargetLayout()
        }.frame(maxHeight: 491)
            .background(
                GeometryReader { geo in
                    Color.clear.onAppear {
                        scrollViewHeight = geo.size.height
                    }
                }
            )
            .coordinateSpace(name: "scroll")
            .scrollTargetBehavior(.viewAligned)
    }
}
