//
//  MissionsViewModel.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 26/11/26.
//

import Foundation
import Observation

enum ViewLoadingState {
    case idle
    case loading
    case success
    case error(String)
}

@MainActor
@Observable
final class MissionsViewModel {
    var missions: [MissionItem] = []
    var state: ViewLoadingState = .idle
    
    private let apiService: MissionsAPIServiceProtocol
    private let repository: PocketBankRepositoryProtocol
    private let user: UserAccount
    
    init(
        user: UserAccount,
        repository: PocketBankRepositoryProtocol,
        apiService: MissionsAPIServiceProtocol? = nil
    ) {
        self.user = user
        self.repository = repository
        
        if let apiService {
            self.apiService = apiService
        } else {
            let config = URLSessionConfiguration.ephemeral
            config.protocolClasses = [MockMissionsUrlProtocol.self]
            let mockSession = URLSession(configuration: config)
            self.apiService = MissionsAPIService(session: mockSession)
        }
    }

    
    func loadMissions() async {
        state = .loading
        do {
            let fetched = try await apiService.fetchMissions()
            self.missions = fetched.map { item in
                var copy = item
                copy.isCompleted = user.completedMissionIds.contains(item.id)
                return copy
            }
            state = .success
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func completeMission(_ mission: MissionItem) {
        do {
            try repository.completeMission(user: user, mission: mission)
            if let index = missions.firstIndex(where: { $0.id == mission.id }) {
                missions[index].isCompleted = true
            }
        } catch {
            state = .error("Não foi possível salvar a recompensa.")
        }
    }
}
