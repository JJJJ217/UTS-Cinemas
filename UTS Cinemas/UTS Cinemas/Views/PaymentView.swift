//
//  PaymentView.swift
//  UTS Cinemas
//
//  Created by Jiaming Huang on 6/5/2026.
//

import SwiftUI

struct PaymentView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var bookingManager = BookingManager.shared
    @ObservedObject var movieManager = MovieManager.shared
    
    // Data passed from previous view
    let movieId: UUID
    let seats: [String]
    let bookedSeatId: UUID
    let customerId: UUID?
    let onPaymentSuccess: (() -> Void)?
    
    // State variables for payment processing
    @State private var selectedPaymentMethod: PaymentMethod = .applePay
    @State private var isProcessing = false
    @State private var showSuccessAlert = false
    @State private var errorMessage: String?
    
    // State variables for Credit Card Form
    @State private var cardholderName: String = ""
    @State private var cardNumber: String = ""
    @State private var expiryDate: String = ""
    @State private var cvv: String = ""
    
    enum PaymentMethod {
        case applePay
        case creditCard
    }
    
    // Seat price
    private var totalPrice: Double {
        Double(seats.count) * 17.50
    }
    
    var body: some View {
        // This view should rely on the NavigationStack of the parent view that presented it.
        VStack(spacing: 12) {
            
            bookingSummarySection
            
            paymentMethodSection
            
            if selectedPaymentMethod == .creditCard {
                creditCardFormSection
            }
            
            Spacer()
            
            if let error = errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
            }
            
            payButton
        }
        .padding()
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)

        .alert("Payment Successful", isPresented: $showSuccessAlert) {
            Button("OK") {
                dismiss()
                onPaymentSuccess?()
            }
        } message: {
            Text("Your booking has been confirmed. Check your bookings for details.")
        }
    }
    
    // Booking summary section that displays the selected movie, seats, and total price.
    private var bookingSummarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Booking Summary")
                .font(.headline)
            
            if let movie = movieManager.movies.first(where: { $0.id == movieId }) {
                HStack {
                    Text("Movie:")
                    Spacer()
                    Text(movie.title)
                        .fontWeight(.semibold)
                }
            }
            
            HStack {
                Text("Seats:")
                Spacer()
                Text(seats.joined(separator: ", "))
                    .bold()
            }
            
            HStack {
                Text("Total Price:")
                Spacer()
                Text("$\(totalPrice, specifier: "%.2f")")
                    .foregroundColor(.green)
                    .bold()
            }
        }
        .padding()
    }
    
    // This section allows users to select between Apple Pay and Credit Card payment methods.
    private var paymentMethodSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Payment Method")
                .font(.headline)
            
            // Apple Pay Option
            Button(action: { selectedPaymentMethod = .applePay }) {
                HStack {
                    Image(systemName: "apple.logo")
                        .font(.title3)
                    VStack(alignment: .leading) {
                        Text("Apple Pay")
                            .font(.headline)
                    }
                    
                    Spacer()
                    
                    if selectedPaymentMethod == .applePay {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                .padding()
                .background(selectedPaymentMethod == .applePay ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(selectedPaymentMethod == .applePay ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
            
            // Credit Card Option
            Button(action: { selectedPaymentMethod = .creditCard }) {
                HStack {
                    Image(systemName: "creditcard.fill")
                        .font(.title3)
                    VStack(alignment: .leading) {
                        Text("Credit Card")
                            .font(.headline)
                        Text("Visa, Mastercard, Amex")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    if selectedPaymentMethod == .creditCard {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                .padding()
                .background(selectedPaymentMethod == .creditCard ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(selectedPaymentMethod == .creditCard ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
            .foregroundStyle(.primary)
        }
    }
    
    // This section contains the credit card form fields.
    // Only appears when the user selects the Credit Card payment method.
    private var creditCardFormSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Cardholder Name", text: $cardholderName)
                .textFieldStyle(.roundedBorder)
            
            VStack(alignment: .leading, spacing: 4) {
                TextField("Card Number", text: $cardNumber)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .onChange(of: cardNumber) { newValue in
                        cardNumber = String(newValue.filter { $0.isNumber }.prefix(16))
                    }
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("MM/YY", text: $expiryDate)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .onChange(of: expiryDate) { newValue in
                                formatExpiryDate(newValue)
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("CVV", text: $cvv)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .onChange(of: cvv) { newValue in
                                cvv = String(newValue.filter { $0.isNumber }.prefix(4))
                            }
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var payButton: some View {
        Button(action: processPayment) {
            if isProcessing {
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 50)
            } else {
                Text("Pay $\(totalPrice, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .disabled(isProcessing)
    }
    
    // Extracted out of the view body to prevent Xcode from crashing
    private func formatExpiryDate(_ newValue: String) {
        let numbersOnly = newValue.filter { $0.isNumber }
        var formatted = ""
        for (index, char) in numbersOnly.prefix(4).enumerated() {
            if index == 2 {
                formatted += "/"
            }
            formatted.append(char)
        }
        expiryDate = formatted
    }
    
    private func processPayment() {
        isProcessing = true
        errorMessage = nil
        
        // Simulating network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if selectedPaymentMethod == .applePay {
                completeBooking()
            } else if selectedPaymentMethod == .creditCard {
                if validateCreditCard() {
                    completeBooking()
                } else {
                    errorMessage = "Invalid credit card information."
                    isProcessing = false
                }
            }
        }
    }
    
    // Validation for credit card fields.
    private func validateCreditCard() -> Bool {
        guard !cardholderName.trimmingCharacters(in: .whitespaces).isEmpty,
              cardNumber.count >= 13,
              expiryDate.count == 5, expiryDate.contains("/"),
              cvv.count >= 3 else {
            return false
        }
        return true
    }
    
    private func completeBooking() {
        bookingManager.createBooking(
            movieId: movieId,
            bookedSeatId: bookedSeatId,
            seats: seats,
            customerId: customerId,
            price: totalPrice
        )
        
        isProcessing = false
        showSuccessAlert = true
    }
}

#Preview {
    PaymentView(
        movieId: UUID(),
        seats: ["A1", "A2"],
        bookedSeatId: UUID(),
        customerId: nil,
        onPaymentSuccess: nil
    )
}
