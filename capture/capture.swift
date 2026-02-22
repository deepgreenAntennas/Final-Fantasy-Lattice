//
//  capture.swift
//  capture
//
//  Created by Dr. Nathaniel Fox on 2/19/26.
//

import Foundation
import LockedCameraCapture
import SwiftUI

@main
struct capture: LockedCameraCaptureExtension {
    var body: some LockedCameraCaptureExtensionScene {
        LockedCameraCaptureUIScene { session in
            captureViewFinder(session: session)
        }
    }
}
