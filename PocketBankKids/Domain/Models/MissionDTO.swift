//
//  Mission.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 25/11/26.
//

import Foundation

struct APIPostResponse: Codable {
    let id: Int
    let title: String
    let body: String
}

struct MissionItem: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let description: String
    let rewardAmount: Double
    let xpReward: Int
    var isCompleted: Bool = false
}
