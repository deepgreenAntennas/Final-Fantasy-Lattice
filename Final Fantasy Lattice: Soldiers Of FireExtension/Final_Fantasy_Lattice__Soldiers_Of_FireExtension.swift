//
//  Final_Fantasy_Lattice__Soldiers_Of_FireExtension.swift
//  Final Fantasy Lattice: Soldiers Of FireExtension
//
//  Created by Dr. Nathaniel Fox on 2/19/26.
//

import Foundation
import ContactProvider

@main
class Final_Fantasy_Lattice__Soldiers_Of_FireExtension: ContactProviderExtension {
    private let rootContainerEnumerator: Final_Fantasy_Lattice__Soldiers_Of_FireExtensionRootContainerEnumerator

    required init() {
        // Initialize your extension here.
        rootContainerEnumerator = Final_Fantasy_Lattice__Soldiers_Of_FireExtensionRootContainerEnumerator()
    }

    func configure(for domain: ContactProviderDomain) {
        // Configure your extension here.
        rootContainerEnumerator.configure(for: domain)
    }

    func enumerator(for collection: ContactItem.Identifier) -> ContactItemEnumerator {
        return rootContainerEnumerator
    }

    func invalidate() async throws {
        // TODO: Stop any enumeration and cleanup as the extension will be terminated.
    }
}
