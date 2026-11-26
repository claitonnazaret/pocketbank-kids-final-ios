//
//  SavingGoal.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 25/11/26.
//

import Foundation
import SwiftData

@Model
final class SavingsGoal: Hashable {
    @Attribute(.unique) var id: UUID
    var title: String
    var targetAmount: Double
    var currentAmount: Double
    var icon: String
    var isCompleted: Bool
    var createdAt: Date
    var userEmail: String
    
    init(
        id: UUID = UUID(),
        title: String,
        targetAmount: Double,
        currentAmount: Double = 0.0,
        icon: String = "star.fill",
        isCompleted: Bool = false,
        createdAt: Date = .now,
        userEmail: String
    ) {
        self.id = id
        self.title = title
        self.targetAmount = targetAmount
        self.currentAmount = currentAmount
        self.icon = icon
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.userEmail = userEmail
    }
    
    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min(currentAmount / targetAmount, 1.0)
    }
}
