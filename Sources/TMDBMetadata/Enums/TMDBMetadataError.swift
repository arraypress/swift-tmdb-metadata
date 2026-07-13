//
//  TMDBMetadataError.swift
//  TMDBMetadata
//
//  Created by David Sherlock on 2026.
//

import Foundation

/// Errors that can occur when calling The Movie Database (TMDB) API.
///
/// ```swift
/// do {
///     let results = try await TMDBMetadata.search("blade runner")
/// } catch TMDBMetadataError.missingCredentials {
///     print("Set TMDB_ACCESS_TOKEN or TMDB_API_KEY")
/// } catch {
///     print(error.localizedDescription)
/// }
/// ```
public enum TMDBMetadataError: Error, LocalizedError, Equatable, Sendable {

    /// No API key or access token was provided (neither in the configuration nor
    /// via the `TMDB_API_KEY` / `TMDB_ACCESS_TOKEN` environment variables).
    case missingCredentials

    /// TMDB rejected the key/token (`401`).
    case notAuthorized

    /// The requested resource was not found (`404`).
    case notFound

    /// TMDB is rate-limiting requests (`429`).
    case rateLimited

    /// TMDB returned an error payload.
    case apiError(String)

    /// A network request failed.
    case networkError(String)

    /// Failed to parse the response.
    case parsingError(String)

    public var errorDescription: String? {
        switch self {
        case .missingCredentials:
            return "No TMDB credentials. Set TMDB_ACCESS_TOKEN (v4 bearer) or TMDB_API_KEY (v3), or pass one in the configuration."
        case .notAuthorized:
            return "TMDB rejected the key or token (401)."
        case .notFound:
            return "The requested TMDB resource was not found."
        case .rateLimited:
            return "TMDB is rate-limiting requests (429). Try again later."
        case .apiError(let message):
            return "TMDB API error: \(message)"
        case .networkError(let message):
            return "Network error: \(message)"
        case .parsingError(let message):
            return "Parsing error: \(message)"
        }
    }
}
