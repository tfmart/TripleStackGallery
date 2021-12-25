//
//  TripleStackGalleryDelegate.swift
//  
//
//  Created by Tomas Martins on 24/12/21.
//

import Foundation

public protocol TripleStackGalleryDelegate: AnyObject {
    func didTapImage(at index: Int)
    func didProgress(to index: Int)
}
