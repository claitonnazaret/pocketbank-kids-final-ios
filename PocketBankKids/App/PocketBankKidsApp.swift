//
//  PocketBankKidsApp.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 25/11/26.
//
import SwiftUI
import SwiftData

@main struct PocketBankKidsApp: App {
    let container: ModelContainer
    @State private var router = AppRouter()
    @State private var authViewModel: AuthViewModel
    
    init() {
        do {
            let schema = Schema([
                UserAccount.self,
                SavingsGoal.self,
                TransactionRecord.self,
            ])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: [config])
            
            let repository = PocketBankRepository(context: container.mainContext)
            _authViewModel = State(initialValue: AuthViewModel(repository: repository))
        } catch {
            fatalError("Falha ao inicializar SwiftData: \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if let currentUser = authViewModel.currentUser {
                    let repository = PocketBankRepository(context: container.mainContext)
                    DashboardView(
                        viewModel: DashboardViewModel(
                            user: currentUser,
                            repository: repository
                        ),
                        authViewModel: authViewModel
                    )
                } else {
                    AuthView(viewModel: authViewModel)
                }
            }
            .environment(router)
        }
        .modelContainer(container)
    }
}
