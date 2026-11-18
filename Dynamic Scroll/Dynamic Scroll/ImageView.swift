//
//  ImageView.swift
//  Dynamic Scroll
//
//  Created by Magesh Sridhar on 12/29/24.
//

import SwiftUI

struct ImageView: View {
    /// Number of images in the asset catalog, named "0" through "4".
    static let count = 5

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
