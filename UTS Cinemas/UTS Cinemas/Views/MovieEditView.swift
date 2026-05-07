//
//  MovieEditView.swift
//  UTS Cinemas
//
//  Created by Jiaming Huang on 5/5/2026.
//

import SwiftUI

struct MovieEditView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var movieManager = MovieManager.shared
    
    var movieToEdit: Movie? = nil
    
    @State private var title = ""
    @State private var genre = ""
    @State private var durationMinutes: Int = 120
    @State private var rating: ContentRating = .pg
    @State private var description = ""
    @State private var posterImageName = ""
    @State private var location = ""
    @State private var showtime = Date()
    
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            Form {
                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Section("Details") {
                    TextField("Title", text: $title)
                    TextField("Genre", text: $genre)
                    
                    TextField("Location", text: $location)
                    DatePicker("Showtime", selection: $showtime, displayedComponents: [.date, .hourAndMinute])
                    
                    VStack() {
                        Text("Duration: \(durationMinutes) min")
                        Slider(value: Binding(
                            get: { Double(durationMinutes) },
                            set: { durationMinutes = Int($0) }
                        ), in: 60...300, step: 1)
                        
                    }
                }
                
                Section("Media") {
                    TextField("Poster URL or System Name (e.g. film)", text: $posterImageName)
                        .autocapitalization(.none)
                }
                
                Section("Rating") {
                    Picker("Rating", selection: $rating) {
                        Text("G").tag(ContentRating.g)
                        Text("PG").tag(ContentRating.pg)
                        Text("M").tag(ContentRating.m)
                        Text("MA15+").tag(ContentRating.ma15)
                        Text("R18+").tag(ContentRating.r18)
                    }
                }
                
                Section("Desciription") {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle(movieToEdit == nil ? "Add Movie" : "Edit Movie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let now = Date()
                        guard showtime >= now else {
                            errorMessage = "Movie showtime must be today or in the future"
                            return
                        }
                        save()
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                if let movie = movieToEdit {
                    title = movie.title
                    genre = movie.genre
                    durationMinutes = movie.durationMinutes
                    rating = movie.rating
                    description = movie.description
                    posterImageName = movie.posterImageName
                    location = movie.location
                    showtime = movie.showtime
                }
            }
        }
    }
    
    private func save() {
        if var movie = movieToEdit {
            movie.title = title
            movie.genre = genre
            movie.durationMinutes = durationMinutes
            movie.rating = rating
            movie.description = description
            movie.posterImageName = posterImageName.isEmpty ? "film" : posterImageName
            movie.location = location
            movie.showtime = showtime
            
            movieManager.updateMovie(movie)
            
        } else {
            movieManager.createMovie(
                title: title,
                genre: genre,
                durationMinutes: durationMinutes,
                rating: rating,
                posterImageName: posterImageName.isEmpty ? "film" : posterImageName,
                description: description,
                location: location,
                showtime: showtime
            )
        }
    }
}
