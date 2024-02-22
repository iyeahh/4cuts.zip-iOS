//
//  PinterestCompostionalLayout.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/27/24.
//

import UIKit

final class PinterestCompostionalLayout {

    struct Configuration {
        let numberOfColumns: Int
        let interItemSpacing: CGFloat
        let contentInsetsReference: UIContentInsetsReference
        let itemHeightProvider: (_ index: Int,_ itemWidth: CGFloat) -> CGFloat
        let itemCountProfider: () -> Int

        init( numberOfColumns: Int = 3,
              interItemSpacing: CGFloat = 8,
              contentInsetsReference: UIContentInsetsReference = .automatic,
              itemHeightProvider: @escaping (_: Int, _: CGFloat) -> CGFloat,
              itemCountProfider: @escaping () -> Int
        ) {
            self.numberOfColumns = numberOfColumns
            self.interItemSpacing = interItemSpacing
            self.contentInsetsReference = contentInsetsReference
            self.itemHeightProvider = itemHeightProvider
            self.itemCountProfider = itemCountProfider
        }
    }

    final class LayoutBuilder {
        private var columnHeights: [CGFloat]
        private let numberOfColumns: CGFloat
        private let interItemSpacing: CGFloat
        private let itemHeightProvider: (_ index: Int,_ itemWidth: CGFloat) -> CGFloat
        private let collectionWidth: CGFloat

        init(configuration: Configuration, collectionWidth: CGFloat) {
            columnHeights = [CGFloat](repeating: 0, count: configuration.numberOfColumns)
            numberOfColumns = CGFloat(configuration.numberOfColumns)
            itemHeightProvider = configuration.itemHeightProvider
            interItemSpacing = configuration.interItemSpacing
            self.collectionWidth = collectionWidth
        }

        private var columnWidth: CGFloat {
            let spacing = (numberOfColumns - 1) * interItemSpacing
            return (collectionWidth - spacing) / numberOfColumns
        }


        private func frame(for row: Int) -> CGRect {
            let width = columnWidth
            let height = itemHeightProvider(row, width)
            let size = CGSize(width: width, height: height)
            let origin = itemOrigin(width: size.width)
            return CGRect(origin: origin, size: size)
        }

        func makeLayoutItem(for row: Int) -> NSCollectionLayoutGroupCustomItem {
            let frame = frame(for: row)
            columnHeights[columnIndex()] = frame.maxY + interItemSpacing
            return NSCollectionLayoutGroupCustomItem(frame: frame)
        }

        private func columnIndex() -> Int {
            return columnHeights
                .enumerated()
                .min(by: { $0.element < $1.element })? .offset ?? 0
        }

        private func itemOrigin(width: CGFloat) -> CGPoint {
            let y = columnHeights[columnIndex()].rounded()
            let x = (width + interItemSpacing) * CGFloat(columnIndex())
            return CGPoint(x: x, y: y)
        }

        fileprivate func maxcolumHeight() -> CGFloat {
            return columnHeights.max() ?? 0
        }

    }

    static func makeLayoutSection(
        config: Configuration,
        environment: NSCollectionLayoutEnvironment,
        sectionIndex: Int
    ) -> NSCollectionLayoutSection {

        var items: [NSCollectionLayoutGroupCustomItem] = []

        let itemProvider = LayoutBuilder(
            configuration: config,
            collectionWidth: environment.container.contentSize.width
        )

        for i in 0..<config.itemCountProfider() {
            let item = itemProvider.makeLayoutItem(for: i)
            items.append(item)
        }

        let groupLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(itemProvider.maxcolumHeight())
        )

        let group = NSCollectionLayoutGroup.custom(
            layoutSize: groupLayoutSize) { _ in
                return items
            }

        let section = NSCollectionLayoutSection(group: group)

        section.contentInsetsReference = config.contentInsetsReference
        return section
    }

}
