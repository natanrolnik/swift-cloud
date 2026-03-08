extension AWS {
    public struct CodeBucket: AWSResourceProvider {
        public let resource: Resource

        public var bucket: Output<String> {
            output.keyPath("bucket")
        }

        public init(
            _ name: String,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            resource = Resource(
                name: name,
                type: "aws:s3:BucketV2",
                properties: [
                    "forceDestroy": true
                ],
                options: options,
                context: context
            )
        }
    }
}

extension AWS.CodeBucket {
    public static func shared(options: Resource.Options? = nil) -> Self {
        let suffix = options?.provider.map { $0.resource.chosenName } ?? ""
        return AWS.CodeBucket(
            "shared-code-bucket-\(suffix)",
            options: .provider(options?.provider)
        )
    }
}
