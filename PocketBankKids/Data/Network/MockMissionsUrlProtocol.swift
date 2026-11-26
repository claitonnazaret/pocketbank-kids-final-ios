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
