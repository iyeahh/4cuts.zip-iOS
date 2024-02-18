//
//  SuggestionViewController.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/23/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

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

    let viewModel = SuggestionViewModel()
    let disposeBag = DisposeBag()

    override func configureView() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = TabBar.suggestion.rawValue
        tableView.register(SuggestionTableViewCell.self, forCellReuseIdentifier: SuggestionTableViewCell.identifier)
        tableView.rowHeight = 420
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

    override func bind() {
        newButton.rx.tap
            .bind { _ in
                print("버튼 눌림", self.newButton.state)
            }
            .disposed(by: disposeBag)

        let input = SuggestionViewModel.Input(categoryTap: BehaviorSubject(value: PostCategory.new))

        let output = viewModel.transform(input: input)

        output.postList
            .bind(to: tableView.rx.items(cellIdentifier: SuggestionTableViewCell.identifier, cellType: SuggestionTableViewCell.self)) { (row, element, cell) in

                KingfisherManager.shared.setHeaders()

                cell.profileImageView.kf.setImage(with: element.creator.profileImage.url)
                cell.nameLabel.text = element.creator.nick
                cell.createDateLabel.text = DateFormatterManager.shared.dateFormat(element.createdAt)
                cell.mainImageView.kf.setImage(with: element.files.first!.url)
                cell.contentLabel.text = element.content
                cell.commentCountLabel.text = "\(element.comments.count)"
            }
            .disposed(by: disposeBag)
    }

}
