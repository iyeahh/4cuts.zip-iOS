//
//  CollectionViewController.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/25/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

final class CollectionViewController: BaseViewController {

    private let searchBar = UISearchBar()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())

    typealias DataSourceSnapShot = NSDiffableDataSourceSnapshot<Int, PhotoModel>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, PhotoModel>

    private let viewModel = CollectionViewModel()

    let disposeBag = DisposeBag()

    var dataSource: DataSource?

    override func bind() {
        let startTriggerSub = BehaviorRelay<PostCategory> (value: .photo)

        let input = CollectionViewModel.Input(
            startTriggerSub: startTriggerSub,
            isNextCursor: collectionView.rx.prefetchItems
        )
        
        let output = viewModel.transform(input: input)

        output.successData
            .bind(with: self) { owner, models in
                owner.makeSnapshot(models: models)
            }
            .disposed(by: disposeBag)
    }

    private func collectionViewRxSetting(_ models: BehaviorRelay<[PhotoModel]>) {
        models
            .bind(with: self) { owner, models in
                owner.makeSnapshot(models: models)
            }
            .disposed(by: disposeBag)
    }

    override func configureView() {
        configureNavi()

        collectionView.register(PinterestCollectionViewCell.self, forCellWithReuseIdentifier: PinterestCollectionViewCell.identifier)
        collectionView.setCollectionViewLayout(createLayout(), animated: true)

        searchBar.searchBarStyle = .minimal

        makeDataSource()
        makeSnapshot(models: [])
    }

    override func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }

    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }

        collectionView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(searchBar.snp.bottom)
        }
    }

    private func configureNavi() {
        navigationItem.title = "모아보기"

        let barbuttonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: nil, action: nil)
        barbuttonItem.tintColor = Constant.Color.accent
        navigationItem.rightBarButtonItem = barbuttonItem

        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = Constant.Color.accent
        navigationItem.backBarButtonItem = backBarButtonItem

        barbuttonItem.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PostViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }

    private func createPinterstLayout(env: NSCollectionLayoutEnvironment, models: [PhotoModel], viewWidth: CGFloat) -> NSCollectionLayoutSection {

        let layout = PinterestCompostionalLayout.makeLayoutSection(
            config: .init(
                numberOfColumns: 3,
                interItemSpacing: 8,
                contentInsetsReference: UIContentInsetsReference.automatic,
                itemHeightProvider: { item, itemWidth in
                    let aspect = models[item].aspect
                    let result = (viewWidth / 3 / aspect) + 30
                    return result
                },
                itemCountProfider: {
                    return models.count
                }
            ),
            environment: env,
            sectionIndex: 0
        )

        return layout
    }

    private func makeDataSource() {
        let register = colelctionCellRegister()
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: register, for: indexPath, item: itemIdentifier)
        })
    }

    private func colelctionCellRegister() -> UICollectionView.CellRegistration<PinterestCollectionViewCell, PhotoModel> {
        UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            KingfisherManager.shared.setHeaders()

            let url = itemIdentifier.photo.url

            cell.imageView.kf.setImage(with: url)
        }
    }

    private func makeSnapshot(models: [PhotoModel]) {
        var snapshot = DataSourceSnapShot()
        snapshot.deleteAllItems()
        snapshot.appendSections([0])

        snapshot.appendItems(models, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let viewWidth = view.bounds.width
        let layout = UICollectionViewCompositionalLayout { [weak self] section, env in
            guard let self else { return nil }
            return createPinterstLayout(env: env, models: viewModel.realModel, viewWidth: viewWidth)
        }

        return layout
    }

}
