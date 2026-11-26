//
//  HistoryView.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 26/11/26.
//
import SwiftUI

struct HistoryView: View {
    @Bindable var viewModel: DashboardViewModel
    
    var body: some View {
        VStack {
            Picker("Categoria", selection: $viewModel.selectedFilter) {
                Text("Todos").tag(TransactionCategory?.none)
                ForEach(TransactionCategory.allCases, id: \.self) { category in
                    Text(category.rawValue).tag(TransactionCategory?.some(category))
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            if  viewModel.filteredTransactions.isEmpty {
                ContentUnavailableView(
                    "Nenhum registro encontrado",
                    systemImage: "tray",
                    description: Text("Complete missões ou deposite no cofrinho para ver seu extrato")
                )
            } else {
                List(viewModel.filteredTransactions) { tx in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(tx.title)
                                .font(.headline)
                            Text(tx.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("+\(tx.amount.formatted(.currency(code: "BRL")))")
                                .font(.subheadline.bold())
                                .foregroundStyle(.green)
                            Text("+\(tx.xpEarned) XP")
                                .font(.caption.bold())
                                .foregroundStyle(.orange)
                        }
                    }
                }
            }
        }
        .navigationTitle("Extrado do Cofrinho")
        .navigationBarTitleDisplayMode(.inline)
    }
}
