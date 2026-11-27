//
//  Mission.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 25/11/26.
//

import Foundation

struct DummyProductsResponse: Codable {
    let products: [MissionItem]
    let total: Int
}

struct MissionItem: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let description: String
    let rewardAmount: Double
    let xpReward: Int
    var isCompleted: Bool = false

    // Mapeia os nomes das chaves do JSON para as propriedades da struct
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case rewardAmount = "price"
        case xpReward = "stock"
        case isCompleted
    }

    // Inicializador padrão para criar instâncias manualmente no código/previews
    init(
        id: Int,
        title: String,
        description: String,
        rewardAmount: Double,
        xpReward: Int,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.rewardAmount = rewardAmount
        self.xpReward = xpReward
        self.isCompleted = isCompleted
    }

    // Inicializador para decodificar o JSON da API (definindo isCompleted como false por padrão)
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        rewardAmount = try container.decode(Double.self, forKey: .rewardAmount)
        xpReward = try container.decode(Int.self, forKey: .xpReward)
        isCompleted = try container.decodeIfPresent(Bool.self, forKey: .isCompleted) ?? false
    }
}
