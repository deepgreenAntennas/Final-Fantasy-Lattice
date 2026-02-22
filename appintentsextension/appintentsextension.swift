//
//  appintentsextension.swift
//  appintentsextension
//
//  Created by Dr. Nathaniel Fox on 2/19/26.
//

import AppIntents

struct appintentsextension: AppIntent {
    static var title: LocalizedStringResource { "appintentsextension" }
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
