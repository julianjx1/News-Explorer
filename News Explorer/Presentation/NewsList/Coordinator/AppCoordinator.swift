//
//  Untitled.swift
//  News Explorer
//
//  Created by Mahir Shahriar Lipeng on 28/12/25.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var children: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let newsListCoordinator = NewsListCoordinator(navigationController: navigationController)
        addChild(newsListCoordinator)
        newsListCoordinator.start()
    }
}
