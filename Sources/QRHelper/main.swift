
import Foundation
import ArgumentParser
import QR
import CoreImage

struct GenerateQRCode: ParsableCommand {

    static var configuration = CommandConfiguration(
        abstract: "generate qr code"
    )

    @Argument(help: "qr code value")
    var code: String = ""

    @Argument(help: "pixel width/height")
    var width: Double = 64

    func run() throws {
        guard !code.isEmpty else {
            print("please supply raw qr code data")
            Darwin.exit(1)
        }

        let path = [
            "file://",
            FileManager.default.currentDirectoryPath,
            "/",
            UUID().uuidString,
            ".jpeg",
        ].joined()

        guard
            let image = QRCode(.raw(code)).ciImage,
            let colorSpace = image.colorSpace,
            let url = URL(string: path)
            else { return }

        let transform = CGAffineTransform(
            scaleX: CGFloat(width),
            y: CGFloat(width)
        )

        try CIContext()
            .writeJPEGRepresentation(
                of: image.transformed(
                    by: transform,
                    highQualityDownsample: true
                ),
                to: url,
                colorSpace: colorSpace,
                options: [:]
        )

        print(url.lastPathComponent)
    }
}

GenerateQRCode.main()
