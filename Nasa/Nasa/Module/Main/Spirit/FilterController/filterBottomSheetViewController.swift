//
//  CustomModalVC.swift
//  Nasa
//
//  Created by bahadir on 12.09.2021.
//

import UIKit
import SnapKit

protocol FilterViewControllerDelegate {
    func didUpdateFilter(index: Int)
}

final class filterBottomSheetViewController: UIViewController {
    
    private var tableView: UITableView!
    var delegate: FilterViewControllerDelegate!
    private var currentFilter: Int = 0
    
    // Haptics
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    // define lazy views
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Style.Text.Label.cameras
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle(Constants.Style.Text.Label.filter,
                        for: .normal)
        button.layer.cornerRadius = 20
        button.layer.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return button
    }()
    
    lazy var buildStackView: UIStackView = {
      let stackView = UIStackView(arrangedSubviews: [filterButton, tableView])
        stackView.axis = .vertical
        stackView.spacing = 8.0
        return stackView
    }()
    
    lazy var contentStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [titleLabel, buildStackView, spacer])
        stackView.axis = .vertical
        stackView.spacing = 8.0
        return stackView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    let maxDimmedAlpha: CGFloat = 0.6
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    // Constants
    let defaultHeight: CGFloat = 350
    let dismissibleHeight: CGFloat = 200
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    var currentContainerHeight: CGFloat = 300
    
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    
    private func configureTableView(){
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
    }
    
    private func configureFilterButton(){
        view.addSubview(filterButton)
        
        filterButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(240)
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-26)
        }

        filterButton.addTarget(self, action: #selector(filterButtonAction), for: .touchUpInside)
    }
    
    @objc
    private func filterButtonAction() {
        feedbackGenerator.impactOccurred()
        delegate.didUpdateFilter(index: currentFilter)
        animateDismissView()
    }
    
    @objc
    private func handleCloseAction() {
        animateDismissView()
    }
    
    private func setupView() {
        configureTableView()
        configureFilterButton()
        view.backgroundColor = .clear
        
        setupConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
        
        setupPanGesture()
    }
    
    private func setupConstraints() {
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        containerView.addSubview(contentStackView)

        dimmedView.snp.makeConstraints { make in
            make.bottom.top.leading.trailing.equalTo(view)
        }
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(containerView).inset(20)
            make.top.equalTo(containerView).offset(10)
            make.bottom.equalTo(containerView).offset(0)
        }
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                              constant: defaultHeight)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
//  MARK: - Pan gesture handler
    @objc
    private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown = translation.y > 0
        let newHeight = currentContainerHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < maximumContainerHeight {
                containerViewHeightConstraint?.constant = newHeight
                view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            }
            else if newHeight < defaultHeight {
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                animateContainerHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }
    
    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        currentContainerHeight = height
    }
    
//  MARK: - Present and dismiss animation
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    private func animateDismissView() {
        // hide blur view
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        }
    }
    
    private func configureCell(cell: UITableViewCell, indexPath: IndexPath) -> UITableViewCell {
        cell.contentView.backgroundColor = .white
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.frame = cell.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        cell.textLabel?.text = Filter.spirit.cameras()[indexPath.row].rawValue
        cell.backgroundColor = .white
        cell.textLabel?.textColor = .black
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension filterBottomSheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        feedbackGenerator.impactOccurred()
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        currentFilter = indexPath.item
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}

// MARK: - UITableViewDataSource
extension filterBottomSheetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Filter.spirit.cameras().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        return configureCell(cell: cell, indexPath: indexPath)
    }
}
