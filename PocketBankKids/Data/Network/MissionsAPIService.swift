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
        guard let url = URL(string: "https://api.pocketbankkids.mock") else {
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
            
            return try JSONDecoder().decode([MissionItem].self, from: data)
        } catch is DecodingError {
            throw NetworkError.decodindError
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.noConnection
        }
    }
}
