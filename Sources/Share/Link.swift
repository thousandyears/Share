#if canImport(UIKit)

@_exported import LinkPresentation

extension Share {
    
    @available(iOS 13.0, *)
    public class Link: NSObject, UIActivityItemSource {
        public let url: URL
        public let placeholder: Any
        
        public var title: String? = nil
        public var icon: URL? = nil
        public var image: URL? = nil
        public var video: URL? = nil
        
        public typealias ShareValue = (_ link: Link, _ activityType: UIActivity.ActivityType?) -> Any
        private let shareValue: ShareValue?
        
        public func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
            let metadata = LPLinkMetadata()
            
            metadata.title = title
            metadata.originalURL = url
            
            if let url = icon {
                metadata.iconProvider = NSItemProvider(contentsOf: url)
            }
            
            if let url = image {
                metadata.imageProvider = NSItemProvider(contentsOf: url)
            }
            
            if let url = video, let scheme = url.scheme {
                if scheme.hasPrefix("http") {
                    metadata.remoteVideoURL = url
                } else {
                    metadata.videoProvider = NSItemProvider(contentsOf: url)
                }
            }
            
            return metadata
        }
        
        public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
            return placeholder
        }
        
        public func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
            
            return shareValue?(self, activityType) ?? url
        }
        
        public init(url: URL, placeholder: Any = "", shareValue: ShareValue? = nil) {
            self.url = url
            self.placeholder = placeholder
            self.shareValue = shareValue
        }
        
        public func title(_ title: String) -> Link {
            self.title = title
            return self
        }
        
        public func icon(_ url: URL) -> Link {
            icon = url
            return self
        }
        
        public func image(_ url: URL) -> Link {
            self.image = url
            return self
        }

        public func video(_ url: URL) -> Link {
            self.video = url
            return self
        }
    }
}

#endif
