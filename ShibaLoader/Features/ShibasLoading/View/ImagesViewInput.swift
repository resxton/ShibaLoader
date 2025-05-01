import Foundation

protocol ImagesViewInput: AnyObject {
    func setLoaderVisible(_ isVisible: Bool)
    func presentAlert(title: String, message: String?)
    func setImages(from dataArray: [Data])
}
