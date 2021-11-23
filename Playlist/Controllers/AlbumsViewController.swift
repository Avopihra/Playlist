//
//  AlbumsViewController.swift
//  Playlist
//
//  Created by Viktoriya on 28.10.2021.
//

import UIKit

class AlbumsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(AlbumsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let searchController = UISearchController(searchResultsController: nil)
    
    var noAlbumsLabel: UILabel?
    var albums = [Album]()
    var timer: Timer?
    
    
// MARK:  - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        setupViews()
        setupDelegate()
        setConstraints()
        setNavigationBar()
        setupSearchController()
        setupNoAlbumLabel()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchBar.delegate = self
    }

    private func setNavigationBar() {
        navigationItem.title = "Albums"
        navigationItem.searchController = searchController
        let userInfoButton = createCustomButton(selector: #selector(userInfoButtonTapped))
        navigationItem.rightBarButtonItem = userInfoButton
    }
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func setupNoAlbumLabel() {
        let labelRect: CGRect = CGRect(x: 50, y: self.view.frame.size.height / 2, width: self.view.frame.size.width - 30, height: 150)
        self.noAlbumsLabel = UILabel(frame: labelRect)
        self.noAlbumsLabel?.text = "Enter the name of the album or artist"
        self.noAlbumsLabel?.textColor = #colorLiteral(red: 0.7146102786, green: 0.7103641629, blue: 0.717875421, alpha: 1)
        self.view.addSubview(noAlbumsLabel ?? UILabel(frame: labelRect))
    }
    
    @objc func userInfoButtonTapped() {
        let userInfoViewController = UserInfoViewController()
        navigationController?.pushViewController(userInfoViewController, animated: true)
    }
    
    private func fetchAlbums(albumName: String) {
        let urlString = "https://itunes.apple.com/search?term=\(albumName)&entity=album&attribute=albumTerm"
        NetworkDataFetch.shared.fetchAlbum(urlString: urlString) { [weak self] albumModel, error in
            if error == nil {
                guard let albumModel = albumModel else { return }
                if !albumModel.results.isEmpty {
                self?.noAlbumsLabel?.isHidden = true
                let sortedAlbums = albumModel.results.sorted { firstItem, secondItem in
                    return firstItem.collectionName.compare(secondItem.collectionName) == ComparisonResult.orderedAscending
                }
                self?.albums = sortedAlbums
                self?.tableView.reloadData()
//                if albumModel.results.isEmpty {
//                    self?.noAlbumsLabel?.isHidden = false
//                    self?.albums = sortedAlbums
//                    self?.tableView.reloadData()
//                } else {
//                    self?.noAlbumsLabel?.isHidden = true
//                }
            } else {
                self?.noAlbumsLabel?.isHidden = false
                self?.alertOk(title: "Error",
                              message: "Album not found. Enter full title")
            }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
}
//MARK: - UITableView DataSource

extension AlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath) as! AlbumsTableViewCell
        let album = albums[indexPath.row]
        cell.configureAlbumCell(album: album)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let albumsCount = albums.count
        if albumsCount > 0 {
            noAlbumsLabel?.isHidden = true
        } else {
            noAlbumsLabel?.isHidden = false
        }
        return albumsCount
    }
    
}

//MARK: - UITableView Delegate

extension AlbumsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailAlbumViewController = DetailAlbumViewController()
        let album = albums[indexPath.row]
        detailAlbumViewController.album = album
        detailAlbumViewController.title = album.artistName
        navigationController?.pushViewController(detailAlbumViewController, animated: true)
    }
}

//MARK: - UISearchBar Delegate

extension AlbumsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        if text != "" {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5,
                                         repeats: false,
                                         block: { [weak self] _ in
            self?.fetchAlbums(albumName: searchText)
            })
            fetchAlbums(albumName: text!)
        }
    }
}

//MARK: - SetConstraints

extension AlbumsViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}
