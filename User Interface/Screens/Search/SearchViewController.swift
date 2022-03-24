//
//  SearchViewController.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 23/03/22.
//

import Foundation
import UIKit
import Combine
import CombineSchedulers

// MARK: - Class Definition

final class SearchViewController: UIViewController {
    
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    
    let viewModel: SearchViewModelType
    let distanceToEndBeforeFetchingMore: Int
    let scheduler: AnySchedulerOf<RunLoop>
    
    private(set) var dataSource: UICollectionViewDiffableDataSource<Int, Photo>?
    private var cancellables: Set<AnyCancellable> = []
    
    init?(coder: NSCoder, viewModel: SearchViewModelType, scheduler: AnySchedulerOf<RunLoop> = .main, distanceToEndBeforeFetchingMore: Int = 5) {
        self.viewModel = viewModel
        self.distanceToEndBeforeFetchingMore = distanceToEndBeforeFetchingMore
        self.scheduler = scheduler
        super.init(coder: coder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View Lifecycle

extension SearchViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Most Popular".localized
        
        prepareCollectionView()
        setupSubscriptions()
    }
}

// MARK: - UI Preparation

extension SearchViewController {
    
    private func prepareCollectionView() {
        dataSource = UICollectionViewDiffableDataSource<Int, Photo>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.className, for: indexPath)
            (cell as? PhotoCollectionViewCell)?.populate(from: itemIdentifier)
            return cell
        }
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        collectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
}

// MARK: - Combine Subscriptions

extension SearchViewController {
    
    private func setupSubscriptions() {
        viewModel.appendPhotosPublisher
            .receive(on: scheduler)
            .sink { _ in
            } receiveValue: { [weak self] photos in
                guard let dataSource = self?.dataSource else { return }
                var snapshot = dataSource.snapshot()
                if snapshot.numberOfSections == 0 {
                    snapshot.appendSections([0])
                }
                snapshot.appendItems(photos)
                dataSource.apply(snapshot)
            }
            .store(in: &cancellables)
        
        viewModel.resetPhotosPublisher
            .receive(on: scheduler)
            .sink { _ in
            } receiveValue: { [weak self] _ in
                guard let dataSource = self?.dataSource else { return }
                var snapshot = NSDiffableDataSourceSnapshot<Int, Photo>()
                snapshot.appendSections([0])
                dataSource.apply(snapshot)
            }
            .store(in: &cancellables)

    }
}

// MARK: - User Actions

extension SearchViewController {
    
    @objc private func pullToRefresh() {
        viewModel.refresh()
    }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let currentPhoto = dataSource?.itemIdentifier(for: indexPath) else { return }
        fetchMoreIfNeeded(reachedPhoto: currentPhoto)
    }
}

// MARK: - Helpers

extension SearchViewController {
    
    func fetchMoreIfNeeded(reachedPhoto photo: Photo) {
        guard shouldFetchMore(reachedPhoto: photo) else { return }
        viewModel.fetchNext()
    }
    
    func shouldFetchMore(reachedPhoto photo: Photo) -> Bool {
        guard let items = dataSource?.snapshot(for: 0).items,
              let currentIndex = items.firstIndex(of: photo),
              items.indices.suffix(distanceToEndBeforeFetchingMore).contains(currentIndex)
        else { return false }
        return true
    }
}
