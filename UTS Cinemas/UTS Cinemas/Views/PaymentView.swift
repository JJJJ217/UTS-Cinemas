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
    @State private var emailAddress: String = ""
    @State private var studentVerified = false
    @State private var cardholderName: String = ""
    @State private var cardNumber: String = ""
    @State private var expiryDate: String = ""
    @State private var cvv: String = ""
    
    // State variables for Student discount
    @State private var useStudentDiscount = false
    @State private var studentEmail: String = ""
    @State private var studentID: String = ""
    @State private var universityName: String = ""

    private var finalPrice: Double {
        (useStudentDiscount && studentVerified) ? totalPrice * 0.5 : totalPrice
    }
    
    // payment methods:
    enum PaymentMethod {
        case applePay
        case creditCard
    }
    
    // Seat price
    private var totalPrice: Double {
        Double(seats.count) * 17.50
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {

                bookingSummarySection

                paymentMethodSection

                studentDiscountSection

                if selectedPaymentMethod == .creditCard {
                    creditCardFormSection
                }

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
        }
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
        }
        .alert("Payment Successful", isPresented: $showSuccessAlert) {
            Button("OK") {
                dismiss()
                onPaymentSuccess?()
            }
        } message: {
            Text("Your booking has been confirmed. You will receive an email confirmation.")
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
                Text("$\(finalPrice, specifier: "%.2f")")
                    .foregroundColor(.green)
                    .bold()
            }
            
            HStack {
                Text("Please do not add any real credit card details in this system. ")
                    .font(.caption)
                    .foregroundColor(.red)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .padding(8)
                   .background(Color.red.opacity(0.1))
                   .overlay(
                       RoundedRectangle(cornerRadius: 8)
                           .stroke(Color.red.opacity(0.4), lineWidth: 1)
                   )
                   .cornerRadius(8)
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
    
      // student discount:
    // student discount:
    private var studentDiscountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Are you a UTS student?")
                .font(.headline)

            Button(action: {
                useStudentDiscount.toggle()
                if !useStudentDiscount {
                    studentVerified = false
                    errorMessage = nil
                }
            }) {
                HStack {
                    Image(systemName: "graduationcap.fill")
                        .font(.title3)

                    VStack(alignment: .leading) {
                        Text("Student Discount")
                            .font(.headline)
                        Text("50% off (UTS students only)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    if useStudentDiscount && studentVerified {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                .padding()
                .background(useStudentDiscount ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(useStudentDiscount ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
            .foregroundStyle(.primary)

            if useStudentDiscount {
                VStack(spacing: 10) {
                    TextField("Student Email", text: $studentEmail)
                        .textFieldStyle(.roundedBorder)

                    TextField("Student ID", text: $studentID)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .onChange(of: studentID) { newValue in
                            studentID = String(newValue.filter { $0.isNumber }.prefix(8))
                        }

                    TextField("University Name", text: $universityName)
                        .textFieldStyle(.roundedBorder)

                    Button("Verify Student") {
                        verifyStudent()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
    }
    
    
    // This section contains the credit card form fields.
    // Only appears when the user selects the Credit Card payment method.
    private var creditCardFormSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            TextField("Cardholder Name", text: $cardholderName)
                .textFieldStyle(.roundedBorder)
            
            TextField("Card Number", text: $cardNumber)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
               
            
            HStack(spacing: 10) {
                
                TextField("MM/YY", text: $expiryDate)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .onChange(of: expiryDate) { newValue in
                        formatExpiryDate(newValue)
                    }
                
                TextField("CVV", text: $cvv)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .onChange(of: cvv) { newValue in
                        cvv = String(newValue.filter { $0.isNumber }.prefix(4))
                    }
            }
            
            TextField("Email address (for confirmation)", text: $emailAddress)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
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
                Text("Pay $\(finalPrice, specifier: "%.2f")")
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
                if let error = validateCreditCard() {
                    errorMessage = error
                    isProcessing = false
                } else {
                    completeBooking()
                }
    
            }
        }
    }
    
    //verify if its uts student
    private func verifyStudent() {
        let isValidEmail = studentEmail.contains("@student.uts.edu.au")
        let uni = universityName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        let validUniversities = ["uts", "university of technology sydney"]
        let isValidUniversity = validUniversities.contains(uni)
        
        let isValidStudentID = studentID.count == 8 && studentID.allSatisfy { $0.isNumber }
        
        if isValidEmail && isValidStudentID && isValidUniversity {
            studentVerified = true
            errorMessage = nil
        } else {
            studentVerified = false
            
            if !isValidStudentID {
                errorMessage = "Invalid student ID"
            } else {
                errorMessage = "Invalid student details"
            }
        }
    }
    
    // Validation for credit card fields.
    private func validateCreditCard() -> String? {

        // below, added specific error messages for each scenario
        let name = cardholderName.trimmingCharacters(in: .whitespaces)
        if name.isEmpty {
            return "Cardholder name is empty"
        }
        if name.count < 3 {
            return "Cardholder name should be at least be 3 letters"
        }

        if !name.allSatisfy({ $0.isLetter || $0.isWhitespace }) {
            return "Cardholder name can only contain letters"
        }

        let numberValid = (13...16).contains(cardNumber.count)
        if !numberValid {
            return "Card number must be 13–16 digits"
        }

        let parts = expiryDate.split(separator: "/")
        let month = Int(parts.first ?? "") ?? 0

        let expiryValid =
            parts.count == 2 &&
            parts[0].count == 2 &&
            parts[1].count == 2 &&
            (1...12).contains(month)

        if !expiryValid {
            return "Expiry must be in the valid MM/YY format"
        }

        if !(3...4).contains(cvv.count) {
            return "CVV must be 3–4 digits"
        }
        
        let email = emailAddress.trimmingCharacters(in: .whitespacesAndNewlines)

        if email.isEmpty {
            return "Email is required"
        }

        if !email.contains("@") || !email.contains(".") {
            return "Enter a valid email address"
        }

        return nil
    }
    
    private func completeBooking() {
        bookingManager.createBooking(
            movieId: movieId,
            bookedSeatId: bookedSeatId,
            seats: seats,
            customerId: customerId,
            price: finalPrice
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
