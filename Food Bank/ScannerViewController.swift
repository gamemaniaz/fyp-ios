//
//  ScannerViewController.swift
//  Food Bank
//
//  Created by Louis Lim Ying Wei on 17/3/18.
//  Copyright © 2018 Louis Lim Ying Wei. All rights reserved.
//

import UIKit
import BarcodeScanner

class ScannerViewController: UIViewController {
    
    var message = "Place the barcode within the window to scan. The search will start automatically"

    override func viewDidAppear(_ animated: Bool) {
        let scannerController = makeBarcodeScannerViewController()
        scannerController.title = "Barcode Scanner"
        scannerController.messageViewController.messages.scanningText = message
        scannerController.headerViewController.closeButton.setTitle("Done", for: .normal)
        present(scannerController, animated: false, completion: nil)
    }
    
    private func makeBarcodeScannerViewController() -> BarcodeScannerViewController {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        return viewController
    }

}

// MARK: - BarcodeScannerCodeDelegate
extension ScannerViewController: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        UserDefaults.standard.set(code, forKey: "barcode")
        controller.messageViewController.messages.scanningText = "If the barcode (" + code + ") is not correct, please continue scanning."
        controller.messageViewController.messages.processingText = "Please confirm the barcode (" + code + ") and click on 'Done' at the top left once confirmed. If incorrect, please wait 3 seconds to scan again."
        controller.messageViewController.messages.notFoundText = "Please confirm the barcode (" + code + ") and click on 'Done' at the top left once confirmed. If incorrect, please wait 3 seconds to scan again."
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            controller.reset(animated: true)
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            controller.resetWithError()
        }
    }
}

// MARK: - BarcodeScannerErrorDelegate
extension ScannerViewController: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
}

// MARK: - BarcodeScannerDismissalDelegate
extension ScannerViewController: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        tabBarController?.selectedIndex = 2
        controller.dismiss(animated: true, completion: nil)
    }
}
