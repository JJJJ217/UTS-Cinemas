//
//  ProfileView.swift
//  UTS Cinemas
//
//  Created by Jiaming Huang on 5/5/2026.
//

import SwiftUI

// Login and registration view and functionality for both customers and admins
struct ProfileView: View {
    @StateObject private var authManager = AuthManager.shared
    
    @State private var isLoginMode = true
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var phoneString = ""
    @State private var address = ""
    @State private var isAdmin = false
    
    @State private var errorMessage = ""
    
    // Clear fields when swtiching between login and registeration
    @FocusState private var focusedField: Field?
    private enum Field {
        case name, email, password, phone, address
    }
    
    var body: some View {
        NavigationStack {
            if let user = authManager.currentUser {
                authenticatedView(for: user)
            } else {
                unauthenticatedView
            }
        }
    }
    
    private func authenticatedView(for user: AppUser) -> some View {
        VStack {
            Text(user.name)
                .font(.title)
                .fontWeight(.bold)
            
            Text(user.email)
                .foregroundStyle(.secondary)
            
            Text("Role: \(user.role == .admin ? "Admin" : "Customer")")
                .font(.headline)
                .padding(.top, 10)
            
            Button(action: authManager.logout) {
                Text("Sign Out")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
    
    private var unauthenticatedView: some View {
        ScrollView {
            VStack(spacing: 16) {
                Picker("Mode", selection: $isLoginMode) {
                    Text("Log In").tag(true)
                    Text("Register").tag(false)
                }
                .pickerStyle(.segmented)
                .padding(.bottom)
                .onChange(of: isLoginMode) { _ in
                    clearFields()
                    
                }
                
                // Text fields for login and registration
                if !isLoginMode {
                    TextField("Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .name)
                }
                
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .email)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .password)
             
                
                if !isLoginMode {
                    Toggle("Register as Admin", isOn: $isAdmin)
                        .padding()
                    
                    if !isAdmin {
                        TextField("Phone (numbers only)", text: $phoneString)
                            .textFieldStyle(.roundedBorder)
                         
                        
                        TextField("Address", text: $address)
                            .textFieldStyle(.roundedBorder)
                         
                    }
                }
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                Button(action: handleAction) {
                    Text(isLoginMode ? "Log In" : "Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()
            }
            .padding()
        }
        .navigationTitle(isLoginMode ? "Welcome Back" : "Create Account")
    }
    
    // Authentication handling with error validation
    private func handleAction() {
        // 1. Email error handling
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address."
            return
        }
        // 2. Login Validation
        if isLoginMode {
            if !authManager.login(email: email, password: password) {
                errorMessage = "Invalid email or password."
            }
            return
        }

        // 3. Registration Validation
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let trimmedPass = password.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedName.isEmpty, !trimmedPass.isEmpty else {
            errorMessage = "Name and password cannot be empty."
            return
        }

        // 4. Distinguish between customer and admin role registration
        if isAdmin {
            if !authManager.registerAdmin(name: name, email: email, password: password) {
                errorMessage = "Email already in use."
            }
        } else {
            guard let phone = Int(phoneString), isValidPhone(phoneString) else {
                errorMessage = "Phone number must be numeric and cannot be empty."
                return
            }

            if !authManager.registerCustomer(name: name, email: email, password: password, phone: phone, address: address) {
                errorMessage = "Email already in use."
            }
        }
    }
    
    // Email format validation
    // Must be in the format of "@domain.com"
    private func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    // Phone number validation, must be in numeric
    private func isValidPhone(_ phone: String) -> Bool {
        return !phone.isEmpty && phone.allSatisfy { $0.isNumber }
    }
    
    // clear text when switching between login and regiration
    private func clearFields() {
        email = ""
        password = ""
        name = ""
        phoneString = ""
        address = ""
        errorMessage = ""
    }
}

#Preview {
    ProfileView()
}
