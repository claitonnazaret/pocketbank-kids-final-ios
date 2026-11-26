//
//  MockMissionsUrlProtocol.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 26/11/26.
//

import Foundation

final class MockMissionsUrlProtocol: URLProtocol {
    static var shouldSimulateError = false
    
    override class func canInit(with request: URLRequest) -> Bool {
        return request.url?.host == "api.pocketbankkids.mock"
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let url = request.url else { return }
        
        if Self.shouldSimulateError {
            let error = NSError(
                domain: NSURLErrorDomain,
                code: NSURLErrorNotConnectedToInternet,
                userInfo: [NSLocalizedDescriptionKey: "Falha simulada na API de missões."]
            )
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        let mockJSON = """
        [
          {
            "id": 1,
            "title": "Guardar Troco do Lanche",
            "description": "Economize R$ 5,00 do lanche escolar hoje.",
            "rewardAmount": 5.0,
            "xpReward": 40,
            "isCompleted": false
          },
          {
            "id": 2,
            "title": "Desafio Sem Doces",
            "description": "Passe 2 dias sem comprar balas e guarde o valor.",
            "rewardAmount": 10.0,
            "xpReward": 60,
            "isCompleted": false
          },
          {
            "id": 3,
            "title": "Ajudante da Casa",
            "description": "Organize seu quarto e ganhe sua mesada bônus.",
            "rewardAmount": 15.0,
            "xpReward": 80,
            "isCompleted": false
          },
          {
            "id": 4,
            "title": "Comparador de Preços",
            "description": "Pesquise 2 preços antes de pedir um brinquedo.",
            "rewardAmount": 8.0,
            "xpReward": 50,
            "isCompleted": false
          },
          {
            "id": 5,
            "title": "Cofrinho Turbinado",
            "description": "Faça qualquer depósito acima de R$ 20,00.",
            "rewardAmount": 20.0,
            "xpReward": 100,
            "isCompleted": false
          },
          {
            "id": 6,
            "title": "Mestre da Leitura",
            "description": "Leia um capítulo sobre finanças com seus pais.",
            "rewardAmount": 12.0,
            "xpReward": 70,
            "isCompleted": false
          }
        ]
        """
        
        let data = Data(mockJSON.utf8)
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: "HTTP/1.1",
            headerFields: ["Content-Type": "application/json"]
        )!
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.6) {
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {}
}
