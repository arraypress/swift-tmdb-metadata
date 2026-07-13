//
//  TMDBMetadata.swift
//  TMDBMetadata
//
//  Created by David Sherlock on 2026.
//

import Foundation

/// Search and fetch movie & TV metadata from The Movie Database (TMDB).
///
/// TMDB requires a free credential — either a **v4 access token** (sent as a
/// bearer header) or a **v3 API key** (sent as a query parameter). Provide one
/// via ``Configuration`` or the `TMDB_ACCESS_TOKEN` / `TMDB_API_KEY` environment
/// variables. Get one at <https://www.themoviedb.org/settings/api>.
///
/// ## Quick Start
///
/// ```swift
/// import TMDBMetadata
///
/// // Multi-search across movies, TV, and people
/// let results = try await TMDBMetadata.search("blade runner")
/// for hit in results.results where hit.isMovie {
///     print("\(hit.title) (\(hit.date ?? "")) — ★\(hit.voteAverage ?? 0)")
/// }
///
/// // Full detail
/// let movie = try await TMDBMetadata.movie(78)     // Blade Runner
/// print(movie.tagline ?? "", movie.runtime ?? 0, "min", movie.genres)
/// print(movie.posterURL() ?? "")
///
/// let show = try await TMDBMetadata.tv(1396)       // Breaking Bad
/// print("\(show.name) — \(show.numberOfSeasons ?? 0) seasons")
///
/// // Trending this week
/// let trending = try await TMDBMetadata.trending()
/// ```
public enum TMDBMetadata {

    // MARK: - Configuration

    /// Credentials and options for the TMDB API.
    ///
    /// Provide either ``accessToken`` (v4 bearer) or ``apiKey`` (v3). ``default``
    /// reads `TMDB_ACCESS_TOKEN` / `TMDB_API_KEY` (and optional `TMDB_LANGUAGE`)
    /// from the environment.
    public struct Configuration: Sendable {

        /// A v4 API Read Access Token, sent as a bearer header.
        public var accessToken: String?

        /// A v3 API key, sent as the `api_key` query parameter.
        public var apiKey: String?

        /// The language for localized fields (e.g. `"en-US"`).
        public var language: String

        /// The `User-Agent` sent with every request.
        public var userAgent: String

        public init(
            accessToken: String? = nil,
            apiKey: String? = nil,
            language: String = "en-US",
            userAgent: String = "swift-tmdb-metadata/1.0 +https://github.com/arraypress"
        ) {
            self.accessToken = accessToken
            self.apiKey = apiKey
            self.language = language
            self.userAgent = userAgent
        }

        /// Reads credentials and language from the environment.
        public static var `default`: Configuration {
            let env = ProcessInfo.processInfo.environment
            return Configuration(
                accessToken: env["TMDB_ACCESS_TOKEN"],
                apiKey: env["TMDB_API_KEY"],
                language: env["TMDB_LANGUAGE"] ?? "en-US"
            )
        }
    }

    // MARK: - Search

    /// Searches TMDB.
    ///
    /// - Parameters:
    ///   - query: The search query.
    ///   - type: What to search. Defaults to ``TMDBSearchType/multi`` (movies, TV, people).
    ///   - page: Page number (1-based).
    ///   - configuration: Credentials/options.
    /// - Returns: A page of ``TMDBSearchResults``.
    public static func search(
        _ query: String,
        type: TMDBSearchType = .multi,
        page: Int = 1,
        configuration: Configuration = .default
    ) async throws -> TMDBSearchResults {
        let items = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: String(page))
        ]
        let data = try await TMDBClient.get(path: "/search/\(type.rawValue)", queryItems: items, configuration: configuration)
        return TMDBParser.searchResults(data)
    }

    // MARK: - Details

    /// Fetches full detail for a movie by its TMDB ID.
    public static func movie(
        _ id: Int, configuration: Configuration = .default
    ) async throws -> TMDBMovie {
        let data = try await TMDBClient.get(path: "/movie/\(id)", configuration: configuration)
        return TMDBParser.movie(data)
    }

    /// Fetches full detail for a TV show by its TMDB ID.
    public static func tv(
        _ id: Int, configuration: Configuration = .default
    ) async throws -> TMDBShow {
        let data = try await TMDBClient.get(path: "/tv/\(id)", configuration: configuration)
        return TMDBParser.show(data)
    }

    // MARK: - Trending

    /// Fetches trending items.
    ///
    /// - Parameters:
    ///   - media: `"all"`, `"movie"`, or `"tv"`. Defaults to `"all"`.
    ///   - window: `"day"` or `"week"`. Defaults to `"week"`.
    ///   - configuration: Credentials/options.
    public static func trending(
        media: String = "all",
        window: String = "week",
        configuration: Configuration = .default
    ) async throws -> TMDBSearchResults {
        let data = try await TMDBClient.get(path: "/trending/\(media)/\(window)", configuration: configuration)
        return TMDBParser.searchResults(data)
    }
}
