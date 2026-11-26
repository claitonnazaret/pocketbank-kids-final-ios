//
//  MissionsView.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 26/11/26.
//
import SwiftUI

struct MissionsView: View {
    @State var viewModel: MissionsViewModel
    let onMissionCompleted: () -> Void
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView("Buscando missões na API...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .error(let message):
                ContentUnavailableView {
                    Label("Ops! Algo deu errado", systemImage: "wifi.exclamationmark")
                } description: {
                    Text(message)
                } actions: {
                    Button("Tentar Novamente") {
                        Task { await viewModel.loadMissions() }
                    }
                    .buttonStyle(.borderedProminent)
                }
            case .success:
                if viewModel.missions.isEmpty {
                    ContentUnavailableView("Nenhuma missão disponível", systemImage: "star.slash")
                } else {
                    List(viewModel.missions) { mission in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(mission.title)
                                    .font(.headline)
                                Spacer()
                                Text("+\(mission.xpReward) XP")
                                    .font(.caption.bold())
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.orange.opacity(0.2))
                                    .foregroundStyle(.orange)
                                    .clipShape(Capsule())
                            }
                            
                            Text(mission.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            HStack {
                                Text("Recompensa: \(mission.rewardAmount.formatted(.currency(code: "BRL")))")
                                    .font(.caption.bold())
                                    .foregroundStyle(.green)
                                
                                Spacer()
                                
                                if mission.isCompleted {
                                    Label("Resgatada", systemImage: "checkmark.circle.fill")
                                        .font(.caption.bold())
                                        .foregroundStyle(.green)
                                } else {
                                    Button("Completar") {
                                        viewModel.completeMission(mission)
                                        onMissionCompleted()
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(.blue)
                                    .controlSize(.small)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Missões Diárias (API)")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadMissions()
        }
    }
}
