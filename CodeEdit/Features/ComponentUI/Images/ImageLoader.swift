//
//  ImageLoader.swift
//  MathLateX
//
//  Created by christian on 05/06/24.
//

import Combine
import SwiftUI

    /** Class  ImageLoader **/
class ImageLoader: ObservableObject {
  @Published var image: NSImage?

  private(set) var isLoading = false

  private let url: URL
  private var cache: ImageCache?
  private var cancellable: AnyCancellable?

  private static let imageProcessingQueue = DispatchQueue(label: "image-processing")

  init(url: URL, cache: ImageCache? = nil) {
    self.url = url
    self.cache = cache
  }

  deinit {
    cancel()
  }
        /// Description
  func load() {
    guard !isLoading else { return }

    if let image = cache?[url] {
      self.image = image
      return
    }

    cancellable = URLSession.shared.dataTaskPublisher(for: url)
      .map { NSImage(data: $0.data) }
      .replaceError(with: nil)
      .handleEvents(
        receiveSubscription: { [weak self] _ in self?.onStart() },
        receiveOutput: { [weak self] in self?.cache($0) },
        receiveCompletion: { [weak self] _ in self?.onFinish() },
        receiveCancel: { [weak self] in self?.onFinish() }
      )
      .subscribe(on: Self.imageProcessingQueue)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in self?.image = $0 }
  }
        /// Description
  func cancel() {
    cancellable?.cancel()
  }
        /// Description
  private func onStart() {
    isLoading = true
  }
        /// Description
  private func onFinish() {
    isLoading = false
  }
        /// <#Description#>
        /// - Parameter image: <#image description#>
  private func cache(_ image: NSImage?) {
    image.map { cache?[url] = $0 }
  }
}
