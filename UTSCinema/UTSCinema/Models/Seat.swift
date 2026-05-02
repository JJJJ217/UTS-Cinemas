import Foundation

struct Seat: Identifiable, Hashable {
    let id = UUID()
    let row: Int
    let number: Int
    let isPremium: Bool
    var isBooked: Bool
}
