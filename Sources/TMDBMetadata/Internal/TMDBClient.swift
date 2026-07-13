//
//  TMDBClient.swift
//  TMDBMetadata
//
//  Created by David Sherlock on 2026.
//

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Performs GET requests against the TMDB v3 API.
///
/// Supports either authentication style: a v4 **access token** (sent as a bearer
/// header) or a v3 **API key** (sent as the `api_key` query parameter).
enum TMDBClient {

    static let host = "https://api.themoviedb.org/3"

    static func get(
        path: String,
        queryItems: [URLQueryItem] = [],
        configuration: TMDBMetadata.Configuration
    ) async throws -> [String: Any] {
        let hasToken = !(configuration.accessToken ?? "").isEmpty
        let hasKey = !(configuration.apiKey ?? "").isEmpty
        guard hasToken || hasKey else { throw TMDBMetadataError.missingCredentials }

        guard var components = URLComponents(string: host + path) else {
            throw TMDBMetadataError.networkError("Invalid request URL")
        }
        var items = queryItems
        items.append(URLQueryItem(name: "language", value: configuration.language))
        if !hasToken, let key = configuration.apiKey {
            items.append(URLQueryItem(name: "api_key", value: key))
        }
        components.queryItems = items
        guard let url = components.url else {
            throw TMDBMetadataError.networkError("Invalid request URL")
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(configuration.userAgent, forHTTPHeaderField: "User-Agent")
        if hasToken, let token = configuration.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw TMDBMetadataError.networkError(error.localizedDescription)
        }

        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            let message = ((try? JSONSerialization.jsonObject(with: data)) as? [String: Any])?["status_message"] as? String
            switch http.statusCode {
            case 401: throw TMDBMetadataError.notAuthorized
            case 404: throw TMDBMetadataError.notFound
            case 429: throw TMDBMetadataError.rateLimited
            default: throw TMDBMetadataError.apiError(message ?? "HTTP \(http.statusCode)")
            }
        }

        guard let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else {
            throw TMDBMetadataError.parsingError("Invalid JSON response")
        }
        return json
    }
}
