//
//  ProductsViewController.swift
//  TestProject_SkyWebPro
//
//  Created by Михаил on 17.08.2021.
//

import UIKit

class ProductsViewController: UIViewController {
    
    private let networkDataFetcher = NetworkDataFetcher()
    private var timer: Timer?
    var categoryID: Int? = nil
    private lazy var searchController = UISearchController(searchResultsController: nil)
    private lazy var refreshControl = UIRefreshControl()

    var products: Products? {
        didSet {
            productsTableView.reloadData()
        }
    }
    var searchedProducts: [Product]? = nil
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForSearchText(_ searchText: String, category: Products? = nil) {
        searchedProducts = products?.data.filter({ (product: Product) -> Bool in
            return (product.name?.lowercased().contains(searchText.lowercased()))!
        })
        productsTableView.reloadData()
    }
    
    private lazy var productsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.toAutoLayout()
        tableView.register(ProductsTableViewCell.self, forCellReuseIdentifier: String(describing: ProductsTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        guard let id = categoryID else { return }
        let urlString = "http://62.109.7.98/api/product/category/\(id)"
        networkDataFetcher.fetchProducts(urlString: urlString) { response in
            guard let search = response else { return }
            self.products = search
        }
    }

}

extension ProductsViewController {
    private func setupLayout() {
        navigationController?.navigationBar.isHidden = false
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        refreshControl.addTarget(self, action: #selector(refreshControlChanged), for: .valueChanged)
        view.addSubview(productsTableView)
        productsTableView.addSubview(refreshControl)
        
        let contstraints = [
            productsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            productsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(contstraints)
        
        
    }
    @objc private func refreshControlChanged() {
        if productsTableView.isDragging {
            productsTableView.reloadData()
            guard let id = categoryID else { return }
            let urlString = "http://62.109.7.98/api/product/category/\(id)"
            networkDataFetcher.fetchProducts(urlString: urlString) { response in
                guard let search = response else { return }
                self.products = search
            }
            refreshControl.endRefreshing()
        }
    }
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return searchedProducts?.count ?? 0
        }
        return products?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductsTableViewCell.self), for: indexPath) as! ProductsTableViewCell
        
        if isFiltering {
            let p2 = searchedProducts?[indexPath.row]
            cell.textLabel?.text = p2?.name
        } else {
            let p1 = products?.data[indexPath.row]
            cell.textLabel?.text = p1?.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = DetailViewController()
        if isFiltering {
            
            let p2 = searchedProducts?[indexPath.row]
            vc.nameLabel.text = p2?.name
            vc.ccalLabel.text = "\(p2!.ccal!) ccal"
            vc.categoryLabel.text = title
            vc.dateLabel.text = p2?.date
            vc.pictureImageView.image = #imageLiteral(resourceName: "1")
        } else {
            let p1 = products?.data[indexPath.row]
            vc.nameLabel.text = p1?.name
            vc.ccalLabel.text = "\(p1!.ccal!) ccal"
            vc.categoryLabel.text = title
            vc.dateLabel.text = p1?.date
            vc.pictureImageView.image = #imageLiteral(resourceName: "1")
        }
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle , forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            products?.data.remove(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension ProductsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
