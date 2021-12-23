//
//  TripleStackGallery.swift
//  
//
//  Created by Tomas Martins on 23/12/21.
//

import SwiftUI

struct TripleStackGallery: View {
    // MARK: - Offsets
    @State var currentOffset: CGSize = .init(width: -20, height: -20)
    @State var nextOffset: CGSize = .zero
    @State var lastOffset: CGSize = .init(width: 20, height: 20)
    // MARK: - Opacities
    @State var currentOpacity: Double = 1.0
    @State var lastOpacity: Double = 1.0
    // MARK: Displayed views
    @State var current: Color
    @State var next: Color
    @State var last: Color
    
    var colors: [Color]
    
    let duration: Double = 0.25
    
    init(_ colors: [Color]) {
        self.colors = colors
        current = colors[0]
        next = colors[1]
        last = colors[2]
    }
    
    var body: some View {
        ZStack {
            last
                .aspectRatio(1.0, contentMode: .fill)
                .offset(lastOffset)
                .opacity(lastOpacity)
            next
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
                        withAnimation(.easeInOut(duration: duration)) {
                            self.currentOpacity = 0.0
                            currentOffset = .init(width: -20, height: -20)
                            nextOffset = .init(width: -20, height: -20)
                            lastOffset = .zero
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            updateColors()
                        }
                    } else {
                        withAnimation(.spring()) {
                            currentOffset = .init(width: -20, height: -20)
                        }
                    }
                }))
        }
    }
    
    func isValidGesture(width: CGFloat) -> Bool {
        return width != 0 && width < 80 && width > -80
    }
    
    func shouldProgress(_ width: CGFloat) -> Bool {
        return width > 60 || width < -60
    }
    
    func updateColors() {
        current = next
        next = last
        if last == colors.last {
            last = colors[0]
        } else {
            last = colors[colors.firstIndex(of: last)! + 1]
        }
        currentOpacity = 1.0
        lastOpacity = 0.0
        currentOffset = .init(width: -20, height: -20)
        nextOffset = .zero
        lastOffset = .init(width: 20, height: 20)
        withAnimation(.easeInOut(duration: duration)) {
            lastOpacity = 1.0
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        TripleStackGallery([.blue, .green, .red, .purple, .orange, .yellow])
            .frame(width: 200, height: 200)
    }
}
