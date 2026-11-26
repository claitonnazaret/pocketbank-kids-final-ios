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
            do {
                let created = try repository.createUser(name: name, email: cleanEmail, password: password)
                UserDefaults.standard.set(created.email, forKey: sessionKey)
                currentUser = created
            } catch {
                errorMessage = "Erro ao criar conta: \(error.localizedDescription)"
            }
        } else {
            guard let user = repository.fetchUser(email: cleanEmail) else {
                errorMessage = "Conta não encontrada. Cadastre-se primeiro!"
                return
            }
            guard user.passwordHash == password else {
                errorMessage = "Senha incorreta."
                return
            }
            UserDefaults.standard.set(user.email, forKey: sessionKey)
            currentUser = user
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: sessionKey)
        currentUser = nil
        password = ""
    }
}
