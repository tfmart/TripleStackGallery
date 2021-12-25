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
    
    @ObservedObject public var viewModel: TripleStackViewModel
    
    public init(viewModel: TripleStackViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            if let current = viewModel.currentImage {
                ZStack {
                    Image(uiImage: viewModel.image(byAdding: 3))
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fill)
                        .offset(.init(width: 20, height: 20))
                    Image(uiImage: viewModel.image(byAdding: 2))
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fill)
                        .offset(lastOffset)
                    Image(uiImage: viewModel.image(byAdding: 1))
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fill)
                        .offset(nextOffset)
                    Image(uiImage: current)
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fill)
                        .offset(currentOffset)
                        .opacity(currentOpacity)
                        .onTapGesture {
                            viewModel.didTap()
                        }
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
        withAnimation(.easeInOut(duration: viewModel.duration)) {
            self.currentOpacity = 0.0
            currentOffset = .init(width: -20, height: -20)
            nextOffset = .init(width: -20, height: -20)
            lastOffset = .zero
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + viewModel.duration) {
            viewModel.increaseIndex()
            currentOpacity = 1.0
            currentOffset = .init(width: -20, height: -20)
            nextOffset = .zero
            lastOffset = .init(width: 20, height: 20)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static func from(color: UIColor) -> UIImage {
            let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            context!.setFillColor(color.cgColor)
            context!.fill(rect)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return img!
        }
    
    static var previews: some View {
        TripleStackGallery(viewModel: .init(images: [
            from(color: .blue),
            from(color: .green),
            from(color: .red),
            from(color: .purple),
            from(color: .orange),
            from(color: .yellow)
        ]))
            .frame(width: 300, height: 300)
    }
}
