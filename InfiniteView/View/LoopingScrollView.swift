//
//  LoopingScrollView.swift
//  InfiniteView
//
//  Created by Balaji Venkatesh on 25/11/23.
//

import SwiftUI

/// Custom View
struct LoopingScrollView<Content: View, Items: RandomAccessCollection>: View where Items.Element: Identifiable {
    /// Customization Properties
    var width: CGFloat
    var spacing: CGFloat = 0
    var items: Items
    var curveHeight: CGFloat = 100 // Control the height of the curve
    
    @ViewBuilder var content: (Items.Element) -> Content
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            /// Safety Check
            let repeatingCount = width > 0 ? Int((size.width / width).rounded()) + 1 : 1
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: spacing) {
                    // First set of elements
                    ForEach(items) { item in
                        contentView(item)
                    }
                    
                    // Repeated elements for infinite scrolling
                    ForEach(0..<repeatingCount, id: \.self) { index in
                        let item = Array(items)[index % items.count]
                        contentView(item)
                    }
                }
                .scrollTargetLayout()
                .padding(.vertical, curveHeight)
                .background {
                    ScrollViewHelper(
                        width: width,
                        spacing: spacing,
                        itemsCount: items.count,
                        repeatingCount: repeatingCount
                    )
                }
            }
            .safeAreaPadding(.horizontal, (size.width * 0.5) - (size == .zero ? 0 : 75))
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
        }
    }

    @ViewBuilder
    private func contentView(_ item: Items.Element) -> some View {
        content(item)
            .frame(width: width)
            .visualEffect { content, geometryProxy in
                content
                    .offset(y: -curveHeight * 1.5)
                    .rotationEffect(
                        .init(degrees: cardRotation(geometryProxy)),
                        anchor: .bottom
                    )
                    .offset(x: -geometryProxy.frame(in: .scrollView(axis: .horizontal)).minX, y: curveHeight)
            }
    }
    
    /// Card Rotation
    func cardRotation(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        let progress = minX / proxy.size.width
        // Cap progress between -3 and 3, then multiply by angle
        return (progress < 0 ? min(max(progress, -3), 0) : max(min(progress, 3), 0)) * 50
    }
}

struct ScrollViewHelper: UIViewRepresentable {
    var width: CGFloat
    var spacing: CGFloat
    var itemsCount: Int
    var repeatingCount: Int
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(
            width: width,
            spacing: spacing,
            itemsCount: itemsCount,
            repeatingCount: repeatingCount
        )
    }
    
    func makeUIView(context: Context) -> UIView {
        return .init()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
            guard let scrollView = uiView.superview?.superview?.superview as? UIScrollView, 
                  !context.coordinator.isAdded else { return }
            
            scrollView.delegate = context.coordinator
            context.coordinator.isAdded = true
            
            // Initial call to ensure proper positioning
            context.coordinator.scrollViewDidScroll(scrollView)
        }
        
        context.coordinator.update(width: width, spacing: spacing, itemsCount: itemsCount, repeatingCount: repeatingCount)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var width: CGFloat
        var spacing: CGFloat
        var itemsCount: Int
        var repeatingCount: Int
        var isAdded: Bool = false
        
        init(width: CGFloat, spacing: CGFloat, itemsCount: Int, repeatingCount: Int) {
            self.width = width
            self.spacing = spacing
            self.itemsCount = itemsCount
            self.repeatingCount = repeatingCount
            super.init()
        }
        
        func update(width: CGFloat, spacing: CGFloat, itemsCount: Int, repeatingCount: Int) {
            self.width = width
            self.spacing = spacing
            self.itemsCount = itemsCount
            self.repeatingCount = repeatingCount
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            guard itemsCount > 0 else { return }
            
            let minX = scrollView.contentOffset.x
            let mainContentSize = CGFloat(itemsCount) * width
            let spacingSize = CGFloat(itemsCount - 1) * spacing
            
            if minX > (mainContentSize + spacingSize) {
                scrollView.contentOffset.x -= (mainContentSize + spacingSize)
            }
            
            if minX < 0 {
                scrollView.contentOffset.x += (mainContentSize + spacingSize)
            }
        }
    }
}

#Preview {
    ContentView()
}
