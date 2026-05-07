//
//  Users.swift
//  UTS Cinemas
//
//  Created by Jiaming Huang on 29/4/2026.
//

import Foundation

enum UserRole: Codable, Hashable {
    case customer
    case admin
}

protocol AppUser {
    var id: UUID { get }
    var name: String { get set }
    var email: String { get set }
    var password: String { get set }
    var role: UserRole { get }
}

struct Customer: AppUser, Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var phone: Int
    var email: String
    var password: String
    var address: String
    var role: UserRole { .customer }
}

struct Admin: AppUser, Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var email: String
    var password: String
    var role: UserRole { .admin }
}
