//
//  BaseTableViewController.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

class BaseTableViewController: BaseViewController {
    /// tableview link
    @IBOutlet weak var tableview: UITableView!
    /// view model which controls the vc, must be set!
    var viewModel: CommonViewModel!

    /// should we add a refresh control at the top of the tableview?
    var addRefreshControl = true

    /// should be initialize vc manually or with help of storyboard/nib?
    var manualBuilding = false

    /// call or not call viewController.getContents after view is loaded
    var contentsAtInit = true

    // hooks

    var leadingAnchorTVConstraint: NSLayoutConstraint?
    var trailingAnchorTVConstraint: NSLayoutConstraint?
    var topAnchorTVConstraint: NSLayoutConstraint?
    var bottomAnchorTVConstraint: NSLayoutConstraint?

    /// that closure should construct custom tableview if needed
    var viewBuilder: (() -> (UIView, UITableView, Bool))? = nil

    /// initializer hook is being called in viewDidLoad
    var initializer: ((UITableView) -> Void)? = nil

    /// hook is being called in didMove(toParent:)
    /// if toParent == nil
    var exiter: (() -> Void)? = nil

    /// hook is being called in
    /// tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    var headerViewGen: ((Int) -> UIView?)? = nil

    /// heightForFooter
    var heightForFooterSizeHook: ((Int) -> CGFloat)? = nil

    /// heightForHeader
    var heightForHeaderSizeHook: ((Int) -> CGFloat)? = nil

    /// defaultEstimateHeight for cells
    var defaultEstimateHeight: CGFloat = 44

    override func loadView() {
        super.loadView()

        if manualBuilding {
            let v: UIView
            let attach: Bool
            if let b = viewBuilder {
                let (cv, tv, a) = b()
                v = cv
                tableview = tv
                attach = a
            } else {
                let tv = UITableView()
                tableview = tv
                v = tv
                attach = true
            }
            if attach {
                v.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(v)

                leadingAnchorTVConstraint = v.leadingAnchor.constraint(equalTo: view.leadingAnchor)
                leadingAnchorTVConstraint?.isActive = true

                trailingAnchorTVConstraint = v.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                trailingAnchorTVConstraint?.isActive = true

                topAnchorTVConstraint = v.topAnchor.constraint(equalTo: view.topAnchor)
                topAnchorTVConstraint?.isActive = true

                bottomAnchorTVConstraint = v.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                bottomAnchorTVConstraint?.isActive = true

//                view.addConstraints([v.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                                     v.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//                                     v.topAnchor.constraint(equalTo: view.topAnchor),
//                                     v.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // standard class is always avail.
        tableview.register(UITableViewCell.self,
                           forCellReuseIdentifier: "UITableViewCell")

        tableview.delegate = self
        tableview.dataSource = self

        if addRefreshControl {
            if #available(iOS 10.0, *) {
                tableview.refreshControl = refreshControl
            } else {
                tableview.addSubview(refreshControl)
            }
            refreshControl.addTarget(self,
                                     action: #selector(refreshData(_:)),
                                     for: .valueChanged)
        }

        initializer?(tableview)

        bind()

        // can we show contents?
        // or there are some custom activities out there?
        if !contentsAtInit { return }

        viewModel.getContents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        cellHeights.removeAll()
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
                    self?.tableview.reloadData()
                    self?.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)

        viewModel.updateItems.asObservable()
            .subscribe(onNext: { [weak self] items in
                if let p = items {
                    var paths = [IndexPath]()
                    for i in 0..<p.count {
                        let path = IndexPath(row: p.path.row + i, section: p.path.section)
                        paths.append(path)
                    }
                    self?.tableview.beginUpdates()
                    self?.tableview.reloadRows(at: paths,
                                               with: p.animated ?
                        UITableView.RowAnimation.automatic : UITableView.RowAnimation.none)
                    self?.tableview.endUpdates()
                }
            })
            .disposed(by: disposeBag)

        viewModel.scrollTo.asObservable()
            .subscribe(onNext: { [weak self] scroll in
                if let s = scroll {
                    DispatchQueue.main.async {
                        self?.tableview.scrollToRow(at: IndexPath(row: s.row, section: s.section),
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

        viewModel.busy.asObservable()
            .subscribe(onNext: { [weak self] busy in
                if busy {
                    self?.showBusyIndicator()
                } else {
                    self?.refreshControl.endRefreshing()
                    self?.hideBusyIndicator()
                }
            })
            .disposed(by: disposeBag)
    }

    @objc private func refreshData(_ sender: Any) {
        viewModel.refreshContents()
    }

    internal let refreshControl = UIRefreshControl()
    internal var cellHeights: [IndexPath : CGFloat] = [:]
    internal let disposeBag = DisposeBag()
}

extension BaseTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.modelsCount(for: section)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionsCount()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let hook = heightForFooterSizeHook {
            return hook(section)
        }
        return 20
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.title(for: section)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let hook = heightForHeaderSizeHook {
            return hook(section)
        }
        if section == 0 &&
            viewModel.title(for: section).count == 0 {
            return 0
        }
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let m = viewModel.model(for: indexPath) as! CellAnyModel
        return tableView.dequeueReusableCell(withModel: m, for: indexPath)
    }

    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }

    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? defaultEstimateHeight
    }
}

extension BaseTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let vm = viewModel as? CellOperationProtocol {
            let ops = vm.cellOperation(for: indexPath)
            if ops.contains(.delete) {
                return true
            }
        }
        return false
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if let vm = viewModel as? CellOperationProtocol {
            let ops = vm.cellOperation(for: indexPath)
            if ops.contains(.delete) && editingStyle == .delete {
                vm.deleteCell(at: indexPath)
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let v = headerViewGen?(section) {
            return v
        }
        if section == 0 &&
            viewModel.title(for: section).count == 0 {
            return viewWithClearBack()
        }
        let v = UIView()
        let text = viewModel.title(for: section)
        let label = UILabel()
        label.font = theme.boldFont.withSize(20)
        label.text = text
        label.textColor = theme.mainTextColor
        v.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        v.backgroundColor = theme.emptyBackColor
        v.addConstraints([label.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 40),
                          label.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: -20),
                          label.topAnchor.constraint(equalTo: v.topAnchor)])
        return v
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewWithClearBack()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.selected(indexPath: indexPath)
    }
}
