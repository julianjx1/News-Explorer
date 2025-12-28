//
//  NewsListViewModel.swift
//  News Explorer
//
//  Created by Mahir Shahriar Lipeng on 28/12/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol NewsListViewModelInputs {
    func viewDidLoad()
}

protocol NewsListViewModelOutputs {
    var articles: Driver<[NewsArticle]> { get }
    var error: Driver<NetworkError> { get }
    var isLoading: Driver<Bool> { get }
}

protocol NewsListViewModelType {
    var inputs: NewsListViewModelInputs { get }
    var outputs: NewsListViewModelOutputs { get }
}

final class NewsListViewModel: NewsListViewModelType, NewsListViewModelInputs, NewsListViewModelOutputs {
    
    var inputs: NewsListViewModelInputs { return self }
    var outputs: NewsListViewModelOutputs { return self }
    
    private let disposeBag = DisposeBag()
    private let repository: NewsRepository
    
    private let articlesRelay = BehaviorRelay<[NewsArticle]>(value: [])
    private let errorRelay = PublishRelay<NetworkError>()
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    var articles: Driver<[NewsArticle]> {
        return articlesRelay.asDriver()
    }
    
    var error: Driver<NetworkError> {
        return errorRelay.asDriver(onErrorDriveWith: .empty())
    }
    
    var isLoading: Driver<Bool> {
        return isLoadingRelay.asDriver()
    }
    
    
    init(repository: NewsRepository) {
        self.repository = repository
    }
    
    
    func viewDidLoad() {
        fetchArticles()
    }
    
    private func fetchArticles() {
        isLoadingRelay.accept(true)
        
        repository.fetchArticles()
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .do(onDispose: { [weak self] in
                self?.isLoadingRelay.accept(false)
            })
            .subscribe(
                onNext: { [weak self] articles in
                    self?.articlesRelay.accept(articles)
                },
                onError: { [weak self] error in
                    if let networkError = error as? NetworkError {
                        self?.errorRelay.accept(networkError)
                    } else {
                        self?.errorRelay.accept(.unknown)
                    }
                }
            )
            .disposed(by: disposeBag)
    }
}
