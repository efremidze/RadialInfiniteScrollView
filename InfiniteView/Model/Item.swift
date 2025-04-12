//
//  Item.swift
//  InfiniteView
//
//  Created by Balaji Venkatesh on 25/11/23.
//

import SwiftUI

/// Sample Data Model
struct Item: Identifiable {
    var id: UUID = .init()
    var color: Color
}

struct RandomCircleGroupView: View {
    let circles = [
        CircleData(image: "m4", size: 200, offsetx: 0, offsety: 50, color: .red),
        CircleData(image: "m5", size: 100, offsetx: 50, offsety: -100, color: .orange),
        CircleData(image: "m2", size: 150, offsetx: -90, offsety: -120, color: .green),
        CircleData(image: "m3", size: 150, offsetx: -180, offsety: 10, color: .indigo),
        CircleData(image: "m1", size: 150, offsetx: 130, offsety: -215, color: .purple),
        CircleData(image: "m6", size: 180, offsetx: 190, offsety: -40, color: .cyan),
        CircleData(image: "m7", size: 150, offsetx: 180, offsety: 140, color: .yellow)
    ]
    var body: some View {
        ZStack {
            ForEach(circles, id: \.id) { circle in
                Circle()
                    .fill(circle.color.opacity(0.5))
                    .frame(width: circle.size, height: circle.size)
                    .overlay(
                        Image(circle.image)
                            .resizable()
                            .clipShape(Circle())
                    )
                    .offset(x: circle.offsetx, y: circle.offsety)
            }
        }
        .frame(height: 300)
    }
}

struct CircleData: Identifiable {
    let id = UUID()
    let image: String
    let size: CGFloat
    let offsetx: CGFloat
    let offsety: CGFloat
    let color: Color
}
