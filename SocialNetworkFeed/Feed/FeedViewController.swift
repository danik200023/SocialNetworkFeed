//
//  FeedViewController.swift
//  SocialNetworkFeed
//
//  Created by Danila Umnov on 05.03.2025.
//

import UIKit

final class FeedViewController: UIViewController {
    private let feedTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(FeedCell.self, forCellReuseIdentifier: "feedCell")
        
        return tableView
    }()
    
    var viewModel: FeedViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = FeedViewModel()
        feedTableView.dataSource = self
        feedTableView.delegate = self
        
        setupUI()
        loadData()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Лента"
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        feedTableView.refreshControl = refreshControl
        
        view.addSubview(feedTableView)
        
        NSLayoutConstraint.activate([
            feedTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            feedTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func loadData() {
        viewModel.getPostsFromCache { [unowned self] cachedPosts in
            if cachedPosts > 0 {
                feedTableView.reloadData()
            }
            viewModel.getPostsFromWeb { [unowned self] newPostsCount in
                if newPostsCount > 0 {
                    let indexPaths = (0..<newPostsCount).map { IndexPath(row: $0, section: 0) }
                    feedTableView.insertRows(at: indexPaths, with: .automatic)
                }
            }
        }
    }
    
    @objc
    private func handleRefresh() {
        viewModel.getPostsFromWeb { [unowned self] newPostsCount in
            if newPostsCount > 0 {
                let indexPaths = (0..<newPostsCount).map { IndexPath(row: $0, section: 0) }
                feedTableView.insertRows(at: indexPaths, with: .automatic)
            }
            feedTableView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource
extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath)
        guard let cell = cell as? FeedCell else { return UITableViewCell() }
        cell.viewModel = viewModel.getFeedCellViewModel(at: indexPath)
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
