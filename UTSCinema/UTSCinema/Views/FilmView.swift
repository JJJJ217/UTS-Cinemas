import SwiftUI

struct FilmView: View {
    
    @ObservedObject var viewModel: BookingViewModel
    @Binding var filmPath: NavigationPath
    
    let movies = [
        Movie(title: "Avengers"),
        Movie(title: "Batman"),
        Movie(title: "Spider-Man")
    ]
    
    let times = ["12:00", "15:00", "18:00"]
    
    var body: some View {
        List {
            ForEach(movies) { movie in
                VStack(spacing: 10) {
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 150)
                        .cornerRadius(10)
                    
                    Text(movie.title)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(times, id: \.self) { time in
                                NavigationLink {
                                    TicketSelectionView(
                                        movie: movie,
                                        time: time,
                                        viewModel: viewModel,
                                        filmPath: $filmPath
                                    )
                                } label: {
                                    Text(time)
                                        .padding(8)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Films")
    }
}
