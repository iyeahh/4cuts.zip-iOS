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
        button.configuration?.baseForegroundColor = .darkGray
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
        configureNavi()
        configureTableView()
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
            .bind { [weak self] in
                guard let self else { return }
                newButton.configuration?.baseForegroundColor = .darkGray
                backgroundButton.configuration?.baseForegroundColor = .white
                poseButton.configuration?.baseForegroundColor = .white
            }
            .disposed(by: disposeBag)

        backgroundButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                backgroundButton.configuration?.baseForegroundColor = .darkGray
                newButton.configuration?.baseForegroundColor = .white
                poseButton.configuration?.baseForegroundColor = .white
            }
            .disposed(by: disposeBag)

        poseButton.rx.tap
            .bind { [weak self] _ in
                guard let self else { return }
                poseButton.configuration?.baseForegroundColor = .darkGray
                newButton.configuration?.baseForegroundColor = .white
                backgroundButton.configuration?.baseForegroundColor = .white
            }
            .disposed(by: disposeBag)

        let followButtonTap = PublishSubject<String>()

        let input = SuggestionViewModel.Input(
            categoryTap: Observable.just(PostCategory.new),
            newButtonTap: newButton.rx.tap
                .withLatestFrom(Observable.just(PostCategory.new)),
            backgroudButtonTap: backgroundButton.rx.tap
                .withLatestFrom(Observable.just(PostCategory.background)),
            poseButtonTap: poseButton.rx.tap
                .withLatestFrom(Observable.just(PostCategory.pose)), cellTap: Observable.zip(tableView.rx.modelSelected(PostContent.self), tableView.rx.itemSelected), followButtonTap: followButtonTap
        )

        let output = viewModel.transform(input: input)
        var postId = ""

        output.postList
            .bind(to: tableView.rx.items(cellIdentifier: SuggestionTableViewCell.identifier, cellType: SuggestionTableViewCell.self)) { (row, element, cell) in

                cell.profileImageView.kf.setImage(with: element.creator.profileImage.url)
                cell.nameLabel.text = element.creator.nick
                cell.createDateLabel.text = DateFormatterManager.shared.dateFormat(element.createdAt)
                cell.mainImageView.kf.setImage(with: element.files.first?.url)
                cell.contentLabel.text = element.content
                cell.commentCountLabel.text = "\(element.comments!.count)"
                postId = element.post_id

                cell.followButton.rx.tap
                    .withLatestFrom(Observable.just(postId))
                    .subscribe(with: self) { owner, value in
                        followButtonTap.onNext(value)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        output.nextVCObservable
            .subscribe(with: self) { owner, value in
                let vc = PostViewController()
                vc.postContent = value.0
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }

    private func configureTableView() {
        tableView.register(SuggestionTableViewCell.self, forCellReuseIdentifier: SuggestionTableViewCell.identifier)
        tableView.rowHeight = 420
        tableView.separatorStyle = .none
    }

    private func configureNavi() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = TabBar.suggestion.rawValue

        let barbuttonItem = UIBarButtonItem(image: UIImage(systemName: "map"), style: .plain, target: nil, action: nil)
        barbuttonItem.tintColor = Constant.Color.accent
        navigationItem.rightBarButtonItem = barbuttonItem

        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = Constant.Color.accent
        navigationItem.backBarButtonItem = backBarButtonItem

        barbuttonItem.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(MapViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }

}
