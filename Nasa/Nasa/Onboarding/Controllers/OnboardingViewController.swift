//
//  OnboardingViewController.swift
//  Nasa
//
//  Created by bahadir on 8.09.2021.
//

import UIKit
import SnapKit

protocol OnboardingViewControllerDelegate: AnyObject {
    func onboardingViewControllerDidTapNext(_ viewController: OnboardingViewController)
}

class OnboardingViewController: UIViewController {

    private let stackView = UIStackView()
    private var stackViewBottomConstraint: NSLayoutConstraint?
    private var skipButtonTopContraint: NSLayoutConstraint?
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let onboardingTitle: String
    private let onboardingSubtitle: String
    private let skipButton = UIButton()

    let contentView = UIView()

    weak var delegate: OnboardingViewControllerDelegate?

    init(title: String, subtitle: String) {
        self.onboardingTitle = title
        self.onboardingSubtitle = subtitle
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .nasaOrange

        setUpStackView()
        setUpTitleLabel()
        setUpSubtitleLabel()
        setUpContentView()
    }

    private func setUpStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 40
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.centerY.equalToSuperview().priority(.high)
        }

        stackViewBottomConstraint = view.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        stackViewBottomConstraint?.isActive = false
    }

    private func setUpTitleLabel() {
        titleLabel.text = onboardingTitle
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
        stackView.addArrangedSubview(titleLabel)
    }

    private func setUpSubtitleLabel() {
        subtitleLabel.text = onboardingSubtitle
        subtitleLabel.textColor = .white
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .systemFont(ofSize: 24, weight: .medium)
        stackView.addArrangedSubview(subtitleLabel)
    }

    private func setUpContentView() {
        stackView.addArrangedSubview(contentView)
    }

    func setUpSkipButton(target: Any?, action: Selector) {
        skipButton.setTitle("SKIP", for: .normal)
        skipButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        skipButton.titleLabel?.textColor = .white
        skipButton.addTarget(target, action: action, for: .touchUpInside)
        view.addSubview(skipButton)

        skipButton.snp.makeConstraints { make in
            make.topMargin.equalToSuperview().offset(32)
            make.rightMargin.equalToSuperview().offset(-32)
        }

        skipButtonTopContraint = view.topAnchor.constraint(equalTo: skipButton.topAnchor)
        skipButtonTopContraint?.isActive = false
    }

}
