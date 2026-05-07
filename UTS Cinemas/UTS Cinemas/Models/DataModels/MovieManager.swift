//
//  MovieManager.swift
//  UTS Cinemas
//
//  Created by Jiaming Huang on 29/4/2026.
//


import Foundation

// Allow admin users to create, update, and delete movies
class MovieManager: ObservableObject {
    static let shared = MovieManager()
    
    @Published var movies: [Movie] = []
    
    private let filename = "movies.json"
    
    private var fileURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(filename)
    }
    
    private init() {
        loadMovies()
    }
    
    func loadMovies() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return
        }
        do {
            let data = try Data(contentsOf: fileURL)
            self.movies = try JSONDecoder().decode([Movie].self, from: data)
        } catch {
            print("Unable to load movies: \(error)")
        }
    }
    
    func saveMovies() {
        do {
            let data = try JSONEncoder().encode(movies)
            try data.write(to: fileURL)
        } catch {
            print("Unable to save movies: \(error)")
        }
    }
    
    // Creating a new movie and add it to the movies array, then save the updated movies list
    func createMovie(title: String, genre: String, durationMinutes: Int, rating: ContentRating, posterImageName: String, description: String, location: String, showtime: Date) {
        let newMovie = Movie(title: title, genre: genre, durationMinutes: durationMinutes, rating: rating, posterImageName: posterImageName, description: description, location: location, showtime: showtime)
        movies.append(newMovie)
        movies.sort { $0.title < $1.title }
        saveMovies()
    }
    
    // Update an existing movie
    func updateMovie(_ movie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index] = movie
            movies.sort { $0.title < $1.title }
            saveMovies()
        }
    }
    
    // Delete an existing movie in the movie array
    func deleteMovie(_ movie: Movie) {
        movies.removeAll(where: { $0.id == movie.id })
        saveMovies()
    }
}
