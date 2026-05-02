import Foundation

struct Booking: Identifiable {
    let id = UUID()
    let movie: Movie
    let time: String
    let seats: [Seat]
}
