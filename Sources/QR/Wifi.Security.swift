
extension QRCode.Contents.Wifi {

    public struct Security: Codable {

        public var kind: String
        public var password: String

        public init?(security: String, password: String) {
            guard !security.isEmpty && !password.isEmpty else { return nil }
            self.kind = security
            self.password = password
        }
    }
}
