//
//  TripleStackGallery.swift
//  
//
//  Created by Tomas Martins on 23/12/21.
//

import SwiftUI

public struct TripleStackGallery: View {
    // MARK: - Offsets
    @State private var currentOffset: CGSize = .init(width: -20, height: -20)
    @State private var nextOffset: CGSize = .zero
    @State private var lastOffset: CGSize = .init(width: 20, height: 20)

    // MARK: - Opacities
    @State private var currentOpacity: Double = 1.0

    // MARK: Displayed views
    @State private var index: Int = 0
    
    public var colors: [Color]
    
    private let duration: Double = 0.25
    
    public init(_ colors: [Color]) {
        self.colors = colors
    }
    
    public var body: some View {
        VStack {
            if let current = currentColor {
                ZStack {
                    color(byAdding: 3)
                        .aspectRatio(1.0, contentMode: .fill)
                        .offset(.init(width: 20, height: 20))
                    color(byAdding: 2)
                        .aspectRatio(1.0, contentMode: .fill)
                        .offset(lastOffset)
                    color(byAdding: 1)
                        .aspectRatio(1.0, contentMode: .fill)
                        .offset(nextOffset)
                    current
                        .aspectRatio(1.0, contentMode: .fill)
                        .offset(currentOffset)
                        .opacity(currentOpacity)
                        .gesture(DragGesture()
                                    .onChanged({ dragValue in
                            if isValidGesture(width: dragValue.translation.width) {
                                currentOffset = .init(width: dragValue.translation.width, height: -20)
                            }
                        })
                                    .onEnded({ endValue in
                            if shouldProgress(endValue.translation.width) {
                                animateTransition()
                            } else {
                                withAnimation(.easeInOut) {
                                    currentOffset = .init(width: -20, height: -20)
                                }
                            }
                        }))
                }.padding(20)
            } else {
                Text("No data to display")
            }
        }
    }
    
    //MARK: - Gesture methods
    private func isValidGesture(width: CGFloat) -> Bool {
        return width != 0 && width < 80 && width > -80
    }
    
    private func shouldProgress(_ width: CGFloat) -> Bool {
        return width > 60 || width < -60
    }
    
    private func animateTransition() {
        withAnimation(.easeInOut(duration: duration)) {
            self.currentOpacity = 0.0
            currentOffset = .init(width: -20, height: -20)
            nextOffset = .init(width: -20, height: -20)
            lastOffset = .zero
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            increaseIndex()
            currentOpacity = 1.0
            currentOffset = .init(width: -20, height: -20)
            nextOffset = .zero
            lastOffset = .init(width: 20, height: 20)
        }
    }
    
    // MARK: - Index manipulation methods
    private func increaseIndex() {
        guard colors.count > 0 else { return }
        if index == colors.count - 1 {
            index = 0
        } else {
            index += 1
        }
    }
    
    private var currentColor: Color? {
        guard colors.indices.contains(index) else { return nil }
        return colors[index]
    }
    
    private func color(byAdding index: Int) -> Color {
        let colorIndex = self.index + index
        guard colors.indices.contains(colorIndex) else {
            return colors[actual(index: colorIndex)]
        }
        return colors[colorIndex]
    }
    
    private func actual(index overflowIndex: Int) -> Int {
        let actualIndex = overflowIndex - colors.count
        guard colors.indices.contains(actualIndex) else {
            return actual(index: actualIndex)
        }
        return actualIndex
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        TripleStackGallery([.blue, .green, .red, .purple, .orange, .yellow])
            .frame(width: 300, height: 300)
    }
}
