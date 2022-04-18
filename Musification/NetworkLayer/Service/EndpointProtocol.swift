//
//  NetworkProtocol.swift
//  Musification
//
//  Created by Георгий Рыбак on 8.02.22.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol Endpoint {
    var baseURL: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [String: String] { get }
}

extension Endpoint {
    var apiKey: String {
        return App.shared.apiKey
    }
    var baseURL: String {
        return App.shared.baseURL
    }

    func buildURLRequest() -> URLRequest? {
        let urlString = baseURL

        guard var urlComponent = URLComponents(string: urlString) else { return nil }

        var requestQueryItems: [URLQueryItem] = []

        queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlComponent.queryItems?.append(urlQueryItem)
            requestQueryItems.append(urlQueryItem)
        }

        urlComponent.queryItems = requestQueryItems
        guard let url = urlComponent.url else { return nil }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers ?? [:]

        return urlRequest
    }
}
