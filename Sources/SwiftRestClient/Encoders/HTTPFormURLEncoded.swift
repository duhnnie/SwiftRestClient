// From https://developer.apple.com/forums/thread/113632

import Foundation

public enum HTTPFormURLEncoded {

    static let contentType = "application/x-www-form-urlencoded"

    /// Encodings the key-values pairs in `application/x-www-form-urlencoded` format.
    ///
    /// The only specification for this encoding is the [Forms][spec] section of the
    /// *HTML 4.01 Specification*.  That leaves a lot to be desired.  For example:
    ///
    /// * The rules about what characters should be percent encoded are murky
    ///
    /// * It doesn't mention UTF-8, although many clients do use UTF-8
    ///
    /// [spec]: <http://www.w3.org/TR/html401/interact/forms.html#h-17.13.4>
    ///
    /// - parameter formDataSet: An array of key-values pairs
    ///
    /// - returns: The returning string.

    static func urlEncoded(formDataSet: [(String, String)]) -> String {
        return formDataSet.map { (key, value) in
            return escape(key) + "=" + escape(value)
        }.joined(separator: "&")
    }

    /// Returns a string escaped for `application/x-www-form-urlencoded` encoding.
    ///
    /// - parameter str: The string to encode.
    ///
    /// - returns: The encoded string.

    private static func escape(_ str: String) -> String {
        // Convert LF to CR LF, then
        // Percent encoding anything that's not allow (this implies UTF-8), then
        // Convert " " to "+".
        //
        // Note: We worry about `addingPercentEncoding(withAllowedCharacters:)` returning nil
        // because that can only happen if the string is malformed (specifically, if it somehow
        // managed to be UTF-16 encoded with surrogate problems) <rdar://problem/28470337>.
        return str.replacingOccurrences(of: "\n", with: "\r\n")
            .addingPercentEncoding(withAllowedCharacters: sAllowedCharacters)!
            .replacingOccurrences(of: " ", with: "+")
    }

    /// The characters that are don't need to be percent encoded in an `application/x-www-form-urlencoded` value.

    private static let sAllowedCharacters: CharacterSet = {
        // Start with `CharacterSet.urlQueryAllowed` then add " " (it's converted to "+" later)
        // and remove "+" (it has to be percent encoded to prevent a conflict with " ").
        var allowed = CharacterSet.urlQueryAllowed
        allowed.insert(" ")
        allowed.remove("+")
        allowed.remove("/")
        allowed.remove("?")
        allowed.remove("&")
        return allowed
    }()
}
