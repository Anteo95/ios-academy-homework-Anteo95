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

enum ItemsLayout {
    case list
    case grid
}

final class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var showsCollectionView: UICollectionView!
    
    // MARK: - Private properties
    
    private var items: [Show] = []
    private let showService = ShowService()
    private var itemsLayout: ItemsLayout = .list
    private let edgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    private let listImage = UIImage(named: "ic-listview")
    
    private let numberOfColumnsInGrid = 2
    private let gridImage = UIImage(named: "ic-gridview")
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
        fetchShows()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Actions
    
    @objc private func logoutActionHandler() {
        KeychainManager.removeUserInfo()
        navigateToLoginScreen()
    }
    
    @objc private func changeLayoutActionHandler() {
        switch itemsLayout {
        case .list:
            itemsLayout = .grid
            navigationItem.rightBarButtonItem?.image = listImage
        case .grid:
            itemsLayout = .list
            navigationItem.rightBarButtonItem?.image = gridImage
        }
        showsCollectionView.reloadData()
    }
}

// MARK: - UICollectionView

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch itemsLayout {
        case .list:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TVShowListCollectionViewCell.self), for: indexPath) as! TVShowListCollectionViewCell
            cell.configure(with: items[indexPath.row])
            return cell
        case .grid:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TVShowGridCollectionViewCell.self), for: indexPath) as! TVShowGridCollectionViewCell
            cell.configure(with: items[indexPath.row])
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        navigateToShowDetailsScreen(showId: items[indexPath.row].id)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch itemsLayout {
        case .list:
            let availableWidth = view.frame.width - edgeInsets.left - edgeInsets.right
            return CGSize(width: availableWidth, height: 128)
            
        case .grid:
            let paddingSpace = edgeInsets.left * CGFloat((numberOfColumnsInGrid + 1))
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / 2 - 5
            return CGSize(width: widthPerItem, height: 192)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return edgeInsets
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
                self?.showsCollectionView.reloadData()
                
            case .failure(let error):
                print("Error fetching shows: \(error)")
            }
        }
    }
}
    
// MARK: - Private UI setup

private extension HomeViewController {
    
    func setupNavigationBar() {
        let navigationBar = navigationController!.navigationBar
        navigationBar.tintColor = UIColor.darkGray
        
        let logoutItem = UIBarButtonItem(
            image: UIImage(named: "ic-logout"),
            style: .plain,
            target: self,
            action: #selector(logoutActionHandler)
        )
        navigationItem.leftBarButtonItem = logoutItem
        
        let changeLayoutItem = UIBarButtonItem(
            image: gridImage,
            style: .plain,
            target: self,
            action: #selector(changeLayoutActionHandler)
        )
        navigationItem.rightBarButtonItem = changeLayoutItem
        
        title = "Shows"

    }
}

// MARK: - Private collection view setup

private extension HomeViewController {
    
    func setupCollectionView() {
        let listCellNib = UINib(nibName: String(describing: TVShowListCollectionViewCell.self), bundle: nil)
        showsCollectionView.register(listCellNib, forCellWithReuseIdentifier:  String(describing: TVShowListCollectionViewCell.self))
        
        let gridCellNib = UINib(nibName: String(describing: TVShowGridCollectionViewCell.self), bundle: nil)
        showsCollectionView.register(gridCellNib, forCellWithReuseIdentifier:  String(describing: TVShowGridCollectionViewCell.self))
        
        showsCollectionView.dataSource = self
        showsCollectionView.delegate = self
    }
}




