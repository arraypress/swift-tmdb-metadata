# Swift TMDB Metadata

A Swift library for searching and fetching movie & TV metadata from [The Movie Database (TMDB)](https://www.themoviedb.org).

## Features

- 🎬 **Movies & TV** — full detail (overview, genres, runtime, ratings, budget/revenue, networks, IMDb ID…)
- 🔎 **Search** — multi (movies + TV + people), or type-specific; paginated
- 🔥 **Trending** — trending movies/TV by day or week
- 🖼️ **Images** — build poster/backdrop URLs at any size via `TMDBImageSize`
- 🔑 **Flexible auth** — v4 access token (bearer) *or* v3 API key, from config or environment
- 🍎 **Cross-platform** — macOS, iOS, tvOS, watchOS · Swift 6 · async/await
- 🛡️ **Typed error handling**

## Authentication

TMDB requires a free credential. Get one at <https://www.themoviedb.org/settings/api> — you'll receive both an **API Key (v3)** and an **API Read Access Token (v4)**; either works.

- Pass it explicitly: `Configuration(accessToken: "…")` or `Configuration(apiKey: "…")`
- Or set `TMDB_ACCESS_TOKEN` / `TMDB_API_KEY` in the environment

## Usage

```swift
import TMDBMetadata

// Multi-search (movies + TV + people)
let results = try await TMDBMetadata.search("blade runner")
for hit in results.results where hit.isMovie {
    print("\(hit.title) (\(hit.date ?? "")) — ★\(hit.voteAverage ?? 0)")
    print(hit.posterURL(size: .w342) ?? "")
}

// Full movie detail
let movie = try await TMDBMetadata.movie(78)     // Blade Runner
print("\(movie.title) (\(movie.year ?? 0)) — \(movie.runtime ?? 0)min \(movie.genres)")

// Full TV detail
let show = try await TMDBMetadata.tv(1396)       // Breaking Bad
print("\(show.name) — \(show.numberOfSeasons ?? 0) seasons on \(show.networks.joined(separator: ", "))")

// Trending this week
let trending = try await TMDBMetadata.trending(media: "all", window: "week")
```

## Models

| Type | Description |
|------|-------------|
| `TMDBSearchResults` / `TMDBResult` | Paginated hits; `TMDBResult` unifies movie/TV/person (`mediaType`, `isMovie`/`isTV`, `title`, `date`, rating, `posterURL(size:)`) |
| `TMDBMovie` | `title`, `overview`, `tagline`, `releaseDate`/`year`, `runtime`, `genres`, `voteAverage`, `budget`, `revenue`, `imdbID`, `posterURL`/`backdropURL`, … |
| `TMDBShow` | `name`, `firstAirDate`/`year`, `numberOfSeasons`/`Episodes`, `genres`, `networks`, `status`, ratings, images |
| `TMDBSearchType` / `TMDBImageSize` | Search-type and image-size enums |
| `TMDBMetadataError` | Typed errors with `errorDescription` |

## Testing

```bash
swift test                                              # offline unit tests (fixtures)
TMDB_LIVE_TESTS=1 TMDB_ACCESS_TOKEN=… swift test        # + live network tests
```

## License

MIT

## Author

David Sherlock
