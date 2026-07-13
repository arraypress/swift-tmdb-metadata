//
//  TMDBEnums.swift
//  TMDBMetadata
//
//  Created by David Sherlock on 2026.
//

import Foundation

/// The kind of TMDB search to perform.
public enum TMDBSearchType: String, Sendable {
    /// Movies, TV shows, and people in one ranked list.
    case multi
    /// Movies only.
    case movie
    /// TV shows only.
    case tv
    /// People only.
    case person
}

/// A TMDB poster image size (width in pixels, or `original`).
///
/// Used to build a full image URL from a `poster_path` / `backdrop_path`.
public enum TMDBImageSize: String, Sendable {
    case w92, w154, w185, w342, w500, w780, original

    /// Builds a full image URL for a TMDB image path (e.g. `/abc.jpg`).
    public func url(for path: String?) -> String? {
        guard let path, !path.isEmpty else { return nil }
        return "https://image.tmdb.org/t/p/\(rawValue)\(path)"
    }
}
