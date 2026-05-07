//
//  AuthManager.swift
//  UTS Cinemas
//
//  Created by Jiaming Huang on 5/5/2026.
//

import SwiftUI
import Foundation

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var currentUser: (AppUser)? = nil
    
    @Published var customers: [Customer] = []
    @Published var admins: [Admin] = []
    
    private let customersFile = "customers.json"
    private let adminsFile = "admins.json"
    
    private var customersURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(customersFile)
    }
    
    private var adminsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(adminsFile)
    }
    
    private init() {
        loadUsers()
    }
    
    func loadUsers() {
        if let data = try? Data(contentsOf: customersURL),
           let decoded = try? JSONDecoder().decode([Customer].self, from: data) {
            customers = decoded
        }
        
        if let data = try? Data(contentsOf: adminsURL),
           let decoded = try? JSONDecoder().decode([Admin].self, from: data) {
            admins = decoded
        }
    }
    
    func saveUsers() {
        if let data = try? JSONEncoder().encode(customers) {
            try? data.write(to: customersURL)
        }
        if let data = try? JSONEncoder().encode(admins) {
            try? data.write(to: adminsURL)
        }
    }
    
    func login(email: String, password: String) -> Bool {
        if let customer = customers.first(where: { $0.email == email && $0.password == password }) {
            currentUser = customer
            return true
        }
        
        if let admin = admins.first(where: { $0.email == email && $0.password == password }) {
            currentUser = admin
            return true
        }
        
        return false
    }
    
    func registerCustomer(name: String, email: String, password: String, phone: Int, address: String) -> Bool {
        guard !customers.contains(where: { $0.email == email }),
              !admins.contains(where: { $0.email == email }) else { return false }
        
        let newCustomer = Customer(name: name, phone: phone, email: email, password: password, address: address)
        customers.append(newCustomer)
        saveUsers()
        currentUser = newCustomer
        return true
    }
    
    func registerAdmin(name: String, email: String, password: String) -> Bool {
        guard !customers.contains(where: { $0.email == email }),
              !admins.contains(where: { $0.email == email }) else { return false }
        
        let newAdmin = Admin(name: name, email: email, password: password)
        admins.append(newAdmin)
        saveUsers()
        currentUser = newAdmin
        return true
    }
    
    func logout() {
        currentUser = nil
    }
}
