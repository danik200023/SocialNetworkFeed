//
//  FeedCell.swift
//  SocialNetworkFeed
//
//  Created by Danila Umnov on 05.03.2025.
//

import UIKit

final class FeedCell: UITableViewCell {
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.numberOfLines = 1
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        
        return label
    }()
    
    var viewModel: FeedCellViewModelProtocol! {
        didSet {
            viewModel.loadImage { [weak self] data in
                self?.avatarImageView.image = UIImage(data: data)
            }
            titleLabel.text = viewModel.title
            usernameLabel.text = viewModel.username
            descriptionLabel.text = viewModel.description
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            avatarImageView.heightAnchor.constraint(equalToConstant: 30),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor),
            
            
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 6),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            usernameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
}
