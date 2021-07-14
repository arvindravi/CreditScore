//
//  CreditInformationViewController.swift
//  CreditScore
//
//  Created by Arvind Ravi on 07/07/2021.
//

import UIKit
import CreditKit

final class CreditInformationViewController: UIViewController {
    
    // MARK: - Custom Types -
    
    enum Section {
        case main
    }
    
    enum ListItem: Hashable {
        case personaType(String)
        case creditReportInfoHeader(String)
        case score(Int)
        case scoreBand(Int)
        case status(String)
        
        var title: String {
            switch self {
            case .personaType: return "Persona Type"
            case .creditReportInfoHeader: return "Credit Report Information"
            case .score: return "Credit Score"
            case .scoreBand: return "Score Band"
            case .status: return "Status"
            }
        }
        
        var description: String {
            switch self {
            case let .personaType(value),
                 let .creditReportInfoHeader(value),
                 let .status(value): return value
            case let .score(value),
                 let .scoreBand(value): return "\(value)"
            }
        }
        
        var requiresDisclosureIndicator: Bool {
            switch self {
            case .creditReportInfoHeader: return true
            default: return false
            }
        }
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ListItem>
    typealias CreditInformationCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ListItem>
    typealias CreditInformationDetailCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ListItem>
    
    // MARK: - Properties -
    
    private lazy var dataSource: DataSource = collectionViewDataSource()
    private lazy var collectionView: UICollectionView = collectionViewComponent()
    private lazy var cellRegistration: CreditInformationCellRegistration = collectionViewCellRegistration()
    private lazy var detailCellRegistration: CreditInformationDetailCellRegistration = collectionViewDetailCellRegistration()
    private let creditInformation: CreditInformationRawResponse
    
    // MARK: - Intialiser -
    
    init(creditInformation: CreditInformationRawResponse) {
        self.creditInformation = creditInformation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViews()
        loadListItems()
    }
    
    // MARK: Private
    
    private func setup() {
        title = creditInformation.creditReportInfo.clientRef
        view.backgroundColor = .systemBackground
    }
    
    private func setupViews() {
        configureCollectionView()
        configureCollectionViewDataSource()
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    private func configureCollectionViewDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ListItem>()
        snapshot.appendSections([.main])
    }
    
    private func loadListItems() {
        var snapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
        let personaType = ListItem.personaType(creditInformation.personaType)
        
        snapshot.append([
            personaType
        ])
        
        let creditReportInfoHeader = ListItem.creditReportInfoHeader("")
        let creditReportInfoItems = [
            ListItem.score(creditInformation.creditReportInfo.score),
            ListItem.scoreBand(creditInformation.creditReportInfo.scoreBand),
            ListItem.status(creditInformation.creditReportInfo.status)
        ]
        
        snapshot.append([creditReportInfoHeader])
        snapshot.append(creditReportInfoItems, to: creditReportInfoHeader)
        
        dataSource.apply(snapshot, to: .main)
    }
}

extension CreditInformationViewController {
    private func collectionViewComponent() -> UICollectionView {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.layer.cornerRadius = 18
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }
    
    private func collectionViewDataSource() -> DataSource {
        UICollectionViewDiffableDataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath, listItem) -> UICollectionViewCell? in
            switch listItem {
            case .score, .scoreBand, .status:
                return collectionView.dequeueConfiguredReusableCell(using: self.detailCellRegistration, for: indexPath, item: listItem)
            default:
                return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: listItem)
            }
        }
    }
    
    private func collectionViewCellRegistration() -> CreditInformationCellRegistration {
        UICollectionView.CellRegistration { (cell: UICollectionViewListCell, indexPath, item) in
            var content = UIListContentConfiguration.valueCell()
            content.text = item.title
            content.secondaryText = item.description
            content.prefersSideBySideTextAndSecondaryText = true
            cell.contentConfiguration = content
            let headerOutlineDisclosure = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = item.requiresDisclosureIndicator ? [.outlineDisclosure(options: headerOutlineDisclosure)] : []
        }
    }
    
    private func collectionViewDetailCellRegistration() -> CreditInformationDetailCellRegistration {
        UICollectionView.CellRegistration { (cell: UICollectionViewListCell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            content.secondaryText = item.description
            content.prefersSideBySideTextAndSecondaryText = true
            cell.contentConfiguration = content
        }
    }
}
