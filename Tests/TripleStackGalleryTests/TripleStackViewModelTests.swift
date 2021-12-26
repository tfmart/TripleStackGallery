//
//  TripleStackViewModelTests.swift
//  
//
//  Created by Tomas Martins on 24/12/21.
//

import XCTest
@testable import TripleStackGallery

class TripleStackViewModelTests: XCTestCase {
    let sut = TripleStackViewModel(images: [.init(), .init(), .init()])
    var didProgressExpectation: XCTestExpectation! = nil
    var didTapExpectation: XCTestExpectation! = nil
    
    func testIncreaseIndex() {
        sut.increaseIndex()
        XCTAssertEqual(sut.index, 1)
    }
    
    func testIncreaseIndexOverflow() {
        sut.increaseIndex()
        sut.increaseIndex()
        sut.increaseIndex()
        XCTAssertEqual(sut.index, 0)
    }
    
    func testIsValidIndex() {
        XCTAssertTrue(sut.isValidIndex)
        sut.index = 20
        XCTAssertFalse(sut.isValidIndex)
    }
    
    func testImageByAdding() {
        XCTAssertEqual(sut.image(byAdding: 1), sut.images[1])
        XCTAssertEqual(sut.image(byAdding: 3), sut.images.first)
    }
    
    func testDidProgress() {
        sut.delegate = self
        didProgressExpectation = .init(description: "didProgress")
        sut.didProgress()
        wait(for: [didProgressExpectation!], timeout: 0.1)
    }
    
    func testDidTap() {
        sut.delegate = self
        didTapExpectation = .init(description: "didTap")
        sut.didTap()
        wait(for: [didTapExpectation!], timeout: 0.1)
    }
}

extension TripleStackViewModelTests: TripleStackGalleryDelegate {
    func didProgress(to index: Int) {
        didProgressExpectation.fulfill()
    }
    
    func didTapImage(at index: Int) {
        didTapExpectation.fulfill()
    }
}
