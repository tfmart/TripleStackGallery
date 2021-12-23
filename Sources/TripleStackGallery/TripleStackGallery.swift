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
    // MARK: Displayed views
    @State var current: Color = .clear
    @State var next: Color = .clear
    @State var last: Color = .clear
    @State var nextPage: Color = .clear
    
    var colors: [Color]
    
    let duration: Double = 0.25
    
    init(_ colors: [Color]) {
        self.colors = colors
    }
    
    var body: some View {
        VStack {
            ZStack {
                nextPage
                    .aspectRatio(1.0, contentMode: .fill)
                    .offset(.init(width: 20, height: 20))
                last
                    .aspectRatio(1.0, contentMode: .fill)
                    .offset(lastOffset)
                next
                    .aspectRatio(1.0, contentMode: .fill)
                    .offset(nextOffset)
                current
                    .aspectRatio(1.0, contentMode: .fill)
                    .offset(currentOffset)
                    .opacity(currentOpacity)
                    .onAppear(perform: {
                        initalSetup()
                    })
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
                                currentOpacity = 1.0
                                currentOffset = .init(width: -20, height: -20)
                                nextOffset = .zero
                                lastOffset = .init(width: 20, height: 20)
                            }
                        } else {
                            withAnimation(.easeInOut) {
                                currentOffset = .init(width: -20, height: -20)
                            }
                        }
                    }))
            }.padding(20)
        }
    }
    
    func initalSetup() {
        self.current = self.colors[0]
        self.next = nextColor(indexColor: current)
        self.last = nextColor(indexColor: next)
        self.nextPage = nextColor(indexColor: last)
    }
    
    func nextColor(indexColor: Color) -> Color {
        guard let index = colors.firstIndex(of: indexColor) else {
            return .clear
        }
        if index + 1 == colors.count {
            return colors[0]
        } else {
            return colors[index+1]
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
        last = nextPage
        if nextPage == colors.last {
            nextPage = colors[0]
        } else {
            nextPage = colors[colors.firstIndex(of: nextPage)! + 1]
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        TripleStackGallery([.blue, .green, .red, .purple, .orange, .yellow])
            .frame(width: 300, height: 300)
    }
}
