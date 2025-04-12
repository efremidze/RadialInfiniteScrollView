//
//  LoopingScrollView.swift
//  InfiniteView
//
//  Created by Balaji Venkatesh on 25/11/23.
//

import SwiftUI

/// Custom View
struct LoopingScrollView<Content: View, Item: RandomAccessCollection>: View where Item.Element: Identifiable {
    /// Customization Properties
    var width: CGFloat
    var spacing: CGFloat = 0
    var items: Item
    @ViewBuilder var content: (Item.Element) -> Content
    var body: some View {
        GeometryReader {
            let size = $0.size
            /// Saftey Check
            let repeatingCount = width > 0 ? Int((size.width / width).rounded()) + 1 : 1
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: spacing) {
                    ForEach(items) { item in
                        content(item)
                            .frame(width: width)
                            .scrollTransition(.interactive) { content, phase in
                                content
                                    .offset(y: phase.isIdentity ? 0 : 50)
                                    .opacity(phase.isIdentity ? 1 : 0.5)
                            }
                    }
                    
                    ForEach(0..<repeatingCount, id: \.self) { index in
                        let item = Array(items)[index % items.count]
                        content(item)
                            .scrollTransition(.interactive) { content, phase in
                                content
                                    .offset(y: phase.isIdentity ? 0 : 50)
                                    .opacity(phase.isIdentity ? 1 : 0.5)
                            }
                    }
                }
//                .padding(.vertical, 50)
                .background {
                    ScrollViewHelper(
                        width: width,
                        spacing: spacing,
                        itemsCount: items.count,
                        repeatingCount: repeatingCount
                    )
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

fileprivate struct ScrollViewHelper: UIViewRepresentable {
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
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView, !context.coordinator.isAdded {
                context.coordinator.defaultDelegate = scrollView.delegate
                scrollView.delegate = context.coordinator
                context.coordinator.isAdded = true
            }
        }
        
        context.coordinator.width = width
        context.coordinator.spacing = spacing
        context.coordinator.itemsCount = itemsCount
        context.coordinator.repeatingCount = repeatingCount
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var width: CGFloat
        var spacing: CGFloat
        var itemsCount: Int
        var repeatingCount: Int
        
        /// Optional SwiftUI Default Delegate
        weak var defaultDelegate: UIScrollViewDelegate?
        
        init(width: CGFloat, spacing: CGFloat, itemsCount: Int, repeatingCount: Int) {
            self.width = width
            self.spacing = spacing
            self.itemsCount = itemsCount
            self.repeatingCount = repeatingCount
        }
        
        /// Tells us whether the delegate is added or not
        var isAdded: Bool = false
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            guard itemsCount > 0 else { return }
            
            let minX = scrollView.contentOffset.x
            let mainContentSize = CGFloat(itemsCount) * width
            let spacingSize = CGFloat(itemsCount) * spacing
            
            if minX > (mainContentSize + spacingSize) {
                scrollView.contentOffset.x -= (mainContentSize + spacingSize)
            }
            
            if minX < 0 {
                scrollView.contentOffset.x += (mainContentSize + spacingSize)
            }
        }
        
        /// Usage: Default Delegate
//        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//            defaultDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
//        }
    }
}

#Preview {
    ContentView()
}
