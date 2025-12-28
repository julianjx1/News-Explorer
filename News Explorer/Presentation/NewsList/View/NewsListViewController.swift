//
//  ViewController.swift
//  News Explorer
//
//  Created by Mahir Shahriar Lipeng on 28/12/25.
//

import UIKit
import RxSwift
import RxCocoa

private let reuseIdentifier = "NewsListCell"

final class NewsListViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: NewsListViewModelType
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 120
        tableView.register(NewsListCell.self, forCellReuseIdentifier: reuseIdentifier)
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(viewModel: NewsListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Use init(viewModel:)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        bindViewModel()
        
        viewModel.inputs.viewDidLoad()
    }
    
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    private func bindViewModel() {
        
        viewModel.outputs.articles
            .drive(tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: NewsListCell.self)) { (row, article, cell) in
                cell.configure(with: article)
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoading
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.outputs.error
            .drive(onNext: { [weak self] error in
                self?.presentErrorAlert(message: error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(NewsArticle.self)
            .subscribe(onNext: { [weak self] article in
                self?.tableView.deselectRow(at: self?.tableView.indexPathForSelectedRow ?? IndexPath(), animated: true)
                print("Selected article: \(article.title)")
            })
            .disposed(by: disposeBag)
    }
    
    private func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

