//
//  MovieManager.swift
//  UTS Cinemas
//
//  Created by Jiaming Huang on 29/4/2026.
//


import Foundation

class MovieManager {
    static let shared = MovieManager()
    
    private let filename = "movies.json"
    
    private var fileURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(filename)
    }
    
    private init() {}
}
