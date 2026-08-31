//
//  ImageURL.swift
//  TMDBMetadata
//
//  Created by David Sherlock on 2026.
//
//  TMDB's image URL scheme in one place: image.tmdb.org, a size
//  segment, and the API's leading-slash path appended verbatim. A pure
//  function, pinned to exact strings.
//

import Foundation

/// Assembly of TMDB image URLs.
enum ImageURL {

    /// A full image URL for a TMDB image path (e.g. `/abc.jpg`), or `nil`
    /// for a missing or empty path.
    static func image(path: String?, size: TMDBImageSize) -> String? {
        guard let path, !path.isEmpty else { return nil }
        return "https://image.tmdb.org/t/p/\(size.rawValue)\(path)"
    }
}
