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

struct Customer: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var phone: Int
    var email: String
    var address: String
    var role: UserRole { .customer }
}

struct Admin: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var email: String
    var role: UserRole { .admin }
}
