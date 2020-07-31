
extension QRCode {

    public enum ErrorCorrectionLevel: String, Codable {

        case lowest = "L"
        case medium = "M"
        case quality = "Q"
        case highest = "H"
    }
}
