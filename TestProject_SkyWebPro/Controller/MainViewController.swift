//
//  MainViewController.swift
//  TestProject_SkyWebPro
//
//  Created by Михаил on 17.08.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    let networkDataFetcher = NetworkDataFetcher()
    
    var categories: Categories? {
        didSet {
            categoriesTableView.reloadData()
        }
    }
    
    private lazy var categoriesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.toAutoLayout()
        tableView.register(CategoriesTableViewCell.self, forCellReuseIdentifier: String(describing: CategoriesTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        let urlString = "http://62.109.7.98/api/categories"
        networkDataFetcher.fetchCategories(urlString: urlString) { response in
            guard let search = response else { return }
            self.categories = search
        }
        
    }

}
extension MainViewController {
    private func setupLayout() {
        title = "Products"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(categoriesTableView)
        let constraints = [
            categoriesTableView.topAnchor.constraint(equalTo: view.topAnchor),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CategoriesTableViewCell.self), for: indexPath) as! CategoriesTableViewCell
        let category = categories?.data
        cell.textLabel?.text = category?[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ProductsViewController()
        guard let category = categories?.data[indexPath.row] else { return }
        vc.categoryID = category.id
        vc.title = category.name
        navigationController?.pushViewController(vc, animated: true)
    }
}
