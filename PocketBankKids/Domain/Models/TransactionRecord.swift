//
//  TransactionCategory.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 25/11/26.
//

import Foundation
import SwiftData

enum TransactionCategory: String, Codable, CaseIterable {
    case deposit = "Depósito"
    case mission = "Missão"
    case goalReward = "Meta Concluída"
}

@Model
final class TransactionRecord {
    @Attribute(.unique) var id: UUID
    var title: String
    var amount: Double
    var xpEarned: Int
    var categoryRaw: String
    var date: Date
    var userEmail: String
    
    init(
        id: UUID = UUID(),
        title: String,
        amount: Double,
        xpEarned: Int,
        category: TransactionCategory,
        date: Date = .now,
        userEmail: String
    ) {
        self.id = id
        self.title = title
        self.amount = amount
        self.xpEarned = xpEarned
        self.categoryRaw = category.rawValue
        self.date = date
        self.userEmail = userEmail
    }
    
    var category: TransactionCategory {
        TransactionCategory(rawValue: categoryRaw) ?? .deposit
    }
}
