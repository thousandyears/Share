#if os(macOS)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

public protocol Sharable {
    var shareItems: [Any] { get }
}

public protocol ShareDelegate {
    func didChange(status: Share.Service.Status)
}

public struct Share { }

extension Share {
    #if os(macOS)
    public typealias Service = NSSharingService
    #elseif os(iOS)
    public typealias Service = UIActivity.ActivityType
    #endif
}

extension Share.Service {
    public enum Status {
        case willShare([Any], via: Share.Service)
        case didShare([Any], via: Share.Service)
        case error(Share.Service.Status.Error, sharing:[Any])
    }
}

extension Share.Service.Status {
    public enum Error {
        case cancelled(Share.Service?)
        case other(Swift.Error, with: Share.Service?)
        
        var service: Share.Service? {
            switch self {
                case .cancelled(let service): return service
                case .other(_, with: let service): return service
            }
        }
    }
}

extension Sharable {
    public func shareSheet(delegate: ShareDelegate? = nil) -> Share.Sheet {
        return Share.Sheet(for: self, delegate: delegate)
    }
}
