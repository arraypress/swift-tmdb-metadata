//
//  TMDBMetadataTests.swift
//  TMDBMetadata
//
//  Created by David Sherlock on 2026.
//

import XCTest
@testable import TMDBMetadata

final class TMDBMetadataTests: XCTestCase {

    // MARK: - Image URLs

    func testImageURL() {
        XCTAssertEqual(
            TMDBImageSize.w500.url(for: "/abc.jpg"),
            "https://image.tmdb.org/t/p/w500/abc.jpg"
        )
        XCTAssertNil(TMDBImageSize.w500.url(for: nil))
        XCTAssertNil(TMDBImageSize.original.url(for: ""))
    }

    // MARK: - Credentials

    func testMissingCredentialsThrows() async {
        let config = TMDBMetadata.Configuration(accessToken: nil, apiKey: nil)
        do {
            _ = try await TMDBMetadata.search("x", configuration: config)
            XCTFail("Expected missingCredentials")
        } catch TMDBMetadataError.missingCredentials {
            // expected
        } catch {
            XCTFail("Expected missingCredentials, got \(error)")
        }
    }

    // MARK: - Parsing

    func testParseSearchMulti() throws {
        let results = TMDBParser.searchResults(try json(Fixture.searchMulti))
        XCTAssertEqual(results.totalResults, 2)
        XCTAssertEqual(results.page, 1)
        XCTAssertEqual(results.results.count, 2)

        let movie = results.results[0]
        XCTAssertEqual(movie.id, 78)
        XCTAssertTrue(movie.isMovie)
        XCTAssertEqual(movie.title, "Blade Runner")
        XCTAssertEqual(movie.date, "1982-06-25")
        XCTAssertEqual(movie.voteAverage, 8.1)
        XCTAssertEqual(movie.posterURL(), "https://image.tmdb.org/t/p/w500/poster.jpg")

        let show = results.results[1]
        XCTAssertTrue(show.isTV)
        XCTAssertEqual(show.title, "Blade Runner: Black Lotus")
    }

    func testParseMovie() throws {
        let movie = TMDBParser.movie(try json(Fixture.movie))
        XCTAssertEqual(movie.id, 78)
        XCTAssertEqual(movie.title, "Blade Runner")
        XCTAssertEqual(movie.year, 1982)
        XCTAssertEqual(movie.runtime, 117)
        XCTAssertEqual(movie.genres, ["Science Fiction", "Drama", "Thriller"])
        XCTAssertEqual(movie.imdbID, "tt0083658")
        XCTAssertEqual(movie.tagline, "Man has made his match... now it's his problem.")
    }

    func testParseShow() throws {
        let show = TMDBParser.show(try json(Fixture.show))
        XCTAssertEqual(show.id, 1396)
        XCTAssertEqual(show.name, "Breaking Bad")
        XCTAssertEqual(show.numberOfSeasons, 5)
        XCTAssertEqual(show.genres, ["Drama"])
        XCTAssertEqual(show.networks, ["AMC"])
        XCTAssertEqual(show.year, 2008)
    }

    // MARK: - Live tests (require a free TMDB credential)

    private var liveConfig: TMDBMetadata.Configuration? {
        let env = ProcessInfo.processInfo.environment
        guard env["TMDB_LIVE_TESTS"] == "1",
              env["TMDB_ACCESS_TOKEN"] != nil || env["TMDB_API_KEY"] != nil else { return nil }
        return .default
    }

    func testLiveSearchAndDetails() async throws {
        try XCTSkipUnless(liveConfig != nil, "Set TMDB_LIVE_TESTS=1 and TMDB_ACCESS_TOKEN/TMDB_API_KEY.")
        let results = try await TMDBMetadata.search("blade runner", configuration: liveConfig!)
        XCTAssertFalse(results.results.isEmpty)

        let movie = try await TMDBMetadata.movie(78, configuration: liveConfig!)
        XCTAssertEqual(movie.id, 78)
        XCTAssertFalse(movie.title.isEmpty)

        let show = try await TMDBMetadata.tv(1396, configuration: liveConfig!)
        XCTAssertFalse(show.name.isEmpty)

        if ProcessInfo.processInfo.environment["TMDB_PRINT"] == "1" {
            print("=== TMDB 'blade runner' ===")
            for r in results.results.prefix(4) {
                print("• [\(r.mediaType)] \(r.title) (\(r.date ?? "?")) ★\(r.voteAverage ?? 0)")
            }
            print("movie 78: \(movie.title) (\(movie.year ?? 0)) — \(movie.runtime ?? 0)min \(movie.genres)")
            print("tv 1396: \(show.name) — \(show.numberOfSeasons ?? 0) seasons, \(show.networks)")
        }
    }

    // MARK: - Helpers

    private func json(_ string: String) throws -> [String: Any] {
        try XCTUnwrap(try JSONSerialization.jsonObject(with: Data(string.utf8)) as? [String: Any])
    }
}

// MARK: - Fixtures (mirror the documented TMDB shapes)

private enum Fixture {
    static let searchMulti = """
    { "page": 1, "total_results": 2, "total_pages": 1, "results": [
        { "id": 78, "media_type": "movie", "title": "Blade Runner", "release_date": "1982-06-25",
          "vote_average": 8.1, "vote_count": 13000, "poster_path": "/poster.jpg", "genre_ids": [878, 18] },
        { "id": 89855, "media_type": "tv", "name": "Blade Runner: Black Lotus", "first_air_date": "2021-11-13",
          "vote_average": 7.0, "poster_path": "/bl.jpg", "genre_ids": [16] }
    ] }
    """

    static let movie = """
    { "id": 78, "title": "Blade Runner", "original_title": "Blade Runner",
      "tagline": "Man has made his match... now it's his problem.",
      "overview": "In the smog-choked dystopian Los Angeles of 2019…",
      "release_date": "1982-06-25", "runtime": 117, "vote_average": 8.1, "vote_count": 13000,
      "status": "Released", "original_language": "en", "imdb_id": "tt0083658",
      "budget": 28000000, "revenue": 41600000, "homepage": "",
      "poster_path": "/poster.jpg", "backdrop_path": "/backdrop.jpg",
      "genres": [ { "id": 878, "name": "Science Fiction" }, { "id": 18, "name": "Drama" }, { "id": 53, "name": "Thriller" } ] }
    """

    static let show = """
    { "id": 1396, "name": "Breaking Bad", "original_name": "Breaking Bad",
      "overview": "Walter White, a chemistry teacher…", "first_air_date": "2008-01-20",
      "last_air_date": "2013-09-29", "number_of_seasons": 5, "number_of_episodes": 62,
      "episode_run_time": [ 45, 47 ], "vote_average": 8.9, "status": "Ended", "original_language": "en",
      "poster_path": "/bb.jpg", "genres": [ { "id": 18, "name": "Drama" } ],
      "networks": [ { "id": 174, "name": "AMC" } ] }
    """
}
