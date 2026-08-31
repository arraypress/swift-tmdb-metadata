//
//  TMDBSearchResults.swift
//  TMDBMetadata
//
//  Created by David Sherlock on 2026.
//

import Foundation

/// A single TMDB search or trending result.
///
/// A multi-search returns a mixed list of movies, TV shows, and people. Use
/// ``mediaType`` (and the `isMovie`/`isTV` conveniences) to distinguish them;
/// ``title`` and ``date`` normalise the movie/TV field name differences.
public struct TMDBResult: Sendable, Identifiable {

    /// The TMDB ID.
    public let id: Int

    /// The media type: `"movie"`, `"tv"`, or `"person"`.
    public let mediaType: String

    /// The title (movie `title`, TV `name`, or person `name`).
    public let title: String

    /// The overview/biography text, if any.
    public let overview: String?

    /// The release date (movie) or first-air date (TV) as text (`"YYYY-MM-DD"`).
    public let date: String?

    /// The average user rating (0–10).
    public let voteAverage: Double?

    /// The number of votes.
    public let voteCount: Int?

    /// TMDB's popularity score.
    public let popularity: Double?

    /// The `poster_path` (movie/TV) or `profile_path` (person); build a URL with ``TMDBImageSize``.
    public let posterPath: String?

    /// The genre IDs (resolve names via TMDB's genre list, or use full detail lookups).
    public let genreIDs: [Int]

    // MARK: - Computed

    public init(
        id: Int, mediaType: String, title: String, overview: String?, date: String?,
        voteAverage: Double?, voteCount: Int?, popularity: Double?, posterPath: String?, genreIDs: [Int]
    ) {
        self.id = id
        self.mediaType = mediaType
        self.title = title
        self.overview = overview
        self.date = date
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.popularity = popularity
        self.posterPath = posterPath
        self.genreIDs = genreIDs
    }
}

/// A page of TMDB search (or trending) results.
public struct TMDBSearchResults: Sendable {

    /// The results on this page.
    public let results: [TMDBResult]

    /// The current page (1-based).
    public let page: Int

    /// The total number of matching items.
    public let totalResults: Int

    /// The total number of pages.
    public let totalPages: Int

    /// Whether another page is available.
    public var hasNextPage: Bool { page < totalPages }

    public init(results: [TMDBResult], page: Int, totalResults: Int, totalPages: Int) {
        self.results = results
        self.page = page
        self.totalResults = totalResults
        self.totalPages = totalPages
    }
}
