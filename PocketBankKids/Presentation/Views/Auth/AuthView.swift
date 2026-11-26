//
//  AuthView.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 26/11/26.
//
import SwiftUI

struct AuthView: View {
    @Bindable var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                VStack(spacing: 8) {
                    Text("🐷✨")
                        .font(.system(size: 64))
                    Text("PocketBank Kids")
                        .font(.largeTitle.bold())
                    Text("Poupe moedas, evolua seu guardião!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Picker("Modo", selection: $viewModel.isRegisterMode) {
                    Text("Entrar").tag(false)
                    Text("Criar Conta").tag(true)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                VStack(spacing: 14) {
                    if viewModel.isRegisterMode {
                        TextField("Nome da Criança", text: $viewModel.name)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.name)
                    }
                    
                    TextField("E-mail", text: $viewModel.email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    
                    PasswordField("Senha (mín. 4 dígitos)", text: $viewModel.password)
                    
                }
                .padding(.horizontal)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Button(action: viewModel.submit) {
                    Text(viewModel.isRegisterMode ? "Começar Aventura 🚀" : "Entrar no Cofre 🔑")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.orange)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}
