//
//  TripleStackGalleryDelegate.swift
//  
//
//  Created by Tomas Martins on 24/12/21.
//

import Foundation

/// Methods for handling selection of an image or interaction with the gallery
public protocol TripleStackGalleryDelegate: AnyObject {
    /// Tells the delegate that the current image has been tapped
    /// - Parameter index: The index of the tapped image
    func didTapImage(at index: Int)
    /// Tells the delegate that the gallery has presented a new image as the current
    /// - Parameter index: The index of the new current image
    func didProgress(to index: Int)
}
