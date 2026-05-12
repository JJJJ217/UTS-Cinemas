//
//  Cinemas.swift
//  UTS Cinemas
//
//  Created by Jiaming Huang on 29/4/2026.
//

import Foundation

struct Movie: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var genre: String
    var durationMinutes: Int
    var rating: ContentRating
    var posterImageName: String
    var description: String
    var location: String
    var showtime: Date = Date()
    var trailerURL: String = ""
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
    var isExpired: Bool {
        showtime < Self.now
    }
    var isValidShowtime: Bool {
        showtime >= Self.now
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
