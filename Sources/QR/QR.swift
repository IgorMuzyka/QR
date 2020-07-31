
public struct QRCode: Codable {

    public var contents: Contents
    public var correction: ErrorCorrectionLevel

    public init(_ contents: Contents, correction: ErrorCorrectionLevel = .highest) {
        self.contents = contents
        self.correction = correction
    }
}

#if canImport(CoreImage)
import CoreImage.CIFilterBuiltins

public extension QRCode {

    var ciImage: CIImage? {
        let filter = CIFilter.qrCodeGenerator()
        let data = Data(contents.rawValue.utf8)
        filter.setValue(data, forKey: "inputMessage")
        filter.correctionLevel = correction.rawValue
        return filter.outputImage
    }
}
#endif

#if canImport(UIKit) && canImport(CoreImage)
import UIKit.UIImage

public extension QRCode {

    var image: UIImage {
        guard
            let output = ciImage,
            let cgImage = CIContext().createCGImage(output, from: output.extent)
            else { return UIImage(systemName: "xmark.circle") ?? UIImage() }
        return UIImage(cgImage: cgImage)
    }
}
#endif

import Foundation

public extension QRCode.Contents {

    init(rawValue: String) {
        self = .raw(rawValue)
    }

    var rawValue: String {
        switch self {
            case .raw(let raw): return raw
            case .url(let url): return url
            case .wifi(let wifi): return wifi.qrCodeContents
            case .phone(let phone): return "tel:" + phone
            case .email(let recipient, let subject, let cc, let bcc, let body):
                let email = "mailto:" + recipient
                var parameters = [(String, String)]()

                if let cc = cc?
                    .map({ $0.trimmingCharacters(in: .whitespaces) })
                    .joined(separator: ",")
                {
                    parameters += [("cc", cc)]
                }
                if let bcc = bcc?
                    .map({ $0.trimmingCharacters(in: .whitespaces) })
                    .joined(separator: ","),
                    !bcc.isEmpty
                {
                    parameters += [("bcc", bcc)]
                }
                if let subject = subject?
                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                {
                    parameters += [("subject", subject)]
                }
                if let body = body?
                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                {
                    parameters += [("body", body)]
                }

                guard !parameters.isEmpty else  { return email }
                return email + "?" + parameters
                    .map { key, value in key + "=" + value }
                    .joined()
            case .sms(let recipient, let message):
                guard let message = message?
                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    else { return "sms:" + recipient }
                return "sms:" + recipient + ":" + message
            case .geo(let latitude, let longitude, let altitude):
                return "geo:" + [
                    "\(latitude)",
                    "\(longitude)",
                    "\(altitude)",
                ].joined(separator: ",")
//            case .facetime(let phoneOrEmail, let isAudioOnly):
//                return "facetime"
//                    + (isAudioOnly ? "-audio" : "")
//                    + ":" + phoneOrEmail
        }
    }
}

fileprivate extension QRCode.Contents.Wifi {

    var qrCodeContents: String {
        func escape(_ string: String) -> String {
            let specialCharacters = [#"\"#, ";", ",", ":"]
            let escapeMeasure = specialCharacters.first!

            return specialCharacters.reduce(into: string) { result, character in
                result = result.replacingOccurrences(
                    of: character, with:
                    escapeMeasure + character
                )
            }
        }
        var parts = ["S:" + escape(ssid) + ";"]

        if let security = security {
            parts += [
                "T:" + escape(security.kind) + ";",
                "P:" + escape(security.password) + ";",
            ]
        }

        if isHidden {
            parts += ["H:" + "true" + ";"]
        }

        return "WIFI:" + parts.joined() + ";"
    }
}

