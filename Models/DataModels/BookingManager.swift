//
//  BookingManager.swift
//  UTS Cinemas
//
//  Created by Jiaming Huang on 29/4/2026.
//
import Foundation

class BookingManager: ObservableObject {
    static let shared = BookingManager()
    
    @Published var bookings: [Booking] = []
    
    private let filename = "bookings.json"
    
    private var fileURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(filename)
    }
    
    private init() {
        loadBookings()
    }
    
    func loadBookings() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return
        }
        do {
            let data = try Data(contentsOf: fileURL)
            self.bookings = try JSONDecoder().decode([Booking].self, from: data)
        } catch {
            print("Unable to load bookings: \(error)")
        }
    }
    
    func saveBookings() {
        do {
            let data = try JSONEncoder().encode(bookings)
            try data.write(to: fileURL)
        } catch {
            print("Unable to save bookings: \(error)")
        }
    }
    
    func createBooking(movieId: UUID, bookedSeatId: UUID, seats: [String], customerId: UUID?, price: Double) {
        let newBooking = Booking(movieId: movieId, bookedSeatId: bookedSeatId, seats: seats, customerId: customerId, price: price)
        bookings.append(newBooking)
        saveBookings()
    }
    
    func updateBooking(_ booking: Booking) {
        if let index = bookings.firstIndex(where: { $0.id == booking.id }) {
            bookings[index] = booking
            saveBookings()
        }
    }
    
    func deleteBooking(_ booking: Booking) {
        bookings.removeAll(where: { $0.id == booking.id })
        saveBookings()
    }
    
    func userBookings(customerId: UUID?) -> [Booking] {
        if let id = customerId {
            return bookings.filter { $0.customerId == id }
        } else {
            return bookings.filter { $0.customerId == nil }
        }
    }
    
    func bookedSeats(_ bookedSeatId: UUID) -> Set<String> {
        let seats = bookings.filter { $0.bookedSeatId == bookedSeatId }.flatMap { $0.seats }
        return Set(seats)
    }
    
    func cancelBooking(_ booking: Booking) {
        print("Your refund of $\(booking.price) for booking ID: \(booking.id) has been processed.")
            bookings.removeAll(where: { $0.id == booking.id })
            saveBookings()
    }
}
