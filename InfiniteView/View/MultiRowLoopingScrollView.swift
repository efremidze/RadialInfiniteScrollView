import SwiftUI

/// Multi-Row Looping ScrollView with 3 rows of content
struct MultiRowLoopingScrollView<Content: View, Items: RandomAccessCollection>: View where Items.Element: Identifiable {
    /// Customization Properties
    var width: CGFloat
    var spacing: CGFloat = 0
    var items: Items
    var rowHeight: CGFloat = 80
    var rowSpacing: CGFloat = 10
    var rowOffsetAmount: CGFloat = 60 // Offset between rows 1/3 and row 2
    var curveHeight: CGFloat = 50 // Control the height of the curve
    
    @ViewBuilder var content: (Items.Element) -> Content
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            /// Safety Check
            let repeatingCount = width > 0 ? Int((size.width / width).rounded()) + 1 : 1
            
            ScrollView(.horizontal) {
                VStack(spacing: rowSpacing) {
                    // Row 1 (Bottom)
                    rowView(offset: 0, rowIndex: 0, repeatingCount: repeatingCount, scale: 1.0)
                    
                    // Row 2 (Middle) - offset horizontally
                    rowView(offset: rowOffsetAmount, rowIndex: 1, repeatingCount: repeatingCount, scale: 0.8)
                    
                    // Row 3 (Top) - same offset as row 1
                    rowView(offset: 0, rowIndex: 2, repeatingCount: repeatingCount, scale: 0.6)
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
            .background {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: size.height, height: size.height)
                    .offset(y: size.height / 2)
            }
        }
    }
    
    @ViewBuilder
    private func rowView(offset: CGFloat, rowIndex: Int, repeatingCount: Int, scale: CGFloat) -> some View {
        LazyHStack(spacing: spacing) {
            // First set of elements (original)
            ForEach(items) { item in
                contentView(item, scale: scale)
            }
            
            // Repeated elements for infinite scrolling
            ForEach(0..<repeatingCount, id: \.self) { index in
                let item = Array(items)[index % items.count]
                contentView(item, scale: scale)
            }
        }
        .offset(x: offset)
        .frame(height: rowHeight)
    }
    
    @ViewBuilder
    private func contentView(_ item: Items.Element, scale: CGFloat) -> some View {
        content(item)
            .frame(width: width)
            .visualEffect { content, geometryProxy in
                content
                    .offset(y: -curveHeight)
                    .rotationEffect(
                        .init(degrees: cardRotation(geometryProxy)),
                        anchor: .bottom
                    )
                    .scaleEffect(scale)
                    .offset(x: -geometryProxy.frame(in: .scrollView(axis: .horizontal)).minX, y: curveHeight * 0.8)
            }
    }
    
    /// Card Rotation
    func cardRotation(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        let width = proxy.size.width
        
        let progress = minX / width
        let angleForEachCard: CGFloat = -20 // Reduced rotation angle
        let cappedProgress = progress < 0 ? min(max(progress, -3), 0) : max(min(progress, 3), 0)
        
        return cappedProgress * angleForEachCard
    }
}

#Preview {
    ContentView()
}
