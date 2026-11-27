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
    
    private var currentSkip = 0
    private let limit = 5
    
    init(
        user: UserAccount,
        repository: PocketBankRepositoryProtocol,
        apiService: MissionsAPIServiceProtocol? = nil
    ) {
        self.user = user
        self.repository = repository
        self.apiService = apiService ?? MissionsAPIService(session: .shared)
    }
    
    func loadMissions() async {
        state = .loading
        do {
            let response = try await apiService.fetchMissions(limit: limit, skip: currentSkip)
            
            self.missions = response.products.map { item in
                var copy = item
                copy.isCompleted = user.completedMissionIds.contains(item.id)
                return copy
            }
            
            if currentSkip + limit < response.total {
                currentSkip += limit
            } else {
                currentSkip = 0
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
    
    var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }
}
