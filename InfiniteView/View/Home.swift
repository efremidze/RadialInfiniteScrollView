//
//  Home.swift
//  InfiniteView
//
//  Created by Balaji Venkatesh on 25/11/23.
//

import SwiftUI

struct Home: View {
    /// Sample Items
    @State private var items: [CircleData] = [
        CircleData(image: "m4", size: 200, offsetx: 0, offsety: 50, color: .red),
        CircleData(image: "m5", size: 100, offsetx: 50, offsety: -100, color: .orange),
        CircleData(image: "m2", size: 150, offsetx: -90, offsety: -120, color: .green),
        CircleData(image: "m3", size: 150, offsetx: -180, offsety: 10, color: .indigo),
        CircleData(image: "m1", size: 150, offsetx: 130, offsety: -215, color: .purple),
        CircleData(image: "m6", size: 180, offsetx: 190, offsety: -40, color: .cyan),
        CircleData(image: "m7", size: 150, offsetx: 180, offsety: 140, color: .yellow)
    ]
    
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
