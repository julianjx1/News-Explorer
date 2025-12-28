//
//  NetworkError.swift
//  News Explorer
//
//  Created by Mahir Shahriar Lipeng on 28/12/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case network(Error)
    case decoding(Error)
    case serverError(statusCode: Int, message: String?) 
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .network(let error):
            return "Network connection failed: \(error.localizedDescription)"
        case .decoding(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .serverError(let code, let message):
            return "Server responded with error code \(code). Details: \(message ?? "No details provided")."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
