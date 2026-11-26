//
//  DashboardView.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 26/11/26.
//
import SwiftUI

struct DashboardView: View {
    @State var viewModel: DashboardViewModel
    let authViewModel: AuthViewModel
    @Environment(AppRouter.self) private var router
    
    init(viewModel: DashboardViewModel, authViewModel: AuthViewModel) {
        self.viewModel = viewModel
        self.authViewModel = authViewModel
    }
    
    var body: some View {
        @Bindable var bindableRouter = router
        
        NavigationStack(path: $bindableRouter.path) {
            ScrollView {
                VStack(spacing: 18) {
                    if let banner = viewModel.feedbackBanner {
                        Text(banner)
                            .font(.footnote.bold())
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.green.opacity(0.2))
                            .foregroundStyle(.green)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Olá, \(viewModel.user.name)!")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.9))
                        Text(viewModel.user.balance, format: .currency(code: "BRL"))
                            .font(.system(size: 36, weight: .heavy))
                            .foregroundStyle(.white)
                        Text("Saldo total no Cofrinho")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        LinearGradient(colors: [.orange, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                     )
                     .clipShape(RoundedRectangle(cornerRadius: 18))
                    
                    AvatarEvolutionCard(user: viewModel.user)
                    
                    HStack(spacing: 12) {
                        Button {
                            router.isPresentingAddModal = true
                        } label: {
                            Label("Guardar", systemImage: "plus.circle.fill")
                                .font(.subheadline.bold())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.green)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        Button {
                            router.navigate(to: .missions)
                        } label: {
                            Label("Missões", systemImage: "star.circle.fill")
                                .font(.subheadline.bold())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.blue)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    
                    HStack(spacing: 12) {
                        Button {
                            router.navigate(to: .history)
                        } label: {
                            Label("Extrato", systemImage: "list.bullet.rectangle")
                                .font(.subheadline.bold())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color(.secondarySystemGroupedBackground))
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        Button {
                            router.navigate(to: .familyRanking)
                        } label: {
                            Label("Ranking", systemImage: "trophy.fill")
                                .font(.subheadline.bold())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color(.secondarySystemGroupedBackground))
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Minhas Metas 🎯")
                            .font(.title3.bold())
                        
                        if viewModel.goals.isEmpty {
                            ContentUnavailableView(
                                "Nenhuma meta ainda",
                                systemImage: "target",
                                description: Text("Toque em 'Guardar' para criar seu primeiro objetivo!")
                            )
                        } else {
                            ForEach(viewModel.goals) { goal in
                                Button {
                                    router.navigate(to: .goalDetail(goal))
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: goal.icon)
                                            .font(.title2)
                                            .foregroundStyle(.orange)
                                            .frame(width: 40, height: 40)
                                            .background(Color.orange.opacity(0.15))
                                            .clipShape(Circle())
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack {
                                                Text(goal.title)
                                                    .font(.headline)
                                                    .foregroundStyle(.primary)
                                                if goal.isCompleted {
                                                    Text("✅ Concluída")
                                                        .font(.caption.bold())
                                                        .foregroundStyle(.green)
                                                }
                                            }
                                            
                                            ProgressView(value: goal.progress)
                                                .tint(goal.isCompleted ? .green : .orange)
                                            
                                            Text("\(goal.currentAmount.formatted(.currency(code: "BRL"))) de \(goal.targetAmount.formatted(.currency(code: "BRL")))")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding()
                                    .background(Color(.secondarySystemGroupedBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("PocketBank Kids")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sair", role: .destructive) {
                        authViewModel.logout()
                    }
                }
            }
            .sheet(isPresented: $bindableRouter.isPresentingAddModal) {
                AddGoalOrDepositView(dashboardViewModel: viewModel)
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .history:
                    HistoryView(viewModel: viewModel)
                case .missions:
                    MissionsView(
                        viewModel: MissionsViewModel(
                            user: viewModel.user,
                            repository: viewModel.repository
                        ),
                        onMissionCompleted: { viewModel.refreshData() }
                    )
                case .familyRanking:
                    FamilyRankingView(currentUser: viewModel.user)
                case .goalDetail(let goal):
                    GoalDetailView(goal: goal, dashboardViewModel: viewModel)
                }
            }
            .onAppear {
                viewModel.refreshData()
            }
        }
        
    }
}
