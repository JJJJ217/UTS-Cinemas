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
    var synopsis: String
}

struct Cinema: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var address: String
}

struct Showtime: Identifiable, Hashable, Codable {
    var id = UUID()
    var movieId: UUID
    var cinemaId: UUID
    var startTime: Date
    var price: Decimal
}

struct Booking: Identifiable, Hashable, Codable {
    var id = UUID()
    var showtimeId: UUID
    var seats: [String]       
    var customerId: UUID
    var createdAt = Date()
}

enum ContentRating: String, Codable, Hashable {
    case g
    case pg
    case m
    case ma15
    case r18
}
