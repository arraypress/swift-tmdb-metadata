//
//  SupportTests.swift
//  TMDBMetadataTests
//
//  Created by David Sherlock on 2026.
//
//  The image-URL rule pinned directly.
//

import XCTest
@testable import TMDBMetadata

final class SupportTests: XCTestCase {

    func testImageURLAssembly() {
        XCTAssertEqual(ImageURL.image(path: "/abc.jpg", size: .w500), "https://image.tmdb.org/t/p/w500/abc.jpg")
        XCTAssertEqual(ImageURL.image(path: "/abc.jpg", size: .original), "https://image.tmdb.org/t/p/original/abc.jpg")
        XCTAssertNil(ImageURL.image(path: nil, size: .w500))
        XCTAssertNil(ImageURL.image(path: "", size: .w500))
    }
}
