import SwiftUI

struct TicketSelectionView: View {
    
    let movie: Movie
    let time: String
    
    @ObservedObject var viewModel: BookingViewModel
    @Binding var filmPath: NavigationPath
    
    @State private var tickets: [String: Int] = [
        "Adult Standard": 0,
        "Adult Premium": 0,
        "Student Standard": 0,
        "Student Premium": 0,
        "Child Standard": 0,
        "Elderly Standard": 0
    ]
    
    var totalTickets: Int {
        tickets.values.reduce(0, +)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text(movie.title)
                .font(.title)
                .bold()
            
            Text("Select Tickets")
                .font(.headline)
            
            ForEach(tickets.keys.sorted(), id: \.self) { key in
                HStack {
                    VStack(alignment: .leading) {
                        Text(key)
                        Text("$\(price(for: key))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Button("-") {
                        if tickets[key]! > 0 {
                            tickets[key]! -= 1
                        }
                    }
                    
                    Text("\(tickets[key]!)")
                        .frame(width: 30)
                    
                    Button("+") {
                        if totalTickets < 6 {
                            tickets[key]! += 1
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            
            Text("Total: \(totalTickets)")
            
            NavigationLink("Continue") {
                SeatSelectionView(
                    movie: movie,
                    selectedTime: time,
                    maxSeats: totalTickets,
                    ticketBreakdown: tickets,
                    viewModel: viewModel,
                    filmPath: $filmPath
                )
            }
            .disabled(totalTickets == 0)
            .padding()
            .frame(maxWidth: .infinity)
            .background(totalTickets == 0 ? Color.gray : Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
    
    func price(for type: String) -> Int {
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
