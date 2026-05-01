//
//  BookingManager.swift
//  UTS Cinemas
//
//  Created by Jiaming Huang on 29/4/2026.
//
import Foundation

class BookingManager {
    static let shared = BookingManager()
    
    private let filename = "bookings.json"
    
    private var fileURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(filename)
    }
    
    private init() {}
}
