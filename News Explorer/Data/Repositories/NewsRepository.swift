//
//  NewsRepository.swift
//  News Explorer
//
//  Created by Mahir Shahriar Lipeng on 28/12/25.
//

import Foundation
import RxSwift

protocol NewsRepository {
    func fetchArticles() -> Observable<[NewsArticle]>
}
