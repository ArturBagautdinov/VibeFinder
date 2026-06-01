import SwiftUI
import UIKit

struct MediaShareView: UIViewControllerRepresentable {
    let item: MediaItem

    func makeUIViewController(context: Context) -> MediaShareViewController {
        MediaShareViewController(item: item)
    }

    func updateUIViewController(_ uiViewController: MediaShareViewController, context: Context) {
        uiViewController.configure(with: item)
    }
}

final class MediaShareViewController: UIViewController {
    private var item: MediaItem
    private let titleLabel = UILabel()
    private let metadataLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let categoryIconView = UIImageView()
    private let categoryLabel = UILabel()
    private let copiedLabel = UILabel()

    init(item: MediaItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configure(with: item)
    }

    func configure(with item: MediaItem) {
        self.item = item
        titleLabel.text = item.title
        metadataLabel.text = "\(item.category.singularTitle) - \(item.genre) - \(item.year)"
        descriptionLabel.text = item.shortDescription
        categoryLabel.text = item.category.singularTitle
        categoryIconView.image = UIImage(systemName: item.category.iconName)
    }

    private func setupView() {
        view.backgroundColor = UIColor(AppTheme.background)

        let headerStack = UIStackView(arrangedSubviews: [headerTitleLabel(), closeButton()])
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.spacing = 12

        let previewCard = makePreviewCard()
        let copyButton = makeActionButton(title: "Copy", systemImage: "doc.on.doc", action: #selector(copyTapped))
        let shareButton = makePrimaryActionButton()

        copiedLabel.text = "Copied"
        copiedLabel.font = .preferredFont(forTextStyle: .footnote)
        copiedLabel.textColor = UIColor(AppTheme.accent)
        copiedLabel.alpha = 0

        let actionsStack = UIStackView(arrangedSubviews: [copyButton, shareButton])
        actionsStack.axis = .horizontal
        actionsStack.spacing = 10
        actionsStack.distribution = .fillEqually

        let contentStack = UIStackView(arrangedSubviews: [headerStack, previewCard, actionsStack, copiedLabel])
        contentStack.axis = .vertical
        contentStack.spacing = 18
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            contentStack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func headerTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = "Share recommendation"
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = UIColor(AppTheme.ink)
        return label
    }

    private func closeButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = UIColor(AppTheme.secondaryText)
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }

    private func makePreviewCard() -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor(AppTheme.surface)
        card.layer.cornerRadius = AppTheme.cornerRadius
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor(AppTheme.border).withAlphaComponent(0.35).cgColor
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.08
        card.layer.shadowRadius = 16
        card.layer.shadowOffset = CGSize(width: 0, height: 8)

        let iconContainer = UIView()
        iconContainer.backgroundColor = UIColor(AppTheme.accentSoft).withAlphaComponent(0.75)
        iconContainer.layer.cornerRadius = 22
        iconContainer.translatesAutoresizingMaskIntoConstraints = false

        categoryIconView.tintColor = UIColor(AppTheme.accent)
        categoryIconView.contentMode = .scaleAspectFit
        categoryIconView.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.addSubview(categoryIconView)

        categoryLabel.font = .preferredFont(forTextStyle: .caption1)
        categoryLabel.textColor = UIColor(AppTheme.accent)
        categoryLabel.textAlignment = .center

        titleLabel.font = .preferredFont(forTextStyle: .title3)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = UIColor(AppTheme.ink)
        titleLabel.numberOfLines = 2

        metadataLabel.font = .preferredFont(forTextStyle: .subheadline)
        metadataLabel.adjustsFontForContentSizeCategory = true
        metadataLabel.textColor = UIColor(AppTheme.secondaryText)
        metadataLabel.numberOfLines = 2

        descriptionLabel.font = .preferredFont(forTextStyle: .body)
        descriptionLabel.adjustsFontForContentSizeCategory = true
        descriptionLabel.textColor = UIColor(AppTheme.ink)
        descriptionLabel.numberOfLines = 4

        let iconStack = UIStackView(arrangedSubviews: [iconContainer, categoryLabel])
        iconStack.axis = .vertical
        iconStack.alignment = .center
        iconStack.spacing = 8

        let textStack = UIStackView(arrangedSubviews: [titleLabel, metadataLabel, descriptionLabel])
        textStack.axis = .vertical
        textStack.spacing = 8

        let contentStack = UIStackView(arrangedSubviews: [iconStack, textStack])
        contentStack.axis = .horizontal
        contentStack.alignment = .top
        contentStack.spacing = 14
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(contentStack)

        NSLayoutConstraint.activate([
            iconContainer.widthAnchor.constraint(equalToConstant: 64),
            iconContainer.heightAnchor.constraint(equalToConstant: 64),
            categoryIconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            categoryIconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            categoryIconView.widthAnchor.constraint(equalToConstant: 34),
            categoryIconView.heightAnchor.constraint(equalToConstant: 34),
            contentStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            contentStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            contentStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])

        return card
    }

    private func makeActionButton(title: String, systemImage: String, action: Selector) -> UIButton {
        var configuration = UIButton.Configuration.tinted()
        configuration.title = title
        configuration.image = UIImage(systemName: systemImage)
        configuration.imagePadding = 8
        configuration.baseForegroundColor = UIColor(AppTheme.accent)
        configuration.baseBackgroundColor = UIColor.gray
        configuration.cornerStyle = .large

        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func makePrimaryActionButton() -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Share"
        configuration.image = UIImage(systemName: "square.and.arrow.up")
        configuration.imagePadding = 8
        configuration.baseForegroundColor = UIColor(AppTheme.surface)
        configuration.baseBackgroundColor = UIColor(AppTheme.accent)
        configuration.cornerStyle = .large

        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        return button
    }

    @objc private func copyTapped() {
        UIPasteboard.general.string = shareText
        UIView.animate(withDuration: 0.2) {
            self.copiedLabel.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 1.2) {
                self.copiedLabel.alpha = 0
            }
        }
    }

    @objc private func shareTapped(_ sender: UIButton) {
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender
        activityViewController.popoverPresentationController?.sourceRect = sender.bounds
        present(activityViewController, animated: true)
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    private var shareText: String {
        """
        \(item.title) (\(item.year))
        \(item.category.singularTitle) - \(item.genre)

        \(item.shortDescription)
        """
    }
}

