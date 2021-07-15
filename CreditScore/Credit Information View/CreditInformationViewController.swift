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
        case dashboardStatus(String)
        case creditReportInfoHeader(String)
        case score(Int)
        case scoreBand(Int)
        case status(String)
        case hasEverDefaulted(Bool)
        case hasEverBeenDeliquent(Bool)
        case percentageCreditUsed(Int)
        case changedScore(Int)
        case currentShortTermDebt(Int)
        case currentLongTermDebt(Int)
        case equifaxScoreBand(Int)
        case equifaxScoreBandDescription(String)
        case daysUntilNextReport(Int)
        
        var title: String {
            switch self {
            case .personaType: return "Persona Type"
            case .dashboardStatus: return "Dashboard Status"
            case .creditReportInfoHeader: return "Credit Report Information"
            case .score: return "Credit Score"
            case .scoreBand: return "Score Band"
            case .status: return "Status"
            case .hasEverDefaulted: return "Has Defaulted?"
            case .hasEverBeenDeliquent: return "Has Been Deliquent?"
            case .percentageCreditUsed: return "Percentage Credit Used"
            case .changedScore: return "Changed Score"
            case .currentShortTermDebt: return "Current Short Term Debt"
            case .currentLongTermDebt: return "Current Long Term Debt"
            case .equifaxScoreBand: return "Equifax Score Band"
            case .equifaxScoreBandDescription: return "Equifax Score Band Desc."
            case .daysUntilNextReport: return "Days Until Next Report"
            }
        }
        
        var description: String {
            switch self {
            case let .personaType(value),
                 let .dashboardStatus(value),
                 let .creditReportInfoHeader(value),
                 let .status(value),
                 let .equifaxScoreBandDescription(value): return value
            case let .score(value),
                 let .scoreBand(value),
                 let .percentageCreditUsed(value),
                 let .changedScore(value),
                 let .currentShortTermDebt(value),
                 let .currentLongTermDebt(value),
                 let .equifaxScoreBand(value),
                 let .daysUntilNextReport(value): return "\(value)"
            case let .hasEverDefaulted(value),
                 let .hasEverBeenDeliquent(value): return value ? "Yes" : "No"
                
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadListItems()
    }
    
    // MARK: Private
    
    private func setup() {
        title = creditInformation.creditReportInfo.clientRef.dropLast(5).uppercased()
        view.backgroundColor = .systemBackground
        view.accessibilityIdentifier = "CreditInformationViewController"
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
        let dashboardStatus = ListItem.dashboardStatus(creditInformation.dashboardStatus)
        
        snapshot.append([
            personaType,
            dashboardStatus
        ])
        
        let creditReportInfoHeader = ListItem.creditReportInfoHeader("")
        let creditReportInfoItems = [
            ListItem.score(creditInformation.creditReportInfo.score),
            ListItem.scoreBand(creditInformation.creditReportInfo.scoreBand),
            ListItem.status(creditInformation.creditReportInfo.status),
            ListItem.hasEverDefaulted(creditInformation.creditReportInfo.hasEverDefaulted),
            ListItem.hasEverBeenDeliquent(creditInformation.creditReportInfo.hasEverBeenDelinquent),
            ListItem.percentageCreditUsed(creditInformation.creditReportInfo.percentageCreditUsed),
            ListItem.changedScore(creditInformation.creditReportInfo.changedScore),
            ListItem.currentShortTermDebt(creditInformation.creditReportInfo.currentShortTermDebt),
            ListItem.currentLongTermDebt(creditInformation.creditReportInfo.currentLongTermDebt),
            ListItem.equifaxScoreBand(creditInformation.creditReportInfo.equifaxScoreBand),
            ListItem.equifaxScoreBandDescription(creditInformation.creditReportInfo.equifaxScoreBandDescription),
            ListItem.daysUntilNextReport(creditInformation.creditReportInfo.daysUntilNextReport)
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
        collectionView.backgroundColor = view.backgroundColor
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.layer.cornerRadius = 18
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = .init(top: 10, left: 0, bottom: 0, right: 0)
        collectionView.accessibilityIdentifier = "CreditInformationCollectionView"
        return collectionView
    }
    
    private func collectionViewDataSource() -> DataSource {
        UICollectionViewDiffableDataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath, listItem) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: listItem)
        }
    }
    
    private func collectionViewCellRegistration() -> CreditInformationCellRegistration {
        UICollectionView.CellRegistration { (cell: UICollectionViewListCell, indexPath, item) in
            var content = UIListContentConfiguration.valueCell()
            content.text = item.title
            content.secondaryText = item.description
            content.secondaryTextProperties.color = .systemGreen
            content.prefersSideBySideTextAndSecondaryText = true
            cell.contentConfiguration = content
            let headerOutlineDisclosure = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = item.requiresDisclosureIndicator ? [.outlineDisclosure(options: headerOutlineDisclosure)] : []
        }
    }
}
