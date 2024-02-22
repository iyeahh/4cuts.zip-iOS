//
//  SuggestionTableViewCell.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/25/24.
//

import UIKit
import SnapKit

final class SuggestionTableViewCell: BaseTableViewCell {
    let profileImageView = UIImageView()

    let nameLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()

    let createDateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .gray
        return label
    }()

    let followButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Follow"
        configuration.titleAlignment = .center
        configuration.titlePadding = 20
        configuration.baseBackgroundColor = Constant.Color.accent
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .capsule
        configuration.buttonSize = .mini
        button.configuration = configuration
        return button
    }()

    let mainImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let contentLabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 13)
        return label
    }()

    let likeButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemPink
        return button
    }()

    let commentImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "message")
        imageView.tintColor = .gray
        return imageView
    }()

    let commentCountLabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 11)
        return label
    }()

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        contentLabel.asColor()
    }

    override func configureHierarchy() {
        let views = [profileImageView, nameLabel, createDateLabel, followButton, mainImageView, contentLabel, likeButton, commentImageView, commentCountLabel]

        views.forEach { contentView.addSubview($0) }
    }

    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(15)
            make.width.height.equalTo(contentView.snp.width).dividedBy(8)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView).offset(5)
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
        }

        createDateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
        }

        followButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(15)
            make.centerY.equalTo(profileImageView)
        }

        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView).inset(15)
            make.height.equalTo(mainImageView.snp.width).multipliedBy(0.75)
        }

        contentLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(15)
            make.top.equalTo(mainImageView.snp.bottom).offset(15)
            make.height.equalTo(15)
        }

        likeButton.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(15)
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.width.height.equalTo(profileImageView).dividedBy(2)
        }

        commentImageView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(13)
            make.leading.equalTo(likeButton.snp.trailing).offset(5)
            make.width.height.equalTo(likeButton).multipliedBy(0.7)
        }

        commentCountLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(13)
            make.leading.equalTo(commentImageView.snp.trailing).offset(5)
            make.centerY.equalTo(likeButton)
        }
    }

}
