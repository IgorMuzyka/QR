
extension QRCode {
    /// [Reference 1](https://github.com/zxing/zxing/wiki/Barcode-Contents)
    /// [Reference 2](https://stackoverflow.com/questions/19900835/qr-code-possible-data-types-or-standards/26738158#26738158)
    public enum Contents: RawRepresentable, Codable, ExpressibleByStringLiteral {

        case raw(String)
        case wifi(Wifi)
        case url(String)
        case phone(String)
        case sms(
            to: String,
            message: String? = .none
        )
        case email(
            to: String,
            subject: String? = .none,
            cc: [String]? = .none,
            bcc: [String]? = .none,
            body: String? = .none
        )
        case geo(latitude: Double, longitude: Double, altitude: Double = 0)
//        case event(
//            summary: String
//        )
//        case mecard
//        case bizcard
//        case vCard
//        case facetime(phoneOrEmail: String, audioOnly: Bool = false)–

        public init(stringLiteral value: String) {
            self = .raw(value)
        }
    }
}
