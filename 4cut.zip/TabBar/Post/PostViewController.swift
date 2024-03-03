//
//  PostViewController.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/28/24.
//

import UIKit
import SnapKit

final class PostViewController: BaseViewController {

    let photoButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "사진 추가"
        configuration.titleAlignment = .center
        configuration.titlePadding = 20
        configuration.cornerStyle = .medium
        configuration.buttonSize = .medium
        button.configuration = configuration
        return button
    }()

    let photoImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray.cgColor
        return imageView
    }()

    let photoImageView2 = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray.cgColor
        return imageView
    }()

    let contentTextView = {
        let textView = UITextView()
        textView.text = "#부스추천 여기 어때?"
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        return textView
    }()

    let saveButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "새 글 올리기"
        configuration.titleAlignment = .center
        configuration.titlePadding = 20
        configuration.cornerStyle = .medium
        configuration.buttonSize = .medium
        button.configuration = configuration
        return button
    }()

    override func configureView() {
        view.backgroundColor = .white
    }

    override func configureHierarchy() {
        view.addSubview(photoButton)
        view.addSubview(photoImageView)
        view.addSubview(photoImageView2)
        view.addSubview(contentTextView)
        view.addSubview(saveButton)
    }

    override func configureLayout() {
        photoButton.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.size.equalTo(100)
        }

        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(photoButton.snp.trailing).offset(10)
            make.size.equalTo(100)
        }

        photoImageView2.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(photoImageView.snp.trailing).offset(10)
            make.size.equalTo(100)
        }

        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(contentTextView.snp.width).dividedBy(2)
        }

        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
    }

}
