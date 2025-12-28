//
//  DefaultNewsRepository.swift
//  News Explorer
//
//  Created by Mahir Shahriar Lipeng on 28/12/25.
//

import Foundation
import RxSwift

final class DefaultNewsRepository: NewsRepository {
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func fetchArticles() -> Observable<[NewsArticle]> {
        
        return apiClient.request(NewsAPI.everything)
            .map { (response: APIResponse) -> [NewsArticle] in
                return response.articles
            }
            .catch { error in
                print("Repository Error: \(error.localizedDescription)")
                throw error
            }
    }
}
