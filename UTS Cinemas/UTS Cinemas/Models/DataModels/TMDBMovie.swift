//
//  TMDBMovie.swift
//  UTS Cinemas
//
//  Created by Ameer Ali on 3/5/2026.
//

import Foundation

// Matches TMDB API JSON response
struct TMDBMovie: Identifiable, Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double
    let runtime: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case runtime
    }

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }

    var formattedRating: String {
        String(format: "%.1f", voteAverage)
    }
}

struct TMDBResponse: Codable {
    let results: [TMDBMovie]
}
