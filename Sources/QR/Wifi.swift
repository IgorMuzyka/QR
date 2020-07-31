
extension QRCode.Contents {

    public struct Wifi: Codable {

        public var ssid: String
        public var security: Security?
        public var isHidden: Bool

        public static func wifi(
            name: String,
            security: String = "",
            password: String = "",
            isHidden: Bool = false
        ) -> Wifi {
            Wifi(
                ssid: name,
                security: Security(
                    security: security,
                    password: password
                ),
                isHidden: isHidden
            )
        }
    }
}
