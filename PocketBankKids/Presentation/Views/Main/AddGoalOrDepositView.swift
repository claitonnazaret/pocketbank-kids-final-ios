//
//  AddGoalOrDepositView.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 26/11/26.
//
import SwiftUI



struct AddGoalOrDepositView: View {
    @Environment(\.dismiss) private var dismiss
    let dashboardViewModel: DashboardViewModel
    
    @State private var mode = 0 // 0 = Depósito rápido, 1 - Nova meta
    @State private var title = ""
    @State private var amountText = ""
    @State private var selectedIcon = "bicycle"
    
    let icons: [(title: String, image: String)] = [
        (title: "Bicicleta", image: "bicycle"),
        (title: "Video Game", image: "gamecontroller.fill"),
        (title: "Brinquedo", image: "airplane"),
        (title: "Livro", image: "book.fill"),
        (title: "Presente", image: "gift.fill")
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Tipo de Ação", selection: $mode) {
                    Text("Guardar Moedas 💰").tag(0)
                    Text("Nova Meta 🎯").tag(1)
                }
                .pickerStyle(.segmented)
                
                Section("Detalhes \(mode == 0 ? "do Depósito" : "da Meta")") {
                    TextField(
                        mode == 0 ? "Origem (ex. Mesada, Troco)" : "Nome da Meta (ex. Bicicleta)",
                        text: $title
                    )
                    
                    TextField("Valor em R$ (ex: 20.00)", text: $amountText)
                        .keyboardType(.decimalPad)
                    
                    if mode == 1 {
                        Picker("Ícone", selection: $selectedIcon) {
                            ForEach(icons, id: \.image) { icon in
                                Label(icon.title, systemImage: icon.image).tag(icon.image)
                            }
                        }
                    }
                }
                
                Section {
                    Button(mode == 0 ? "Confirmar Depósito (+XP)" : "Criar Meta") {
                        let normalized = amountText.replacingOccurrences(of: ",", with: ".")
                        guard let value = Double(normalized), value > 0 else { return }
                        let finalTitle = title.isEmpty ? (mode == 0 ? "Depósito no Cofrinho" : "Minha Meta") : title
                        
                        if mode == 0 {
                            dashboardViewModel.makeQuickDeposit(title: finalTitle, amount: value)
                        } else {
                            dashboardViewModel.createGoal(title: finalTitle, targetAmount: value, icon: selectedIcon)
                        }
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .foregroundStyle(.orange)
                }
            }
            .navigationTitle(mode == 0 ? "Guardar Moedas" : "Criar Meta")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
    }
}
