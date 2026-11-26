//
//  NetworkError.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 25/11/26.
//
import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodindError
    case noConnection
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Endereço de API inválido"
        case .requestFailed(let code):
            return "O Servidor respondeu com erro (Código \(code)"
        case .decodindError:
            return "Erro ao ler os dados das missões"
        case .noConnection:
            return "Sem conexão com a internet. Verifique sua rede"
        }
    }
}
