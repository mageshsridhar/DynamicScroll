//
//  ImageView.swift
//  Dynamic Scroll
//
//  Created by Magesh Sridhar on 12/29/24.
//

import SwiftUI

struct ImageView: View {
    let i: Int
    var body: some View {
        Image("\(i)")
            .resizable()
            .scaledToFill()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * (5/4))
    }
}

#Preview {
    ImageView(i: 0)
}
