//
//  TMDBMovie.swift
//  TMDBMetadata
//
//  Created by David Sherlock on 2026.
//

import Foundation

/// Full detail for a movie on TMDB.
///
/// ```swift
/// let movie = try await TMDBMetadata.movie(78)   // Blade Runner
/// print("\(movie.title) (\(movie.year ?? 0)) — ★\(movie.voteAverage ?? 0)")
/// print(movie.posterURL() ?? "")
/// ```
public struct TMDBMovie: Sendable, Identifiable {

    /// The TMDB movie ID.
    public let id: Int

    /// The display title.
    public let title: String

    /// The original-language title.
    public let originalTitle: String?

    /// The plot overview.
    public let overview: String?

    /// The tagline, if any.
    public let tagline: String?

    /// The release date as text (`"YYYY-MM-DD"`).
    public let releaseDate: String?

    /// The runtime in minutes.
    public let runtime: Int?

    /// The average user rating (0–10).
    public let voteAverage: Double?

    /// The number of votes.
    public let voteCount: Int?

    /// The genre names (e.g. `["Science Fiction", "Thriller"]`).
    public let genres: [String]

    /// The production status (e.g. `"Released"`).
    public let status: String?

    /// The original language code (e.g. `"en"`).
    public let originalLanguage: String?

    /// The IMDb ID (e.g. `"tt0083658"`), if known.
    public let imdbID: String?

    /// The budget in USD.
    public let budget: Int?

    /// The revenue in USD.
    public let revenue: Int?

    /// The official homepage URL.
    public let homepage: String?

    /// The `poster_path`; build a URL with ``TMDBImageSize``.
    public let posterPath: String?

    /// The `backdrop_path`.
    public let backdropPath: String?

    // MARK: - Computed

    /// The release year, parsed from ``releaseDate``.
    public var year: Int? { releaseDate.flatMap { Int($0.prefix(4)) } }

    /// A poster URL at the given size (defaults to `w500`).
    public func posterURL(size: TMDBImageSize = .w500) -> String? { size.url(for: posterPath) }

    /// A backdrop URL at the given size (defaults to `w780`).
    public func backdropURL(size: TMDBImageSize = .w780) -> String? { size.url(for: backdropPath) }

    public init(
        id: Int, title: String, originalTitle: String?, overview: String?, tagline: String?,
        releaseDate: String?, runtime: Int?, voteAverage: Double?, voteCount: Int?, genres: [String],
        status: String?, originalLanguage: String?, imdbID: String?, budget: Int?, revenue: Int?,
        homepage: String?, posterPath: String?, backdropPath: String?
    ) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.overview = overview
        self.tagline = tagline
        self.releaseDate = releaseDate
        self.runtime = runtime
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.genres = genres
        self.status = status
        self.originalLanguage = originalLanguage
        self.imdbID = imdbID
        self.budget = budget
        self.revenue = revenue
        self.homepage = homepage
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }
}
