//
//  TripleStackGallery.swift
//  
//
//  Created by Tomas Martins on 23/12/21.
//

import SwiftUI

/// Gallery component that displays a set of images in a stack of images
public struct TripleStackGallery: View {
    // MARK: - Offsets
    @State private var currentOffset: CGSize = .init(width: -20, height: -20)
    @State private var nextOffset: CGSize = .zero
    @State private var lastOffset: CGSize = .init(width: 20, height: 20)

    // MARK: - Opacities
    @State private var currentOpacity: Double = 1.0
    
    /// Object that holds the content to be displayed by the gallery
    @ObservedObject public var viewModel: TripleStackViewModel
    
    /// Instantiates `self` with the content and rules set from `viewModel`
    /// - Parameter viewModel: Holds the content to be displayed by the gallery component
    public init(viewModel: TripleStackViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            if viewModel.isValidIndex {
                gallery
            } else {
                Text("No data to display")
            }
        }
    }
    
    var gallery: some View {
        ZStack {
            ForEach((0...3).reversed(), id: \.self) {
                if $0 == 0 {
                    imageWithGesture(image: viewModel.image(byAdding: $0), index: $0)
                } else {
                    squareImage(with: viewModel.image(byAdding: $0),
                                index: $0)
                }
            }
        }.padding(20)
    }
    
    func offset(for index: Int) -> CGSize {
        switch index {
        case 3: return .init(width: 20, height: 20)
        case 2: return lastOffset
        case 1: return nextOffset
        case 0: return currentOffset
        default: return .zero
        }
    }
    
    private func squareImage(with image: UIImage, index: Int) -> some View {
        Color.clear
            .aspectRatio(1, contentMode: .fit)
            .background(Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill))
            .clipped()
            .offset(offset(for: index))
    }
    
    private func imageWithGesture(image: UIImage, index: Int) -> some View {
        squareImage(with: image, index: index)
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
