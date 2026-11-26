//
//  MissionsAPIService.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 25/11/26.
//
import Foundation

protocol MissionsAPIServiceProtocol {
    func fetchMissions() async throws -> [MissionItem]
}

final class MissionsAPIService: MissionsAPIServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchMissions() async throws -> [MissionItem] {
        guard let url = URL(string: "https://typicode.com") else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.noConnection
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.requestFailed(statusCode: httpResponse.statusCode)
            }
            
            let posts = try JSONDecoder().decode([APIPostResponse].self, from: data)
            
            let localizedTemplates: [(title: String, desc: String, money: Double, xp: Int)] = [
                ("Guardar Troco do Lanche", "Economize R$ 5,00 do lanche escolar hoje.", 5.0, 40),
                ("Desafio Sem Doces", "Passe 2 dias sem comprar balas e guarde o valor.", 10.0, 60),
                ("Ajudante da casa", "Organize seu quarto e ganhe sua mesada bônus.", 15.0, 80),
                ("Comparador de Preços", "Pesquise 2 preços antes de pedir um brinquedo.", 8.0, 50),
                ("Cofrinho Turbinado", "Faça qualquer depósito acima de R$ 20,00.", 20.0, 100),
                ("Mestre da Leitura", "Leia um capítulo sobre finanças com seus pais.", 12.0, 70)
            ]
            
            return posts.enumerated().map { index, post in
                let template = localizedTemplates[index % localizedTemplates.count]
                return MissionItem(
                    id: post.id,
                    title: template.title,
                    description: "\(template.desc) (Ref API #\(post.id))",
                    rewardAmount: template.money,
                    xpReward: template.xp
                )
            }
        } catch is DecodingError {
            throw NetworkError.decodindError
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.noConnection
        }
    }
}
