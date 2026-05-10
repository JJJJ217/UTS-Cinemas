import Foundation

struct MovieTemplate: Identifiable {
    let id = UUID()
    let title: String
    let posterName: String
    let genre: String
    let duration: Int
    let rating: ContentRating
    let description: String
    let trailerURL: String
}
