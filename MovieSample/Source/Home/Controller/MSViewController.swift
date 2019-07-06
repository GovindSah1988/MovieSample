//
//  MSViewController.swift
//  MovieSample
//
//  Created by Govind Sah on 04/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

class MSViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var noContentLB: UILabel!
    
    var homeInteractor: MSHomePresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    private func initialSetup() {
        self.activityIndicatorView.startAnimating()
        setUpNavigationBar()
        homeInteractor = MSHomePresenter(delegate: self)
        homeInteractor.fetchTracks()
    }
    
    private func setUpNavigationBar() {
        self.navigationItem.title = MSConstants.MSLocalizedStringConstants.homeTitle
    }
}

extension MSViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeInteractor.numberOfTracks()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MSConstants.MSViewIdentifiers.trackTVC, for: indexPath)
        if let track = homeInteractor?.track(at: indexPath.row) {
            (cell as? MSTrackTableViewCell)?.track = track
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let track = homeInteractor?.track(at: indexPath.row) {
            let detailVC = MSDetailViewController.detailVC()
            detailVC.track = track
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension MSViewController: MSHomePresenterOutput {
    func tracks(_ tracks: [MSTrack]?, error: MSError?) {
        DispatchQueue.main.async { [weak self] in
            if nil == error {
                let contentsAvailbale = tracks?.count ?? 0 > 0
                self?.noContentLB.isHidden = contentsAvailbale
                if contentsAvailbale {
                    self?.tableView.reloadData()
                } else {
                    // No content to show
                    self?.presentOkAlert(message: MSConstants.MSLocalizedStringConstants.emptyContent)
                }
                self?.activityIndicatorView.stopAnimating()

            } else if MSError.requestCancelled == error {
                self?.presentOkAlert(message: MSConstants.MSLocalizedStringConstants.commonErrorInfo)
            }
        }

    }
}
