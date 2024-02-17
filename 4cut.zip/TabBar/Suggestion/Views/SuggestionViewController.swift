//
//  SuggestionViewController.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/23/24.
//

import UIKit
import SnapKit

final class SuggestionViewController: BaseViewController {

    let newButton = {
        let button = UIButton()
        button.configuration = .category(title: "New포토부스 ✨")
        return button
    }()

    let backgroundButton = {
        let button = UIButton()
        button.configuration = .category(title: "배경/필터 🫧")
        return button
    }()

    let poseButton = {
        let button = UIButton()
        button.configuration = .category(title: "포즈 🫶🏻")
        return button
    }()

    let tableView = UITableView()

    override func configureView() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = TabBar.suggestion.rawValue
    }

    override func configureHierarchy() {
        view.addSubview(newButton)
        view.addSubview(backgroundButton)
        view.addSubview(poseButton)
        view.addSubview(tableView)
    }

    override func configureLayout() {
        newButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
        }

        backgroundButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.leading.equalTo(newButton.snp.trailing).offset(10)
        }

        poseButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.leading.equalTo(backgroundButton.snp.trailing).offset(10)
        }

        tableView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(newButton.snp.bottom).offset(5)
        }
    }

}
