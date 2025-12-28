//
//  EndPoints.swift
//  News Explorer
//
//  Created by Mahir Shahriar Lipeng on 28/12/25.
//
import Foundation

enum NewsAPI {
    case everything
}

extension NewsAPI {
    private var baseURL: String {
        return "https://newsapi.org"
    }
    
    private var path: String {
        switch self {
        case .everything:
            return "/v2/everything"
        }
    }
    
    private var apiKey: String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String,
                      !apiKey.isEmpty else {
                    return "DEFAULT_OR_FATAL_ERROR_KEY"
                }
                return apiKey
//        return "ce31c9c12bf84a2686dea010ab4410cf"
    }
    
    private var queryItems: [URLQueryItem] {
        return [
            URLQueryItem(name: "q", value: "apple"),
            URLQueryItem(name: "from", value: "2025-12-27"),
            URLQueryItem(name: "sortBy", value: "publishedAt"),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
    }
    
    var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.path = path 
        components?.queryItems = queryItems
        return components?.url
    }
}
