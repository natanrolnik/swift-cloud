import CloudCore

public protocol FastlyProject: Project {}

extension FastlyProject {
    public var providers: [Provider] {
        [.fastly()]
    }
}
