import SwiftUI
import Combine

struct BookingSummaryView: View {
    
    let movie: Movie
    let time: String
    let ticketBreakdown: [String: Int]
    
    @ObservedObject var viewModel: BookingViewModel
    @Binding var filmPath: NavigationPath
    
    @State private var goToConfirmation = false
    
    var total: Int {
        var total = 0
        for (type, count) in ticketBreakdown {
            total += priceFor(type) * count
        }
        return total
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Booking Summary")
                .font(.title)
                .bold()
            
            Text(movie.title)
            Text("Time: \(time)")
            
            VStack(alignment: .leading) {
                Text("Tickets:")
                    .font(.headline)
                
                ForEach(ticketBreakdown.keys.sorted(), id: \.self) { key in
                    if let value = ticketBreakdown[key], value > 0 {
                        Text("\(key): \(value)")
                    }
                }
            }
            
            Text("Seats: \(viewModel.selectedSeats.map { "R\($0.row)S\($0.number)" }.joined(separator: ", "))")
            
            Text("Total: $\(total)")
                .font(.headline)
            
            Button("Confirm Booking") {
                viewModel.confirmBooking(movie: movie, time: time)
                goToConfirmation = true
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            // 🔥 Navigation to confirmation
            NavigationLink(
                destination: ConfirmationView(
                    movie: movie,
                    time: time,
                    seats: viewModel.selectedSeats,
                    ticketBreakdown: ticketBreakdown,
                    viewModel: viewModel,
                    filmPath: $filmPath
                ),
                isActive: $goToConfirmation
            ) {
                EmptyView()
            }
        }
        .padding()
    }
    
    func priceFor(_ type: String) -> Int {
        switch type {
        case "Adult Premium": return 15
        case "Student Premium": return 13
        case "Adult Standard": return 12
        case "Student Standard": return 10
        case "Child Standard": return 8
        case "Elderly Standard": return 9
        default: return 10
        }
    }
}
