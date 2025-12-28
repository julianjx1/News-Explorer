//
//  NewsListCoordinator.swift
//  News Explorer
//
//  Created by Mahir Shahriar Lipeng on 28/12/25.
//

import UIKit

final class NewsListCoordinator: Coordinator {
    var navigationController: UINavigationController
    var children: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let repository: NewsRepository = DefaultNewsRepository()
        
        let viewModel: NewsListViewModelType = NewsListViewModel(repository: repository)
        let viewController = NewsListViewController(viewModel: viewModel)
        
        viewController.title = "News Explorer"
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
