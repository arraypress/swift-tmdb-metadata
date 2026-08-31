//
//  TMDBResult+Derived.swift
//  TMDBMetadata
//
//  Created by David Sherlock on 2026.
//
//  The search result's derived facts. URL assembly delegates into Support
//  via the size vocabulary; the year parse is stated in full.
//

import Foundation

extension TMDBResult {

    /// Whether this result is a movie.
    public var isMovie: Bool { mediaType == "movie" }

    /// Whether this result is a TV show.
    public var isTV: Bool { mediaType == "tv" }

    /// A poster URL at the given size (defaults to `w500`).
    public func posterURL(size: TMDBImageSize = .w500) -> String? {
        size.url(for: posterPath)
    }
}
