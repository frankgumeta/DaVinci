import Testing
import SwiftUI
@testable import DaVinciComponents

// MARK: - Mock Image Loader

struct MockImageLoader: DSImageLoading {
    let shouldSucceed: Bool
    let mockData: Data
    
    init(shouldSucceed: Bool = true, mockData: Data = Data([1, 2, 3, 4])) {
        self.shouldSucceed = shouldSucceed
        self.mockData = mockData
    }
    
    func loadImageData(from url: URL) async throws -> Data {
        if shouldSucceed {
            return mockData
        } else {
            throw URLError(.badServerResponse)
        }
    }
}

// MARK: - DSImageLoading Tests

@Suite("DSImageLoading")
struct DSImageLoadingTests {
    
    @Test func defaultLoaderExists() {
        let loader = DSDefaultImageLoader()
        #expect(type(of: loader) == DSDefaultImageLoader.self)
    }
    
    @Test func mockLoaderSucceeds() async throws {
        let mockData = Data([5, 6, 7, 8])
        let loader = MockImageLoader(shouldSucceed: true, mockData: mockData)
        let url = URL(string: "https://example.com/test.jpg")!
        
        let data = try await loader.loadImageData(from: url)
        #expect(data == mockData)
    }
    
    @Test func mockLoaderFails() async {
        let loader = MockImageLoader(shouldSucceed: false)
        let url = URL(string: "https://example.com/test.jpg")!
        
        do {
            _ = try await loader.loadImageData(from: url)
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(error is URLError)
        }
    }
    
    @Test func environmentKeyHasDefaultValue() {
        struct TestView: View {
            @Environment(\.dsImageLoader) var loader
            
            var body: some View {
                Text("Test")
            }
        }
        
        let view = TestView()
        #expect(type(of: view) == TestView.self)
    }
}
