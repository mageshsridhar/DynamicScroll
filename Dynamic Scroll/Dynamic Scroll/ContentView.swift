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
    
    var title: some View {
        HStack {
            Text("Dynamic Scroll View Concept").font(.title2).bold()
            Spacer()
        }.padding(.horizontal, 10)
    }
    
    var scrollViews: some View {
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
    }
    
    var actionIcons: some View {
        HStack {
            Image(systemName: "heart")
            Image(systemName: "message")
            Image(systemName: "paperplane")
            Spacer()
            Image(systemName: "bookmark")
        }.font(.title2)
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
    }
    
    var changeScrollButton: some View {
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
    }
    
    var body: some View {
        VStack {
            title
            scrollViews
            actionIcons
            changeScrollButton
            Text("Created by Magesh Sridhar using SwiftUI 💙").font(.subheadline).bold()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
