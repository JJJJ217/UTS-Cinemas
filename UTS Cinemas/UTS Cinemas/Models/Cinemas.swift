//
//  Cinemas.swift
//  UTS Cinemas
//
//  Created by Jiaming Huang on 29/4/2026.
//

import Foundation

struct Movie: Identifiable, Hashable, Codable {
    var id = UUID()
    var tmdbId: Int? = nil  // Optional TMDB ID for API movies
    var title: String
    var genre: String
    var durationMinutes: Int
    var rating: ContentRating
    var posterImageName: String
    var description: String
    var location: String
    var showtime: Date = Date()
    var trailerURL: String = ""
    var isFromTMDB: Bool = false  // Flag to indicate if movie is from TMDB
}

struct Cinema: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var address: String
}

struct Booking: Identifiable, Hashable, Codable {
    var id = UUID()
    var movieId: UUID
    var bookedSeatId: UUID
    var seats: [String]
    var customerId: UUID?
    var createdAt = Date()
    var price: Double
}

enum ContentRating: String, Codable, Hashable {
    case g
    case pg
    case m
    case ma15
    case r18
}

// Helper to determine if a movie is now showing or upcoming
extension Movie {
    static var now: Date { Date() }
    
    var endTime: Date {
        showtime.addingTimeInterval(Double(durationMinutes) * 60)
    }
    
    var isExpired: Bool {
        endTime < Self.now
    }
    var isValidShowtime: Bool {
        endTime >= Self.now
    }
    var isNowShowing: Bool {
        let cutoff = Calendar.current.date(byAdding: .day, value: 30, to: Self.now)!
        return isValidShowtime && showtime <= cutoff
    }
    var isUpcoming: Bool {
        let cutoff = Calendar.current.date(byAdding: .day, value: 30, to: Self.now)!
        return showtime > cutoff
    }
    
}
