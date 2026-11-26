//
//  DashboardViewModel.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 26/11/26.
//
import Foundation
import Observation

@MainActor
@Observable
final class DashboardViewModel {
    var user: UserAccount
    var goals: [SavingsGoal] = []
    var transactions: [TransactionRecord] = []
    var selectedFilter: TransactionCategory? = nil
    var feedbackBanner: String?
    
    let repository: PocketBankRepositoryProtocol
    
    init(user: UserAccount, repository: PocketBankRepositoryProtocol) {
        self.user = user
        self.repository = repository
        refreshData()
    }
    
    func refreshData() {
        goals = repository.fetchGoals(for: user.email)
        transactions = repository.fetchTransactions(for: user.email)
    }
    
    var filteredTransactions: [TransactionRecord] {
        guard let filter = selectedFilter else { return transactions }
        return transactions.filter { $0.category == filter }
    }
    
    func createGoal(title: String, targetAmount: Double, icon: String) {
        let newGoal = SavingsGoal(
            title: title,
            targetAmount: targetAmount,
            icon: icon,
            userEmail: user.email
        )
        try? repository.addGoal(newGoal)
        refreshData()
        showBanner("Nova meta '\(title)' criada! 🎯")
    }
    
    func makeQuickDeposit(title: String, amount: Double) {
        try? repository.addGeneralDeposit(user: user, title: title, amount: amount)
        refreshData()
        showBanner("+\(amount.formatted(.currency(code: "BRL"))) guardados no cofrinho! 🐷")
    }
    
    func contributeToGoal(_ goal: SavingsGoal, amount: Double) {
        try? repository.depositToGoal(user: user, goal: goal, amount: amount)
        refreshData()
        if goal.isCompleted {
            showBanner("Parabéns! Você conquistou '\(goal.title)' (+100 XP) 🏆")
        } else {
            showBanner("Aporte realizado em '\(goal.title)'! 🚀")
        }
    }
    
    func showBanner(_ text: String) {
        feedbackBanner = text
        Task {
            try? await Task.sleep(for: .seconds(3))
            if feedbackBanner == text {
                feedbackBanner = nil
            }
        }
    }
}

