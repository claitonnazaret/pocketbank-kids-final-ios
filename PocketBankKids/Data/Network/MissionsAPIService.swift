//
//  MissionsAPIService.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 25/11/26.
//
import Foundation

protocol MissionsAPIServiceProtocol {
    func fetchMissions(limit: Int, skip: Int) async throws -> DummyProductsResponse
}

final class MissionsAPIService: MissionsAPIServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchMissions(limit: Int = 5, skip: Int) async throws -> DummyProductsResponse {
        var components = URLComponents(string: "https://dummyjson.com/products")
        components?.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "skip", value: "\(skip)"),
            URLQueryItem(name: "select", value: "id,title,description,price,stock")
        ]

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(DummyProductsResponse.self, from: data)
    }
}
