//
//  AuthViewModels.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 26/11/26.
//
import Foundation
import Observation

@MainActor
@Observable
final class AuthViewModel {
    var isRegisterMode = false
    var name = ""
    var email = ""
    var password = ""
    var errorMessage: String?
    var isLoading = false
    var currentUser: UserAccount?
    
    private let repository: PocketBankRepositoryProtocol
    private let sessionKey = "pocketbank_logged_email"
    
    init(repository: PocketBankRepositoryProtocol) {
        self.repository = repository
        restoreSession()
    }
    
    private func restoreSession() {
        if let savedEmail = UserDefaults.standard.string(forKey: sessionKey),
           let user = repository.fetchUser(email: savedEmail) {
            self.currentUser = user
        }
    }
    
    func submit() {
        guard !isLoading else { return }
        errorMessage = nil
        
        let cleanEmail = email.trimmingCharacters(in: .whitespaces).lowercased()
        
        guard !cleanEmail.isEmpty, cleanEmail.contains("@") else {
            errorMessage = "Digite um e-mail válido."
            return
        }
        
        guard password.count >= 4 else {
            errorMessage = "A senha deve ter pelo menos 4 caracteres."
            return
        }
        
        if isRegisterMode {
            guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
                errorMessage = "Digite o nome da criança."
                return
            }
            
            if repository.fetchUser(email: cleanEmail) != nil {
                errorMessage = "Este email já está cadastrado."
                return
            }
        }
        
        isLoading = true
        
        Task { @MainActor in
            defer { isLoading = false }
            try? await Task.sleep(for: .milliseconds(350))
            
            if isRegisterMode {
                do {
                    let created = try repository.createUser(
                        name: name.trimmingCharacters(in: .whitespaces),
                        email: cleanEmail,
                        password: password
                    )
                    UserDefaults.standard.set(created.email, forKey: sessionKey)
                    isLoading = false
                    currentUser = created
                } catch {
                    isLoading = false
                    errorMessage = "Erro ao criar conta: \(error.localizedDescription)"
                }
                
            } else {
                guard let user = repository.fetchUser(email: cleanEmail) else {
                    isLoading = false
                    errorMessage = "Conta não encontrada. Cadastre-se primeiro!"
                    return
                }
                guard user.passwordHash == password else {
                    isLoading = false
                    errorMessage = "Senha incorreta."
                    return
                }
                
                UserDefaults.standard.set(user.email, forKey: sessionKey)
                isLoading = false
                currentUser = user
            }
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: sessionKey)
        currentUser = nil
        password = ""
    }
}
