#if os(macOS)
import Cocoa

extension Share {
    public class Sheet: NSSharingServicePicker, NSSharingServicePickerDelegate, NSSharingServiceDelegate {
        let sharable: Sharable
        let serviceDelegate: ShareDelegate?
        
        private override init(items: [Any]) { fatalError("This is private") }
        
        public init(for sharable: Sharable, delegate: ShareDelegate? = nil) {
            self.sharable = sharable
            serviceDelegate = delegate
            super.init(items: sharable.shareItems)
        }
        
        // MARK:- NSSharingServicePickerDelegate
        public func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, didChoose service: NSSharingService?) {
            guard service == nil
                else { return }
            
            serviceDelegate?.didChange(status: .error(.cancelled(service), sharing: sharable.shareItems))
        }
        
        public func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, delegateFor sharingService: NSSharingService) -> NSSharingServiceDelegate? {
            return self
        }
        
        // MARK:- NSSharingServiceDelegate
        
        public func sharingService(_ sharingService: NSSharingService, willShareItems items: [Any]) {
            serviceDelegate?.didChange(status: .willShare(items, via: sharingService))
        }
        
        public func sharingService(_ sharingService: NSSharingService, didShareItems items: [Any]) {
            serviceDelegate?.didChange(status: .didShare(items, via: sharingService))
        }
        
        public func sharingService(_ sharingService: NSSharingService, didFailToShareItems items: [Any], error: Error) {
            serviceDelegate?.didChange(status: .error(.other(error, with: sharingService), sharing: items))
        }
    }
}
#endif

#if os(iOS)
import UIKit

extension Share {
    public class Sheet: UIActivityViewController {
        let sharable: Sharable
        let serviceDelegate: ShareDelegate?
        
        public init(for sharable: Sharable, delegate: ShareDelegate? = nil) {
            self.sharable = sharable
            serviceDelegate = delegate
            
            super.init(activityItems: sharable.shareItems, applicationActivities: nil)
            
            completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems:[Any]?, error: Error?) in
                guard let service = activityType
                    else { self.report(error: .cancelled(activityType)); return }
                
                if let error = error {
                    self.report(error: .other(error, with: service)); return
                }
                
                if !completed {
                    self.report(.willShare(sharable.shareItems, via: service))
                } else {
                    self.report(.didShare(sharable.shareItems, via: service))
                }
            }
        }
        
        private func report(_ status: Share.Service.Status) {
            serviceDelegate?.didChange(status: status)
        }
        
        private func report(error: Share.Service.Status.Error) {
            serviceDelegate?.didChange(status: .error(error, sharing: sharable.shareItems))
        }
    }
}
#endif
