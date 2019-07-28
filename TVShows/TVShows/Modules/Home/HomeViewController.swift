//
//  HomeViewController.swift
//  TVShows
//
//  Created by Anteo Ivankov on 13/07/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

final class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var showsTableView: UITableView!
    
    // MARK: - Private properties
    
    private var items: [Show] = []
    private let showService = ShowService()

    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        fetchShows()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - UITableView

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = showsTableView.dequeueReusableCell(withIdentifier: String(describing: TVShowTableViewCell.self), for: indexPath) as! TVShowTableViewCell
        cell.configure(with: items[indexPath.row])
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigateToShowDetailsScreen(showId: items[indexPath.row].id)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] action, indexPath in
            self?.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
        return [delete]
    }
    
}

// MARK: - Private API requests

private extension HomeViewController {
    func fetchShows() {
        SVProgressHUD.show()
        
        showService.fetchShows { [weak self] result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let value):
                self?.items =  value
                self?.showsTableView.reloadData()
                
            case .failure(let error):
                print("Error fetching shows: \(error)")
            }
        }
    }
}

// MARK: - Private UI setup

private extension HomeViewController {
    func setupUI() {
        title = "Shows"
    }
}

// MARK: - Private table view setup

private extension HomeViewController {
    func setupTableView() {
        showsTableView.estimatedRowHeight = 110
        showsTableView.rowHeight = UITableView.automaticDimension
        showsTableView.tableFooterView = UIView()
        
        showsTableView.dataSource = self
        showsTableView.delegate = self
    }
}



