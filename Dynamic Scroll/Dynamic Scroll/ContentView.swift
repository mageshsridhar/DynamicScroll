//
//  ContentView.swift
//  Dynamic Scroll
//
//  Created by Magesh Sridhar on 12/29/24.
//

import SwiftUI
import Foundation

struct ScrollProportion: PreferenceKey {
    static let defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ContentView: View {
    
    @State private var scrollToggle = true
    @State private var offsetToggle = true
    @State private var opacityToggle = true
    @State var currentIndex = 0
    
    var body: some View {
        VStack {
            HStack {
                Text("Dynamic Scroll View Concept").font(.title2).bold()
                Spacer()
            }.padding(.horizontal, 10)
            ZStack {
                if scrollToggle {
                    ScrollViewReader { proxy in
                        VerticalScrollView(currentIndex: $currentIndex)
                            .onAppear {
                                proxy.scrollTo(currentIndex)
                            }
                    }.transition(.opacity)
                } else {
                    ScrollViewReader { proxy in
                        HorizontalScrollView(currentIndex: $currentIndex)
                            .onAppear {
                                proxy.scrollTo(currentIndex)
                            }
                    }.transition(.opacity)
                }
                RoundedRectangle(cornerRadius: 15)
                    .trim(from: scrollToggle ? 0.01 : 0.228, to: scrollToggle ? 0.052 : 0.272)
                    .stroke(.white, style: StrokeStyle(lineWidth: 25, lineCap: .round))
                    .padding(.horizontal, 30)
                    .offset(y: offsetToggle ? -50 : -30)
                    .frame(height: 480)
                HStack {
                    ForEach(0...4, id: \.self) { i in
                        Circle()
                            .fill(.black)
                            .frame(width: 8)
                            .opacity(i == currentIndex ? 1 : 0.5)
                    }
                }
                .rotationEffect(offsetToggle ? .radians(.pi/2) : .zero)
                .offset(x: offsetToggle ? 170 : 0)
                .offset(y: offsetToggle ? 0 : 210)
                .opacity(opacityToggle ? 1 : 0)
            }
            HStack {
                Image(systemName: "heart")
                Image(systemName: "message")
                Image(systemName: "paperplane")
                Spacer()
                Image(systemName: "bookmark")
            }.font(.title2)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            Button("Change Scroll Direction") {
                withAnimation(.spring()) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        opacityToggle.toggle()
                    }
                    scrollToggle.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        offsetToggle.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        withAnimation(.spring()) {
                            opacityToggle.toggle()
                        }
                    }
                    
                }
            }.buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding()
            Text("Created by Magesh Sridhar using SwiftUI 💙").font(.subheadline).bold()
        }
        
    }
}


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

struct ImageView: View {
    let i: Int
    var body: some View {
        Image("\(i)")
            .resizable()
            .scaledToFill()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * (5/4))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
