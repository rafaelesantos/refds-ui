import SwiftUI

public struct CarrierLogo: View {
    
    struct SingleCarrierImage: View {
        
        let image: Image
        
        init(_ image: Image) {
            self.image = image
        }
        
        var body: some View {
            image
                .resizable()
                .cornerRadius(BorderRadius.desktop)
        }
    }
    
    let images: [Image]
    let size: Icon.Size
    
    public var body: some View {
        content
            .frame(width: size.value, height: size.value)
    }
    
    @ViewBuilder var content: some View {
        switch images.count {
            case 0:  EmptyView()
            case 1:  SingleCarrierImage(images[0])
            case 2:  twoImages
            case 3:  threeImages
            default: fourImages
        }
    }
    
    var twoImages: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                SingleCarrierImage(images[0])
                Color.clear
            }
            HStack(spacing: 0) {
                Color.clear
                SingleCarrierImage(images[1])
            }
        }
    }
    
    var threeImages: some View {
        VStack(spacing: 2) {
            HStack(spacing: 2) {
                SingleCarrierImage(images[0])
                SingleCarrierImage(images[2])
            }
            HStack(spacing: 2) {
                SingleCarrierImage(images[1])
                Color.clear
            }
        }
    }
    
    var fourImages: some View {
        VStack(spacing: 2) {
            HStack(spacing: 2) {
                SingleCarrierImage(images[0])
                SingleCarrierImage(images[2])
            }
            HStack(spacing: 2) {
                SingleCarrierImage(images[1])
                SingleCarrierImage(images[3])
            }
        }
    }
        
    public init(image: Image, size: Icon.Size) {
        self.images = [image]
        self.size = size
    }
        
    public init(images: [Image]) {
        self.images = images
        self.size = .large
    }
}

struct CarrierLogoPreviews: PreviewProvider {
    
    static let square = Image(systemName: "square.fill")
    static let plane1 = Image(systemName: "airplane.circle.fill")
    static let plane2 = Image(systemName: "paperplane.circle.fill")
    static let plane3 = Image(systemName: "airplane")
    
    static var previews: some View {
        PreviewWrapper {
            standalone
            content
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack {
            CarrierLogo(images: [square, plane1, plane2, plane3])
            CarrierLogo(images: []) // EmptyView
        }
    }

    @ViewBuilder static var content: some View {
        HStack(alignment: .top, spacing: .medium) {
            CarrierLogo(image: square, size: .small)
            CarrierLogo(image: square, size: .normal)
            CarrierLogo(image: square, size: .large)
        }
        .previewDisplayName("Sizes")

        HStack(alignment: .top, spacing: .medium) {
            CarrierLogo(image: plane1, size: .small)
            CarrierLogo(image: plane1, size: .normal)
            CarrierLogo(image: plane1, size: .large)
        }
        .previewDisplayName("Sizes")

        CarrierLogo(images: [square, square])
            .previewDisplayName("Two logos")

        CarrierLogo(images: [square, square, square])
            .previewDisplayName("Three logos")

        CarrierLogo(images: [square, square, square, square])
            .previewDisplayName("Four logos")
    }

    static var storybook: some View {
        VStack(alignment: .leading, spacing: .xxLarge) {
            content
        }
    }

    static var snapshot: some View {
        standalone
            .padding(.medium)
    }
}
