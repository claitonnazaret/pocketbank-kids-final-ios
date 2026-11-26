import SwiftUI
import SwiftData

@main
struct PocketBankKidsApp: App {
    let container: ModelContainer
    let repository: PocketBankRepository
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
            let createdContainer = try ModelContainer(for: schema, configurations: [config])
            let createdRepository = PocketBankRepository(context: createdContainer.mainContext)
            
            self.container = createdContainer
            self.repository = createdRepository
            
            _authViewModel = State(initialValue: AuthViewModel(repository: createdRepository))
        } catch {
            fatalError("Falha ao inicializar SwiftData: \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if let currentUser = authViewModel.currentUser {
                    // Use uma View intermediária para segurar o @State do DashboardViewModel
                    AuthenticatedRootView(
                        user: currentUser,
                        repository: repository,
                        authViewModel: authViewModel
                    )
                    .id(currentUser.id)
                } else {
                    AuthView(viewModel: authViewModel)
                }
            }
            .animation(.easeInOut(duration: 0.25), value: authViewModel.currentUser != nil)
            .environment(router)
        }
        // Essencial para registrar o container na árvore do SwiftUI:
        .modelContainer(container)
    }
}

// View auxiliar para garantir que a DashboardViewModel seja criada apenas UMA vez por sessão
private struct AuthenticatedRootView: View {
    @State private var dashboardViewModel: DashboardViewModel
    let authViewModel: AuthViewModel
    
    init(user: UserAccount, repository: PocketBankRepository, authViewModel: AuthViewModel) {
        self._dashboardViewModel = State(
            initialValue: DashboardViewModel(user: user, repository: repository)
        )
        self.authViewModel = authViewModel
    }
    
    var body: some View {
        DashboardView(
            viewModel: dashboardViewModel,
            authViewModel: authViewModel
        )
    }
}
