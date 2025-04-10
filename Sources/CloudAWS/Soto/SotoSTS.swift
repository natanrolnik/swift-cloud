//===----------------------------------------------------------------------===//
//
// This source file is part of the Soto for AWS open source project
//
// Copyright (c) 2017-2024 the Soto project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of Soto project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import SotoCore

#if os(Linux) && compiler(<5.10)
    @preconcurrency import Foundation
#else
    import Foundation
#endif

/// Service object for interacting with AWS STS service.
///
/// Security Token Service Security Token Service (STS) enables you to request temporary, limited-privilege  credentials for users. This guide provides descriptions of the STS API. For  more information about using this service, see Temporary Security Credentials.
internal struct STS: AWSService {
    /// Client used for communication with AWS
    internal let client: AWSClient
    /// Service configuration
    internal let config: AWSServiceConfig

    /// Initialize the STS client
    /// - parameters:
    ///     - client: AWSClient used to process requests
    ///     - region: Region of server you want to communicate with. This will override the partition parameter.
    ///     - partition: AWS partition where service resides, standard (.aws), china (.awscn), government (.awsusgov).
    ///     - endpoint: Custom endpoint URL to use instead of standard AWS servers
    ///     - middleware: Middleware chain used to edit requests before they are sent and responses before they are decoded
    ///     - timeout: Timeout value for HTTP requests
    ///     - byteBufferAllocator: Allocator for ByteBuffers
    ///     - options: Service options
    internal init(
        client: AWSClient,
        region: SotoCore.Region? = nil,
        partition: AWSPartition = .aws,
        endpoint: String? = nil,
        middleware: AWSMiddlewareProtocol? = nil,
        timeout: TimeAmount? = nil,
        byteBufferAllocator: ByteBufferAllocator = ByteBufferAllocator(),
        options: AWSServiceConfig.Options = []
    ) {
        self.client = client
        self.config = AWSServiceConfig(
            region: region,
            partition: region?.partition ?? partition,
            serviceName: "STS",
            serviceIdentifier: "sts",
            serviceProtocol: .query,
            apiVersion: "2011-06-15",
            endpoint: endpoint,
            serviceEndpoints: Self.serviceEndpoints,
            partitionEndpoints: Self.partitionEndpoints,
            variantEndpoints: Self.variantEndpoints,
            errorType: STSErrorType.self,
            xmlNamespace: "https://sts.amazonaws.com/doc/2011-06-15/",
            middleware: middleware,
            timeout: timeout,
            byteBufferAllocator: byteBufferAllocator,
            options: options
        )
    }

    /// custom endpoints for regions
    static var serviceEndpoints: [String: String] {
        [
            "af-south-1": "sts.af-south-1.amazonaws.com",
            "ap-east-1": "sts.ap-east-1.amazonaws.com",
            "ap-northeast-1": "sts.ap-northeast-1.amazonaws.com",
            "ap-northeast-2": "sts.ap-northeast-2.amazonaws.com",
            "ap-northeast-3": "sts.ap-northeast-3.amazonaws.com",
            "ap-south-1": "sts.ap-south-1.amazonaws.com",
            "ap-south-2": "sts.ap-south-2.amazonaws.com",
            "ap-southeast-1": "sts.ap-southeast-1.amazonaws.com",
            "ap-southeast-2": "sts.ap-southeast-2.amazonaws.com",
            "ap-southeast-3": "sts.ap-southeast-3.amazonaws.com",
            "ap-southeast-4": "sts.ap-southeast-4.amazonaws.com",
            "ap-southeast-5": "sts.ap-southeast-5.amazonaws.com",
            "aws-global": "sts.amazonaws.com",
            "ca-central-1": "sts.ca-central-1.amazonaws.com",
            "ca-west-1": "sts.ca-west-1.amazonaws.com",
            "eu-central-1": "sts.eu-central-1.amazonaws.com",
            "eu-central-2": "sts.eu-central-2.amazonaws.com",
            "eu-north-1": "sts.eu-north-1.amazonaws.com",
            "eu-south-1": "sts.eu-south-1.amazonaws.com",
            "eu-south-2": "sts.eu-south-2.amazonaws.com",
            "eu-west-1": "sts.eu-west-1.amazonaws.com",
            "eu-west-2": "sts.eu-west-2.amazonaws.com",
            "eu-west-3": "sts.eu-west-3.amazonaws.com",
            "il-central-1": "sts.il-central-1.amazonaws.com",
            "me-central-1": "sts.me-central-1.amazonaws.com",
            "me-south-1": "sts.me-south-1.amazonaws.com",
            "sa-east-1": "sts.sa-east-1.amazonaws.com",
            "us-east-1": "sts.us-east-1.amazonaws.com",
            "us-east-2": "sts.us-east-2.amazonaws.com",
            "us-west-1": "sts.us-west-1.amazonaws.com",
            "us-west-2": "sts.us-west-2.amazonaws.com",
        ]
    }

    /// Default endpoint and region to use for each partition
    static var partitionEndpoints: [AWSPartition: (endpoint: String, region: SotoCore.Region)] {
        [
            .aws: (endpoint: "aws-global", region: .useast1)
        ]
    }

    /// FIPS and dualstack endpoints
    static var variantEndpoints: [EndpointVariantType: AWSServiceConfig.EndpointVariant] {
        [
            [.fips]: .init(endpoints: [
                "us-east-1": "sts-fips.us-east-1.amazonaws.com",
                "us-east-2": "sts-fips.us-east-2.amazonaws.com",
                "us-gov-east-1": "sts.us-gov-east-1.amazonaws.com",
                "us-gov-west-1": "sts.us-gov-west-1.amazonaws.com",
                "us-west-1": "sts-fips.us-west-1.amazonaws.com",
                "us-west-2": "sts-fips.us-west-2.amazonaws.com",
            ])
        ]
    }

    /// Returns details about the IAM user or role whose credentials are used to call the operation.  No permissions are required to perform this operation. If an administrator attaches a policy to your identity that explicitly denies access to the sts:GetCallerIdentity action, you can still perform this operation. Permissions are not required because the same information is returned when access is denied. To view an example response, see I Am Not Authorized to Perform: iam:DeleteVirtualMFADevice in the IAM User Guide.
    @Sendable
    @inlinable
    internal func getCallerIdentity(logger: Logger = AWSClient.loggingDisabled)
        async throws -> GetCallerIdentityResponse
    {
        try await self.client.execute(
            operation: "GetCallerIdentity",
            path: "/",
            httpMethod: .POST,
            serviceConfig: self.config,
            input: GetCallerIdentityRequest(),
            logger: logger
        )
    }
}

extension STS {
    /// Initializer required by `AWSService.with(middlewares:timeout:byteBufferAllocator:options)`. You are not able to use this initializer directly as there are not public
    /// initializers for `AWSServiceConfig.Patch`. Please use `AWSService.with(middlewares:timeout:byteBufferAllocator:options)` instead.
    internal init(from: STS, patch: AWSServiceConfig.Patch) {
        self.client = from.client
        self.config = from.config.with(patch: patch)
    }
}
