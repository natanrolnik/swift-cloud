extension AWS {
    public struct Email {
        private let domain: String
        private init(domain: String) {
            self.domain = domain
        }

        public static func preconfigured(domain: String) -> Email {
            Email(domain: domain)
        }
    }
}

extension AWS.Email: Linkable {
    public var name: Output<String> {
        "SES-\(domain)"
    }

    public var actions: [String] {
        [
            // Sending email
            "ses:SendEmail",
            "ses:SendRawEmail",
            "ses:SendTemplatedEmail",
            "ses:SendBulkTemplatedEmail",

            // Templates
            "ses:CreateTemplate",
            "ses:DeleteTemplate",
            "ses:ListTemplates",
            "ses:GetTemplate",
            "ses:GetTemplate",
        ]
    }

    public var condition: [String: AnyEncodable] {
        [
            "StringLike": [
                "ses:FromAddress": "*@\(domain)"
            ]
        ]
    }

    public var resources: [Output<String>] {
        ["*"]
    }

    public var environmentVariables: [String : any CustomStringConvertible] {
        [:]
    }
}
