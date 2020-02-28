//
//  BaseCollectionViewController.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

class BaseCollectionViewController: BaseViewController {
    /// collection view link
    @IBOutlet weak var cv: UICollectionView!
    /// view model which controls the vc, must be set!
    var viewModel: CommonViewModel!

    /// should be initialize vc manually or with help of storyboard/nib?
    var manualBuilding = false

    // hooks
    /// that closure should construct custom tableview if needed
    var viewBuilder: (() -> (UIView, UICollectionView, Bool))? = nil

    /// initializer hook is being called in viewDidLoad
    var initializer: ((UICollectionView) -> Void)? = nil

    /// hook is being called in didMove(toParent:)
    /// if toParent == nil
    var exiter: (() -> Void)? = nil

    /// hook is being called in
    /// tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    var headerViewGen: ((Int) -> UIView?)? = nil

    override func loadView() {
        super.loadView()

        if manualBuilding {
            let v: UIView
            let attach: Bool
            if let b = viewBuilder {
                let (createdView, collectionView, a) = b()
                v = createdView
                cv = collectionView
                attach = a
            } else {
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .horizontal
                let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
                self.cv = cv
                attach = true
                v = cv
            }
            if attach {
                v.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(v)
                view.addConstraints([v.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     v.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     v.topAnchor.constraint(equalTo: view.topAnchor),
                                     v.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cv.delegate = self
        cv.dataSource = self

        initializer?(cv)

        bind()

        viewModel.getContents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            exiter?()
        }
    }

    // MARK: - BaseViewController

    override func apply(theme: Theme) {
        super.apply(theme: theme)
        viewModel.theme = theme
        self.theme = theme
    }

    // MARK: - Private / Internal

    private func bind() {
        viewModel.updateData.asObservable()
            .subscribe(onNext: { [weak self] update in
                if update {
                    self?.cv.reloadData()
                }
            })
            .disposed(by: disposeBag)

        viewModel.scrollTo.asObservable()
            .subscribe(onNext: { [weak self] scroll in
                if let s = scroll {
                    DispatchQueue.main.async {
                        self?.cv.scrollToItem(at: IndexPath(row: s.row, section: s.section),
                                              at: .top, animated: s.animated)
                    }
                }
            })
            .disposed(by: disposeBag)

        viewModel.removeKeyboard.asObservable()
            .subscribe(onNext: { [weak self] remove in
                if remove {
                    self?.view.endEditing(true)
                }
            })
            .disposed(by: disposeBag)
    }

    internal let disposeBag = DisposeBag()
}

extension BaseCollectionViewController: UICollectionViewDelegate {
}

extension BaseCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sectionsCount()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.modelsCount(for: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let m = viewModel.model(for: indexPath)
        return collectionView.dequeueReusableCell(withModel: m as! CellAnyModel, for: indexPath)
    }
}
