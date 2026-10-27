import AppKit
import ImageIO
import UniformTypeIdentifiers

enum ConversionError: LocalizedError {
    case unsupportedInput
    case destinationUnavailable
    case decodeFailed
    case encodeFailed

    var errorDescription: String? {
        switch self {
        case .unsupportedInput: return "This file type is not supported yet."
        case .destinationUnavailable: return "A destination could not be created."
        case .decodeFailed: return "The image could not be decoded."
        case .encodeFailed: return "The converted image could not be written."
        }
    }
}

struct ConversionService {
    static let inputExtensions = ["jpg", "jpeg", "png", "heic", "tif", "tiff", "bmp", "gif"]
    static let outputExtensions = ["png", "jpg", "tiff", "heic"]

    static func suggestedExtensions(for url: URL) -> [String] {
        guard inputExtensions.contains(url.pathExtension.lowercased()) else { return [] }
        return outputExtensions.filter { $0 != normalizedExtension(url.pathExtension) }
    }

    static func normalizedExtension(_ value: String) -> String {
        switch value.lowercased() {
        case "jpeg": return "jpg"
        case "tif": return "tiff"
        default: return value.lowercased()
        }
    }

    func convert(_ sourceURL: URL, to outputExtension: String) throws -> URL {
        guard let destinationType = type(for: outputExtension) else {
            throw ConversionError.unsupportedInput
        }
        guard let source = CGImageSourceCreateWithURL(sourceURL as CFURL, nil),
              let image = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
            throw ConversionError.decodeFailed
        }

        let outputURL = availableOutputURL(beside: sourceURL, extension: outputExtension)
        guard let destination = CGImageDestinationCreateWithURL(
            outputURL as CFURL,
            destinationType.identifier as CFString,
            1,
            nil
        ) else { throw ConversionError.destinationUnavailable }

        let properties: [CFString: Any] = outputExtension == "jpg"
            ? [kCGImageDestinationLossyCompressionQuality: 0.9]
            : [:]
        CGImageDestinationAddImage(destination, image, properties as CFDictionary)
        guard CGImageDestinationFinalize(destination) else {
            throw ConversionError.encodeFailed
        }
        return outputURL
    }

    private func type(for ext: String) -> UTType? {
        switch ext.lowercased() {
        case "png": return .png
        case "jpg", "jpeg": return .jpeg
        case "tiff", "tif": return .tiff
        case "heic": return .heic
        default: return nil
        }
    }

    private func availableOutputURL(beside source: URL, extension ext: String) -> URL {
        let directory = source.deletingLastPathComponent()
        let stem = source.deletingPathExtension().lastPathComponent
        var candidate = directory.appendingPathComponent("\(stem)-converted.\(ext)")
        var suffix = 2
        while FileManager.default.fileExists(atPath: candidate.path) {
            candidate = directory.appendingPathComponent("\(stem)-converted-\(suffix).\(ext)")
            suffix += 1
        }
        return candidate
    }
}
