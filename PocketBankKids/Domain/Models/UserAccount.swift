//
//  UserAccount.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 25/11/26.
//

import Foundation
import SwiftData

@Model
final class UserAccount {
    @Attribute(.unique) var id: UUID
    var name: String
    var email: String
    var passwordHash: String
    var balance: Double
    var xp: Int
    var avatarSeed: String
    var completedMissionIds: [Int]
    
    init(
        id: UUID = UUID(),
        name: String,
        email: String,
        passwordHash: String,
        balance: Double = 0.0,
        xp: Int = 0,
        avatarSeed: String = "dragon",
        completedMissionIds: [Int] = []) {
        self.id = id
        self.name = name
        self.email = email
        self.passwordHash = passwordHash
        self.balance = balance
        self.xp = xp
        self.avatarSeed = avatarSeed
        self.completedMissionIds = completedMissionIds
    }
    
    var level: Int {
        max(1, (xp / 100) + 1)
    }
    
    var xpProgressInCurrentLevel: Double {
        Double(xp % 100) / 100.0
    }
    
    var evolutionStageName: String {
        switch level {
        case 1: return "Ovo Curioso 🥚"
        case 2: return "Filhote Poupador 🐣"
        case 3: return "Guardião das Moedas 🛡️"
        default: return "Dragão Lendário do Cofre 🐍"
        }
    }
    
    var evolutionEmoji: String {
        switch level {
        case 1: return " 🥚 "
        case 2: return " 🐣 "
        case 3: return " 🦊 "
        default: return " 🐍 "
        }
    }
}
