import SwiftUI

struct MovieEditView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var movieManager = MovieManager.shared
    
    var movieToEdit: Movie?
    
    @State private var title = ""
    @State private var genre = "Action"
    @State private var duration: Double = 120
    @State private var rating: ContentRating = .pg
    @State private var description = ""
    @State private var posterName = ""
    @State private var trailerURL = ""
    @State private var location = "UTS Cinemas"
    @State private var showtime = Date()
    
    private let genres = ["Action", "Comedy", "Drama", "Horror", "Family", "Sci-Fi", "Thriller"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Movie Details") {
                    TextField("Title", text: $title)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) { genre in
                            Text(genre).tag(genre)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Duration")
                            Spacer()
                            Text("\(Int(duration)) min")
                                .foregroundColor(.secondary)
                                .bold()
                        }
                        
                        Slider(value: $duration, in: 30...300, step: 5) {
                            Text("Duration")
                        } minimumValueLabel: {
                            Text("30m")
                        } maximumValueLabel: {
                            Text("300m")
                        }
                    }
                    .padding(.vertical, 5)
                    
                    Picker("Content Rating", selection: $rating) {
                        Text("G").tag(ContentRating.g)
                        Text("PG").tag(ContentRating.pg)
                        Text("M").tag(ContentRating.m)
                        Text("MA15+").tag(ContentRating.ma15)
                        Text("R18+").tag(ContentRating.r18)
                    }
                }
                
                Section("Media & Plot") {
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...5)
                    TextField("Poster Image Name", text: $posterName)
                    TextField("Trailer URL", text: $trailerURL)
                }
                
                Section("Cinema Details") {
                    TextField("Cinema Location", text: $location)
                    DatePicker("Showtime", selection: $showtime)
                }
            }
            .navigationTitle(movieToEdit == nil ? "New Movie" : "Edit Movie")
            .onAppear {
                if let movie = movieToEdit {
                    title = movie.title
                    genre = movie.genre
                    duration = Double(movie.durationMinutes)
                    rating = movie.rating
                    description = movie.description
                    posterName = movie.posterImageName == "default_poster" ? "" : movie.posterImageName
                    trailerURL = movie.trailerURL
                    location = movie.location
                    showtime = movie.showtime
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveMovie()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveMovie() {
        if var movie = movieToEdit {
            movie.title = title
            movie.genre = genre
            movie.durationMinutes = Int(duration)
            movie.rating = rating
            movie.posterImageName = posterName.isEmpty ? "default_poster" : posterName
            movie.description = description
            movie.location = location
            movie.showtime = showtime
            movie.trailerURL = trailerURL
            movieManager.updateMovie(movie)
        } else {
            movieManager.createMovie(
                title: title,
                genre: genre,
                durationMinutes: Int(duration),
                rating: rating,
                posterImageName: posterName.isEmpty ? "default_poster" : posterName,
                description: description,
                location: location,
                showtime: showtime,
                trailerURL: trailerURL
            )
        }
        dismiss()
    }
}
