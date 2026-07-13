//
//  TMDBParser.swift
//  TMDBMetadata
//
//  Created by David Sherlock on 2026.
//

import Foundation

/// Parses TMDB API response objects into typed models.
enum TMDBParser {

    // MARK: - Search / trending

    static func searchResults(_ d: [String: Any]) -> TMDBSearchResults {
        let results = (d["results"] as? [[String: Any]] ?? []).map(result)
        return TMDBSearchResults(
            results: results,
            page: intValue(d["page"]) ?? 1,
            totalResults: intValue(d["total_results"]) ?? results.count,
            totalPages: intValue(d["total_pages"]) ?? 1
        )
    }

    private static func result(_ d: [String: Any]) -> TMDBResult {
        // `media_type` is present for multi/trending; inferred for typed searches.
        let mediaType = (d["media_type"] as? String)
            ?? (d["title"] != nil ? "movie" : (d["first_air_date"] != nil || d["name"] != nil ? "tv" : ""))
        return TMDBResult(
            id: intValue(d["id"]) ?? 0,
            mediaType: mediaType,
            title: (d["title"] as? String) ?? (d["name"] as? String) ?? "",
            overview: nonEmpty(d["overview"]) ?? nonEmpty(d["biography"]),
            date: nonEmpty(d["release_date"]) ?? nonEmpty(d["first_air_date"]),
            voteAverage: doubleValue(d["vote_average"]),
            voteCount: intValue(d["vote_count"]),
            popularity: doubleValue(d["popularity"]),
            posterPath: (d["poster_path"] as? String) ?? (d["profile_path"] as? String),
            genreIDs: (d["genre_ids"] as? [Int]) ?? []
        )
    }

    // MARK: - Details

    static func movie(_ d: [String: Any]) -> TMDBMovie {
        TMDBMovie(
            id: intValue(d["id"]) ?? 0,
            title: d["title"] as? String ?? "",
            originalTitle: nonEmpty(d["original_title"]),
            overview: nonEmpty(d["overview"]),
            tagline: nonEmpty(d["tagline"]),
            releaseDate: nonEmpty(d["release_date"]),
            runtime: intValue(d["runtime"]),
            voteAverage: doubleValue(d["vote_average"]),
            voteCount: intValue(d["vote_count"]),
            genres: names(d["genres"]),
            status: nonEmpty(d["status"]),
            originalLanguage: nonEmpty(d["original_language"]),
            imdbID: nonEmpty(d["imdb_id"]),
            budget: intValue(d["budget"]),
            revenue: intValue(d["revenue"]),
            homepage: nonEmpty(d["homepage"]),
            posterPath: d["poster_path"] as? String,
            backdropPath: d["backdrop_path"] as? String
        )
    }

    static func show(_ d: [String: Any]) -> TMDBShow {
        TMDBShow(
            id: intValue(d["id"]) ?? 0,
            name: d["name"] as? String ?? "",
            originalName: nonEmpty(d["original_name"]),
            overview: nonEmpty(d["overview"]),
            tagline: nonEmpty(d["tagline"]),
            firstAirDate: nonEmpty(d["first_air_date"]),
            lastAirDate: nonEmpty(d["last_air_date"]),
            numberOfSeasons: intValue(d["number_of_seasons"]),
            numberOfEpisodes: intValue(d["number_of_episodes"]),
            episodeRunTimes: (d["episode_run_time"] as? [Int]) ?? [],
            voteAverage: doubleValue(d["vote_average"]),
            voteCount: intValue(d["vote_count"]),
            genres: names(d["genres"]),
            networks: names(d["networks"]),
            status: nonEmpty(d["status"]),
            originalLanguage: nonEmpty(d["original_language"]),
            posterPath: d["poster_path"] as? String,
            backdropPath: d["backdrop_path"] as? String
        )
    }

    // MARK: - Helpers

    private static func names(_ value: Any?) -> [String] {
        guard let array = value as? [[String: Any]] else { return [] }
        return array.compactMap { $0["name"] as? String }
    }

    private static func nonEmpty(_ value: Any?) -> String? {
        guard let s = value as? String, !s.isEmpty else { return nil }
        return s
    }

    private static func intValue(_ value: Any?) -> Int? {
        if let i = value as? Int { return i }
        if let d = value as? Double { return Int(d) }
        if let s = value as? String { return Int(s) }
        return nil
    }

    private static func doubleValue(_ value: Any?) -> Double? {
        if let d = value as? Double { return d }
        if let i = value as? Int { return Double(i) }
        return nil
    }
}
