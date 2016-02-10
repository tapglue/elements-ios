import Tapglue

public class ReplaceMe {
    let sampleToken = "1ecd50ce4700e0c8f501dee1fb271344"
    public init() {
        print("im being constructed!")
        let tgConfig = TGConfiguration.defaultConfiguration()
        tgConfig.loggingEnabled = true
        Tapglue.setUpWithAppToken(sampleToken, andConfig: tgConfig)
    }
}