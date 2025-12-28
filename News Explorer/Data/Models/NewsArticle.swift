//
//  NewsArticle.swift
//  News Explorer
//
//  Created by Mahir Shahriar Lipeng on 28/12/25.
//

import Foundation

struct NewsArticle: Decodable {
    let source: Source?
    
    let author: String?
    
    let title: String
    
    let description: String?
    
    let url: String
    
    let urlToImage: String?
    
    let publishedAt: Date
    
    let content: String?
}

struct Source: Decodable {
    let id: String?
    let name: String
}
