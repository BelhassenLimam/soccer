//
//  Networking.swift
//  testFDJ_LIMAM
//
//  Created by Belhassen LIMAM on 31/12/2023.
//

import Foundation

func fetchData<T: Decodable>(from url: URL, onSuccess: @escaping (T) -> Void, onError: @escaping (Error) -> Void) async {
    guard let token = await getTokens() else {
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(token.idToken)", forHTTPHeaderField: "authorization")

    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let httpResponse = response as? HTTPURLResponse else {
            onError(NetworkError.invalidResponse)
            return
        }

        let statusCode = httpResponse.statusCode

        if statusCode == 200 {
            if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                do {
                    let response = try decoder.decode(T.self, from: data)
                    onSuccess(response)
                } catch {
                    onError(error)
                }
            } else {
                onError(NetworkError.invalidResponse)
            }
        } else {
            print("Error: \(statusCode)")
            
        }

    }.resume()
}
