//
//  CreditKit+Stub.swift
//  CreditScoreTests
//
//  Created by Arvind Ravi on 07/07/2021.
//

import CreditKit

private final class StubCreditKit: CreditKitType {
    func fetchCreditInformation(result: @escaping CreditKit.CreditInformationResult) {
        // no-op
    }
}

extension CreditKit {
    static var stub: CreditKitType = StubCreditKit()
}
