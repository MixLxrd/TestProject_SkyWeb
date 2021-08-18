//
//  DetailViewController.swift
//  TestProject_SkyWebPro
//
//  Created by Михаил on 17.08.2021.
//

import UIKit

class DetailViewController: UIViewController {

    var product: Product?
    
    let nameLabel = UILabel()
    let ccalLabel = UILabel()
    let categoryLabel = UILabel()
    let dateLabel = UILabel()
    
    lazy var pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.toAutoLayout()
        imageView.image = UIImage(named: "1")
        imageView.sizeToFit()
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    init(product: Product, category: String?) {
        self.product = product
        self.categoryLabel.text = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailViewController {
    private func setupLayout() {
        
        nameLabel.toAutoLayout()
        nameLabel.text = product?.name
        
        ccalLabel.toAutoLayout()
        ccalLabel.text = "\(product!.ccal!) ccal"
        
        categoryLabel.toAutoLayout()
        
        dateLabel.toAutoLayout()
        dateLabel.text = product?.date
        
        view.backgroundColor = .white
        view.addSubview(nameLabel)
        view.addSubview(ccalLabel)
        view.addSubview(categoryLabel)
        view.addSubview(dateLabel)
        view.addSubview(pictureImageView)
        let constraints = [
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ccalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ccalLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: ccalLabel.bottomAnchor, constant: 16),
            categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -16),
            pictureImageView.bottomAnchor.constraint(equalTo: categoryLabel.topAnchor, constant: -16),
            pictureImageView.heightAnchor.constraint(equalToConstant: 100),
            pictureImageView.widthAnchor.constraint(equalToConstant: 100),
            pictureImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)

    }
}
