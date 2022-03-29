//
//  PhotoTabViewController.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 23/03/22.
//

import Foundation
import UIKit
import Combine
import CombineSchedulers
import ServiceLayer
import Lottie

// MARK: - Class Definition

final class PhotoTabViewController: UIViewController {
    
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    @IBOutlet private weak var emptyStateContainer: UIView!
    @IBOutlet private weak var loadingStateContainer: UIView!
    @IBOutlet private weak var loadingAnimationView: AnimationView!
    @IBOutlet private weak var emptyAnimationView: AnimationView!
    
    let viewModel: PhotoTabViewModelType
    let distanceToEndBeforeFetchingMore: Int
    let scheduler: AnySchedulerOf<RunLoop>
    let searchController: UISearchController
    
    private var presentingAlert: Bool
    private(set) var dataSource: UICollectionViewDiffableDataSource<Int, Photo>?
    private var cancellables: Set<AnyCancellable> = []
    private var viewModelIsLoading: Bool
    private var photoTapped: Bool
    
    init?(coder: NSCoder,
          viewModel: PhotoTabViewModelType,
          scheduler: AnySchedulerOf<RunLoop> = .main,
          distanceToEndBeforeFetchingMore: Int = 5,
          searchController: UISearchController) {
        
        self.viewModel = viewModel
        self.distanceToEndBeforeFetchingMore = distanceToEndBeforeFetchingMore
        self.scheduler = scheduler
        self.searchController = searchController
        self.presentingAlert = false
        self.viewModelIsLoading = false
        self.photoTapped = false
        super.init(coder: coder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View Lifecycle

extension PhotoTabViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.screenTitle
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        collectionView.scrollsToTop = false
        
        
        prepareCollectionView()
        setupCollectionViewLayout()
        setupSearchBar()
        prepareLoadingAnimation()
        prepareEmptyStateAnimation()
        setupSubscriptions()
        viewModel.fetchMostPopular()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let snapshot = dataSource?.snapshot() else { return }
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
}

// MARK: - UI Preparation

extension PhotoTabViewController {
    
    private func prepareCollectionView() {
        dataSource = UICollectionViewDiffableDataSource<Int, Photo>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.className, for: indexPath)
            let photoCell = cell as? PhotoCollectionViewCell
            photoCell?.populate(from: itemIdentifier) { [weak self] graphicsProvider in
                self?.viewModel.graphicRepresentation(for: itemIdentifier, withCompletion: graphicsProvider)
            }
            return cell
        }
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        collectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 5, left: 5, bottom: 20, right: 5)
    }
    
    private func setupCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        let gap: CGFloat = 5
        
        flowLayout.minimumLineSpacing = gap
        flowLayout.minimumInteritemSpacing = gap
        let itemSize = (view.bounds.width - 3 * gap) / 2
        flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    private func setupSearchBar() {
        // Change placeholder text color
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = "Search photos...".localized
        searchController.searchBar.delegate = self
    }
    
    private func prepareLoadingAnimation() {
        if let loadingAnimationPath = Bundle(for: Self.self).path(forResource: "loading", ofType: "json") {
            loadingAnimationView.animation = .filepath(loadingAnimationPath)
            loadingAnimationView.loopMode = .loop
        }
    }
    
    private func prepareEmptyStateAnimation() {
        if let emptyAnimationPath = Bundle(for: Self.self).path(forResource: "10223-search-empty", ofType: "json") {
            emptyAnimationView.animation = .filepath(emptyAnimationPath)
            emptyAnimationView.loopMode = .autoReverse
        }
    }
}

// MARK: - Combine Subscriptions

extension PhotoTabViewController {
    
    private func setupSubscriptions() {
        viewModel.photosChangedPublisher
            .receive(on: scheduler)
            .sink { _ in
            } receiveValue: { [weak self] photos in
                var snapshot = NSDiffableDataSourceSnapshot<Int, Photo>()
                snapshot.appendSections([0])
                snapshot.appendItems(photos)
                self?.dataSource?.apply(snapshot)
                self?.refreshUIState()
            }
            .store(in: &cancellables)
        
        viewModel.errorMessagePublisher
            .debounce(for: 0.5, scheduler: scheduler)
            .sink { [weak self] message in
                guard self?.presentingAlert == nil else { return }
                self?.presentingAlert = true
                let alert = UIAlertController(title: "Error Occurred".localized, message: message, preferredStyle: .alert)
                alert.addAction(.init(title: "OK".localized, style: .cancel) { [weak self] _ in
                    self?.presentingAlert = false
                })
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.isLoadingPublisher
            .receive(on: scheduler)
            .sink { [weak self] isLoading in
                self?.viewModelIsLoading = isLoading
                self?.refreshUIState()
            }
            .store(in: &cancellables)
        
    }
    
    private func refreshUIState() {
        collectionView.refreshControl?.endRefreshing()
        guard let snapshot = dataSource?.snapshot() else { return }
        
        if snapshot.numberOfItems != 0 {
            collectionView.alpha = 1
            emptyStateContainer.alpha = 0
            loadingStateContainer.alpha = 0
            emptyAnimationView.stop()
            loadingAnimationView.stop()
        } else {
            collectionView.alpha = 0
            if viewModelIsLoading {
                emptyStateContainer.alpha = 0
                loadingStateContainer.alpha = 1
                emptyAnimationView.stop()
                loadingAnimationView.play()
            } else {
                emptyStateContainer.alpha = 1
                loadingStateContainer.alpha = 0
                emptyAnimationView.play()
                loadingAnimationView.stop()
            }
        }
    }
}

// MARK: - User Actions

extension PhotoTabViewController {
    
    @objc private func pullToRefresh() {
        viewModel.refresh()
    }
}

// MARK: - UICollectionViewDelegate

extension PhotoTabViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let currentPhoto = dataSource?.itemIdentifier(for: indexPath) else { return }
        fetchMoreIfNeeded(reachedPhoto: currentPhoto)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard photoTapped == false,
              let photo = dataSource?.itemIdentifier(for: indexPath)
        else { return }
        photoTapped = true
        viewModel.openPhotoDetails(photo, scheduler: scheduler) { [weak self] error in
            self?.photoTapped = false
            guard error != nil else { return }
            
            let alert = UIAlertController(title: "Error".localized, message: "Opening image failed, try again later".localized, preferredStyle: .alert)
            alert.addAction(.init(title: "OK".localized, style: .cancel))
            self?.present(alert, animated: true)
        }
    }
}

// MARK: - UISearchBarDelegate

extension PhotoTabViewController: UISearchBarDelegate {
    
    // called when text changes (including clear)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.isEmpty else { return }
        viewModel.fetchMostPopular()
    }
    
    // called when keyboard search button pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        viewModel.searchPhoto(searchQuery: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.fetchMostPopular()
        searchBar.resignFirstResponder()
    }
}

// MARK: - Helpers

extension PhotoTabViewController {
    
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
