//
//  TMDBShow+Derived.swift
//  TMDBMetadata
//
//  Created by David Sherlock on 2026.
//
//  The show's derived facts. URL assembly delegates into Support
//  via the size vocabulary; the year parse is stated in full.
//

import Foundation

extension TMDBShow {

    /// The first-air year, parsed from ``firstAirDate``.
    public var year: Int? { firstAirDate.flatMap { Int($0.prefix(4)) } }

    /// A poster URL at the given size (defaults to `w500`).
    public func posterURL(size: TMDBImageSize = .w500) -> String? { size.url(for: posterPath) }

    /// A backdrop URL at the given size (defaults to `w780`).
    public func backdropURL(size: TMDBImageSize = .w780) -> String? { size.url(for: backdropPath) }
}
