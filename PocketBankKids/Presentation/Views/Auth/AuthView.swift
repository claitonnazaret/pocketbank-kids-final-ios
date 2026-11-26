//
//  AuthView.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 26/11/26.
//
import SwiftUI

struct AuthView: View {
    @Bindable var viewModel: AuthViewModel
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name, email, password
    }
    
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
                            .focused($focusedField, equals: .name)
                    }
                    
                    TextField("E-mail", text: $viewModel.email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($focusedField, equals: .email)
                        .disabled(viewModel.isLoading)
                    
                    SecureField("Senha (mín. 4 dígitos)", text: $viewModel.password)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .password)
                        .disabled(viewModel.isLoading)
                    
                }
                .padding(.horizontal)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Button{
                    focusedField = nil
                    viewModel.submit()
                } label: {
                    HStack(spacing: 10) {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                            Text("Preparando seu cofrinho...")
                        } else {
                            Text(viewModel.isRegisterMode ? "Começar Aventura 🚀" : "Entrar no Cofre 🔑")
                        }
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isLoading ? .orange.opacity(0.7) : .orange)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(viewModel.isLoading)
                .padding(.horizontal)
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}
