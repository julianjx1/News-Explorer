
//
//  APIResponse.swift
//  News Explorer
//
//  Created by Mahir Shahriar Lipeng on 28/12/25.
//

import Foundation

struct APIResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [NewsArticle]
}
