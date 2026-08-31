//
//  TMDBShow.swift
//  TMDBMetadata
//
//  Created by David Sherlock on 2026.
//

import Foundation

/// Full detail for a TV show on TMDB.
///
/// ```swift
/// let show = try await TMDBMetadata.tv(1396)   // Breaking Bad
/// print("\(show.name) — \(show.numberOfSeasons ?? 0) seasons, ★\(show.voteAverage ?? 0)")
/// ```
public struct TMDBShow: Sendable, Identifiable {

    /// The TMDB show ID.
    public let id: Int

    /// The display name.
    public let name: String

    /// The original-language name.
    public let originalName: String?

    /// The overview.
    public let overview: String?

    /// The tagline, if any.
    public let tagline: String?

    /// The first-air date as text (`"YYYY-MM-DD"`).
    public let firstAirDate: String?

    /// The last-air date as text.
    public let lastAirDate: String?

    /// The number of seasons.
    public let numberOfSeasons: Int?

    /// The number of episodes.
    public let numberOfEpisodes: Int?

    /// Typical episode runtimes in minutes.
    public let episodeRunTimes: [Int]

    /// The average user rating (0–10).
    public let voteAverage: Double?

    /// The number of votes.
    public let voteCount: Int?

    /// The genre names.
    public let genres: [String]

    /// The networks that air the show (e.g. `["AMC"]`).
    public let networks: [String]

    /// The production status (e.g. `"Ended"`, `"Returning Series"`).
    public let status: String?

    /// The original language code.
    public let originalLanguage: String?

    /// The `poster_path`.
    public let posterPath: String?

    /// The `backdrop_path`.
    public let backdropPath: String?

    // MARK: - Computed

    public init(
        id: Int, name: String, originalName: String?, overview: String?, tagline: String?,
        firstAirDate: String?, lastAirDate: String?, numberOfSeasons: Int?, numberOfEpisodes: Int?,
        episodeRunTimes: [Int], voteAverage: Double?, voteCount: Int?, genres: [String],
        networks: [String], status: String?, originalLanguage: String?, posterPath: String?, backdropPath: String?
    ) {
        self.id = id
        self.name = name
        self.originalName = originalName
        self.overview = overview
        self.tagline = tagline
        self.firstAirDate = firstAirDate
        self.lastAirDate = lastAirDate
        self.numberOfSeasons = numberOfSeasons
        self.numberOfEpisodes = numberOfEpisodes
        self.episodeRunTimes = episodeRunTimes
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.genres = genres
        self.networks = networks
        self.status = status
        self.originalLanguage = originalLanguage
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }
}
