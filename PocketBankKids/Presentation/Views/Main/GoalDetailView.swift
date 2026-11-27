//
//  GoalDetailView.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 26/11/26.
//
import SwiftUI

struct GoalDetailView: View {
    let goal: SavingsGoal
    let dashboardViewModel: DashboardViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var depositAmount = "10"
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: goal.icon)
                .font(.system(size: 60))
                .foregroundStyle(.orange)
                .padding(24)
                .background(Color.orange.opacity(0.15))
                .clipShape(Circle())
            
            Text(goal.title)
                .font(.title.bold())
            
            VStack(spacing: 8) {
                ProgressView(value: goal.progress)
                    .tint(goal.isCompleted ? .green : .orange)
                    .scaleEffect(x: 1, y: 2.5)
                    .padding(.horizontal)
                Text("\(Int(goal.progress * 100))% concluído")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Text("\(goal.currentAmount.formatted(.currency(code: "BRL"))) de \(goal.targetAmount.formatted(.currency(code: "BRL")))")
                    .font(.subheadline)
            }
            
            if !goal.isCompleted {
                VStack(spacing: 12) {
                        Text("Adicionar moedas nesta meta:")
                        .font(.subheadline.bold())
                    
                    HStack(spacing: 4) {
                        ForEach(["25", "50", "100"], id: \.self) { preset in
                            Button("R$ \(preset)") {
                                depositAmount = preset
                            }
                            .buttonStyle(.bordered)
                            .tint(depositAmount == preset ? .orange : .gray)
                        }
                    }
                    
                    Button {
                        if let val = Double(depositAmount), val > 0 {
                            dashboardViewModel.contributeToGoal(goal, amount: val)
                            dismiss()
                        }
                    } label: {
                            Text("Confirmar Aporte de R$ \(depositAmount) 🚀")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                Label("Meta Conquistada! Parabéns", systemImage: "checkmark.seal.fill")
                    .font(.headline)
                    .foregroundStyle(.green)
                    .padding()
                    .background(Color.green.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Detalhe da Meta")
        .navigationBarTitleDisplayMode(.inline)
    }
}
