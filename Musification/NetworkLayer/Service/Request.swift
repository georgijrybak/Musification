//  NetworkService.swift
//  Musification_1
//
//  Created by user on 4.10.21.
//

import Foundation

protocol RequestProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void)
}

final class Request: RequestProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        guard let endpoint = endpoint.buildURLRequest() else {
            return completion(.failure(ErrorResponse.invalidURLRequest))
        }

        URLSession.shared.dataTask(with: endpoint) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }

            guard let response = response as? HTTPURLResponse else { return }

            switch response.statusCode {
            case (400...499):
                let error = NSError(
                    domain: ErrorResponse.invalidEndpoint.rawValue,
                    code: 404,
                    userInfo: nil
                )
                 completion(.failure(error))
            case (500...599):
                let error = NSError(
                    domain: ErrorResponse.serverError.rawValue,
                    code: 500,
                    userInfo: nil
                )
                 completion(.failure(error))
            case (200...299):
                guard let data = data else {
                    return completion(.failure(NSError()))
                }
                do {
                    let obj = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(obj))
                } catch {
                    completion(.failure(error))
                }
            default:
                completion(.failure(NSError()))
            }
        }
        .resume()
    }
}
