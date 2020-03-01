//
//  DigestViewController.swift
//  Photos13
//
//  Created by Gary on 11/10/19.
//  Copyright © 2019 Gary Hanson. All rights reserved.
//


import UIKit
import Photos

struct Section: Decodable, Hashable {
    let id: Int
    let type: SectionType
    var items: [Int]
}

enum SectionType: Int, Decodable {
    case TwoByThree
    case ThreeByTwo
    case ThreeOverTwo
    case TwoOverThree
    case Scroller
}


final class DigestViewController: UIViewController, Storyboarded {
    
    weak var coordinator: AppCoordinator?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    private var collectionView: UICollectionView! = nil
    private let imageManager = PHImageManager()
    private var sections = [Section]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
                
        initializeCollectionVew()
        configureDataSource()
    }
    
    func loadData() {
        configureDataSource()
    }

}


extension DigestViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            switch self.sections[sectionIndex].type {
            case SectionType.ThreeOverTwo:
                return self.createThreeOverTwoSection()
            case SectionType.TwoOverThree:
                return self.createTwoOverThreeSection()
            case SectionType.ThreeByTwo:
                return self.createThreeByTwoSection()
            case SectionType.TwoByThree:
                return self.createTwoByThreeSection()
            case SectionType.Scroller:
                return self.createScrollingSection()
            }

        }
        
        return layout
    }

    private func createThreeOverTwoSection() -> NSCollectionLayoutSection {
        // this section is going to lay out three images above two images
        
        // the first group is three images, so each will occupy 1/3 of the width of the group. they are the same height as the group.
        let leadingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.333), heightDimension: .fractionalHeight(1))
        let leadingItem = NSCollectionLayoutItem(layoutSize: leadingItemSize)
        // the leading group takes up the whole width of the parent (section), but only 1/2 of the height
        let leadingGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)),
            subitem: leadingItem, count: 3)

        // the trailing group is two images, so each will take half the width of the parent (group) and all of the height
        let trailingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let trailingItem = NSCollectionLayoutItem(layoutSize: trailingItemSize)
        // like the leading group, this will take half of the height of the section and all of the width
        let trailingGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)),
            subitem: trailingItem, count: 2)

        // group the leading and trailing groups. they will take up the entire width of the collectionview, but we want to scale it
        // down to just over half the calculated height to make it look better on iPhones
        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.6)),
            subitems: [leadingGroup, trailingGroup])
        
        let layoutSection = NSCollectionLayoutSection(group: nestedGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        return layoutSection
    }
    
    private func createTwoOverThreeSection() -> NSCollectionLayoutSection {
        let leadingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let leadingItem = NSCollectionLayoutItem(layoutSize: leadingItemSize)
        let leadingGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)),
            subitem: leadingItem, count: 2)

        let trailingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3333), heightDimension: .fractionalHeight(1.0))
        let trailingItem = NSCollectionLayoutItem(layoutSize: trailingItemSize)
        let trailingGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)),
            subitem: trailingItem, count: 3)

        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.6)),
            subitems: [leadingGroup, trailingGroup])
        
        let layoutSection = NSCollectionLayoutSection(group: nestedGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        return layoutSection
    }
    
    private func createThreeByTwoSection() -> NSCollectionLayoutSection {
        let leadingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3333))
         let leadingItem = NSCollectionLayoutItem(layoutSize: leadingItemSize)
         let leadingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1.0)),
             subitem: leadingItem, count: 3)

        let trailingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
         let trailingItem = NSCollectionLayoutItem(layoutSize: trailingItemSize)
         let trailingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1.0)),
             subitem: trailingItem, count: 2)

         let nestedGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.6)),
             subitems: [leadingGroup, trailingGroup])
         
         let layoutSection = NSCollectionLayoutSection(group: nestedGroup)
         layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
         return layoutSection
     }
    
    private func createTwoByThreeSection() -> NSCollectionLayoutSection {
        let leadingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
         let leadingItem = NSCollectionLayoutItem(layoutSize: leadingItemSize)
         let leadingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1.0)),
             subitem: leadingItem, count: 2)

        let trailingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3333))
         let trailingItem = NSCollectionLayoutItem(layoutSize: trailingItemSize)
         let trailingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1.0)),
             subitem: trailingItem, count: 3)

         let nestedGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.6)),
             subitems: [leadingGroup, trailingGroup])
         
         let layoutSection = NSCollectionLayoutSection(group: nestedGroup)
         layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
         return layoutSection
     }
    
    private func createScrollingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalHeight(0.4))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        return layoutSection
    }
    
}

extension DigestViewController: UICollectionViewDelegate {
    
    private func initializeCollectionVew() {
        let collectionViewFrame = view.bounds

        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = backgroundColor
        collectionView.register(DigestViewCell.self, forCellWithReuseIdentifier: DigestViewCell.reuseIdentifier)
        view.addSubview(collectionView)
        collectionView.delegate = self
     }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
            <Section, Int>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DigestViewCell.reuseIdentifier,
                for: indexPath) as? DigestViewCell else { fatalError("Cannot create new cell") }

            guard Model.sharedInstance.assetCollection != nil else { return cell }

            let asset = Model.sharedInstance.assetCollection![identifier]
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            self.imageManager.requestImage(for: asset, targetSize: CGSize(width: cell.frame.width, height: cell.frame.height), contentMode: .aspectFit, options: options) {
                    (image: UIImage?, info: [AnyHashable : Any]?) -> Void in
                
                    cell.setImage(image)
            }

            return cell
        }

        guard Model.sharedInstance.assetCollection != nil else { return }
        let maxItems = Model.sharedInstance.assetCollection!.count
        let imageIndexes = Array(0..<Model.sharedInstance.assetCollection!.count).shuffled()    // randomize the photos
        var index = 0
        // create the ranges of photos for each section
        var sectionRanges = [ArraySlice<Int>]()
        while (index < maxItems) {
            var maxRangeIndex = index + 4
            if maxRangeIndex >= maxItems {
                maxRangeIndex = maxItems - 1
            }
            sectionRanges.append(imageIndexes[index...maxRangeIndex])
            index = maxRangeIndex + 1
        }
        
        if sectionRanges.count > 0 {
            self.sections.append(Section(id: 0, type: SectionType.TwoByThree, items: Array(sectionRanges[0])))
        }
        if sectionRanges.count > 1 {
            self.sections.append(Section(id: 1, type: SectionType.TwoOverThree, items: Array(sectionRanges[1])))
        }
        if sectionRanges.count > 2 {
            self.sections.append(Section(id: 4, type: SectionType.Scroller, items: Array(sectionRanges[2])))
        }
        if sectionRanges.count > 3 {
            self.sections.append(Section(id: 2, type: SectionType.ThreeByTwo, items: Array(sectionRanges[3])))
        }
        if sectionRanges.count > 4 {
            self.sections.append(Section(id: 3, type: SectionType.ThreeOverTwo, items: Array(sectionRanges[4])))
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        
        snapshot.appendSections(self.sections)
        for section in self.sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
                
        guard Model.sharedInstance.assetCollection != nil else { return }

        var assets = [PHAsset]()
        let items = self.sections[indexPath.section].items
        for identifier in items {
            let asset = Model.sharedInstance.assetCollection![identifier]
            assets.append(asset)
        }
        
        coordinator?.didSelectDigestPhoto(assets: assets)
    }
    
}


