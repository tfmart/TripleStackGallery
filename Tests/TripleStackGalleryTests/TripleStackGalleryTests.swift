import XCTest
import SwiftUI
import SnapshotTesting
@testable import TripleStackGallery

final class ThreeStripesGalleryTests: XCTestCase {
    var sut: some View {
        TripleStackGallery(viewModel: .init(images: [
            .init(contentsOfFile: Bundle.module.path(forResource: "demo1", ofType: "webp")!)!,
            .init(contentsOfFile: Bundle.module.path(forResource: "demo2", ofType: "webp")!)!,
            .init(contentsOfFile: Bundle.module.path(forResource: "demo3", ofType: "jpg")!)!,
            .init(contentsOfFile: Bundle.module.path(forResource: "demo4", ofType: "jpg")!)!,
        ]))
            .frame(width: 300, height: 300)
    }
    
    func testExample() throws {
        assertSnapshot(matching: sut, as: .image)
    }
}
