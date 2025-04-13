//
//  Home.swift
//  InfiniteView
//
//  Created by Balaji Venkatesh on 25/11/23.
//

import SwiftUI

struct Home: View {
    /// Sample Items
    @State private var items: [CircleData] = CircleData.randomCircles
    
    var body: some View {
        ScrollView(.vertical) {
            GeometryReader {
                let size = $0.size
                
                LoopingScrollView(width: 120, spacing: 10, items: items) { item in
                    Circle()
                        .fill(item.color.opacity(0.5))
                        .frame(width: item.size * 0.5, height: item.size * 0.5)
                        .overlay(
                            Image(item.image)
                                .resizable()
                                .clipShape(Circle())
                        )
                }
                .contentMargins(.horizontal, 15, for: .scrollContent)
            }
            .frame(height: 240)
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    ContentView()
}
