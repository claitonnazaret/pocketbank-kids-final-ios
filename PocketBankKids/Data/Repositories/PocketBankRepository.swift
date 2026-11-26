//
//  PocketBankRepository.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 25/11/26.
//

import Foundation
import SwiftData

@MainActor
protocol PocketBankRepositoryProtocol {
    func fetchUser(email: String) -> UserAccount?
    func createUser(name: String, email: String, password: String) throws -> UserAccount
    func fetchGoals(for email: String) -> [SavingsGoal]
    func addGoal(_ goal: SavingsGoal) throws
    func depositToGoal(user: UserAccount, goal: SavingsGoal, amount: Double) throws
    func addGeneralDeposit(user: UserAccount, title: String, amount: Double) throws
    func completeMission(user: UserAccount, mission: MissionItem) throws
    func fetchTransactions(for email: String) -> [TransactionRecord]
}

@MainActor
final class PocketBankRepository: PocketBankRepositoryProtocol {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchUser(email: String) -> UserAccount? {
        let normalized = email.lowercased().trimmingCharacters(in: .whitespaces)
        let descriptor = FetchDescriptor<UserAccount>(
            predicate: #Predicate<UserAccount> { user in
                user.email == normalized
            }
        )
        return try? context.fetch(descriptor).first
    }
    
    func createUser(name: String, email: String, password: String) throws -> UserAccount {
        let normalized = email.lowercased().trimmingCharacters(in: .whitespaces)
        let newUser = UserAccount(
            name: name,
            email: normalized,
            passwordHash: password,
            balance: 25.0,
            xp: 50
        )
        context.insert(newUser)
        
        let welcomeTx = TransactionRecord(
            title: "Bônus de Boas-Vindas 🎉",
            amount: 25.0,
            xpEarned: 50,
            category: .deposit,
            userEmail: normalized
        )
        context.insert(welcomeTx)
        
        let starterGoal = SavingsGoal(
            title: "Meu Primeiro Jogo",
            targetAmount: 100.0,
            currentAmount: 25.0,
            icon: "gamecontroller.fill",
            userEmail: normalized
        )
        context.insert(starterGoal)
        
        try context.save()
        return newUser
    }
    
    func fetchGoals(for email: String) -> [SavingsGoal] {
            let descriptor = FetchDescriptor<SavingsGoal>(
                predicate: #Predicate { $0.userEmail == email },
                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
            )
        return (try? context.fetch(descriptor)) ?? []
    }
    
    func addGoal(_ goal: SavingsGoal) throws {
        context.insert(goal)
        try context.save()
    }
    
    func depositToGoal(user: UserAccount, goal: SavingsGoal, amount: Double) throws {
        user.balance += amount
        goal.currentAmount += amount
        
        var earnedXP = Int(amount * 2)
        var category: TransactionCategory = .deposit
        
        if goal.currentAmount >= goal.targetAmount && !goal.isCompleted {
            goal.isCompleted = true
            earnedXP += 100
            category = .goalReward
        }
        
        user.xp += earnedXP
        
        let tx = TransactionRecord(
            title: "Cofrinho: \(goal.title)",
            amount: amount,
            xpEarned: earnedXP,
            category: category,
            userEmail: user.email
        )
        context.insert(tx)
        try context.save()
    }
    
    func addGeneralDeposit(user: UserAccount, title: String, amount: Double) throws {
        let earnedXP = max(10, Int(amount * 2))
        user.balance += amount
        user.xp += earnedXP
        
        let tx = TransactionRecord(
            title: title,
            amount: amount,
            xpEarned: earnedXP,
            category: .deposit,
            userEmail: user.email
        )
        context.insert(tx)
        try context.save()
    }
    
    func completeMission(user: UserAccount, mission: MissionItem) throws {
        guard !user.completedMissionIds.contains(mission.id) else { return }
        
        user.completedMissionIds.append(mission.id)
        user.balance += mission.rewardAmount
        user.xp += mission.xpReward
        
        let tx = TransactionRecord(
            title: "Missão: \(mission.title)",
            amount: mission.rewardAmount,
            xpEarned: mission.xpReward,
            category: .mission,
            userEmail: user.email
        )
        context.insert(tx)
        try context.save()
    }
    
    func fetchTransactions(for email: String) -> [TransactionRecord] {
        let descriptor = FetchDescriptor<TransactionRecord>(
            predicate: #Predicate { $0.userEmail == email },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }
}
