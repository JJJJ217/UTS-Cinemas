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
    
    let movieTemplates: [MovieTemplate] = [
        MovieTemplate(
            title: "Mario",
            posterName: "The Super Mario",
            genre: "Family",
            duration: 120,
            rating: .pg,
            description: "Mario must save the Mushroom Kingdom.",
            trailerURL: "https://www.youtube.com/watch?v=TnGl01FkMMo"
        ),
        
        MovieTemplate(
            title: "The Mummy",
            posterName: "Lee Cronin's The Mummy",
            genre: "Horror",
            duration: 180,
            rating: .r18,
            description: "An ancient evil awakens beneath the sands.",
            trailerURL: "https://www.youtube.com/watch?v=IjHgzkQM2Sg"
        ),
        
        MovieTemplate(
            title: "Goat",
            posterName: "Goat",
            genre: "Drama",
            duration: 110,
            rating: .m,
            description: "A dramatic sports journey.",
            trailerURL: "https://www.youtube.com/watch?v=fGM8cIz8xJ0"
        )
    ]
    
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
    func createMovie(
        title: String,
        genre: String,
        durationMinutes: Int,
        rating: ContentRating,
        posterImageName: String,
        description: String,
        location: String,
        showtime: Date,
        trailerURL: String = ""
    ) {
        
        let newMovie = Movie(
            title: title,
            genre: genre,
            durationMinutes: durationMinutes,
            rating: rating,
            posterImageName: posterImageName,
            description: description,
            location: location,
            showtime: showtime,
            trailerURL: trailerURL
        )
        
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
