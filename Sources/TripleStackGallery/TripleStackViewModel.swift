//
//  TripleStackViewModel.swift
//  
//
//  Created by Tomas Martins on 24/12/21.
//

import Combine
import UIKit

/// Class that holds the set of images to be displayed by the gallery and it's rules to control the display of such images
public class TripleStackViewModel: ObservableObject {
    /// The index of the image that is currently beign displayed at the front of the gallery
    @Published internal var index: Int
    /// An array of images to be displayed in the gallery view
    @Published public var images: [UIImage]
    /// The duration of the animations that are executed when the gallery is interacted with
    public var duration: Double
    /// The object that acts as the delegate for the `TripleStackViewModel`
    public weak var delegate: TripleStackGalleryDelegate?
    
    /// Initializes `self` with the images to be displayed by the gallery, the starting index and the view's animations duration time
    /// - Parameters:
    ///   - images: An array of `UIImage` that will be displayed by the gallery
    ///   - index: An optional parameter which indicates the starting index of the gallery. Default value is 0
    ///   - animationDuration: An optional parameter which indicates the duration time of the gallery view animations. Default value is 0.25
    public init(images: [UIImage], startAt index: Int = 0, animationDuration: Double = 0.25) {
        self.images = images
        self.index = index
        self.duration = animationDuration
    }
    
    /// Boolean indicating whether the current value of index is not out of bounds of the `images` array
    public var isValidIndex: Bool {
        return images.indices.contains(index)
    }
    
    /// Increase the current index by one. If the new value would be out of bounds of the `images` array, it will point to the index of the first image instead
    public func increaseIndex() {
        guard images.count > 0 else { return }
        if index == images.count - 1 {
            index = 0
        } else {
            index += 1
        }
        didProgress()
    }
    
    /// Adds an amount to the current `index` and returns the corresponding UIImage from the `images` array
    /// - Parameter index: The amount to be added to the current `index`
    /// - Returns: An instance of UIImage from the `images` array located in the resulted index
    internal func image(byAdding index: Int) -> UIImage {
        let imageIndex = self.index + index
        guard images.indices.contains(imageIndex) else {
            return images[actual(index: imageIndex)]
        }
        return images[imageIndex]
    }
    
    /// If the `overflowIndex` is out of bounds from the `image` array, this method calculates the corresponding index
    /// - Parameter overflowIndex: The index value that is supposedly out of bounds
    /// - Returns: A Int valure representing a valid index
    internal func actual(index overflowIndex: Int) -> Int {
        guard !images.indices.contains(overflowIndex) else {
            return overflowIndex
        }
        let actualIndex = overflowIndex - images.count
        guard images.indices.contains(actualIndex) else {
            return actual(index: actualIndex)
        }
        return actualIndex
    }
    
    /// Method that calls the delegate callback method `didProgress(to:)`
    internal func didProgress() {
        delegate?.didProgress(to: index)
    }
    
    /// Method that calls the delegate callback method `didTapImage(at:)`
    internal func didTap() {
        delegate?.didTapImage(at: index)
    }
}
