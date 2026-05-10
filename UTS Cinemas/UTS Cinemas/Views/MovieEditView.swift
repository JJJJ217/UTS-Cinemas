import SwiftUI

struct MovieEditView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var movieManager = MovieManager.shared
    
    @State private var selectedTemplateIndex = 0
    @State private var location = "HOYTS"
    @State private var showtime = Date()
    
    var selectedMovie: MovieTemplate {
        movieManager.movieTemplates[selectedTemplateIndex]
    }
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                Section("Movie") {
                    
                    Picker("Select Movie", selection: $selectedTemplateIndex) {
                        
                        ForEach(movieManager.movieTemplates.indices, id: \.self) { index in
                            
                            Text(movieManager.movieTemplates[index].title)
                                .tag(index)
                        }
                    }
                }
                
                Section("Preview") {
                    
                    Image(selectedMovie.posterName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .cornerRadius(20)
                    
                    Text(selectedMovie.genre)
                    Text("Duration: \(selectedMovie.duration) min")
                    Text("Rating: \(selectedMovie.rating.rawValue.uppercased())")
                }
                
                Section("Showing Details") {
                    
                    TextField("Cinema Location", text: $location)
                    
                    DatePicker(
                        "Showtime",
                        selection: $showtime,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
            }
            .navigationTitle("Add Showing")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    
                    Button("Save") {
                        
                        movieManager.createMovie(
                            title: selectedMovie.title,
                            genre: selectedMovie.genre,
                            durationMinutes: selectedMovie.duration,
                            rating: selectedMovie.rating,
                            posterImageName: selectedMovie.posterName,
                            description: selectedMovie.description,
                            location: location,
                            showtime: showtime,
                            trailerURL: selectedMovie.trailerURL
                        )
                        
                        dismiss()
                    }
                }
            }
        }
    }
}
