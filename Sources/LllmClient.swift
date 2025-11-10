import Foundation

struct LLMRequest: Codable {
    struct Options: Codable {
        let temperature: Double
    }

    let model: String
    let options: Options
    let stream: Bool
    let prompt: String

    init(model: String, temperature: Double, stream: Bool = false, prompt: String) {
        self.model = model
        self.options = Options(temperature: temperature)
        self.stream = stream
        self.prompt = prompt
    }
}

struct LLMResponse: Codable {
    let response: String?
    let error: String?
}

class LLMClient {
    enum LLMClientError: LocalizedError {
        case missingConfiguration
        case invalidConfiguration(String)

        var errorDescription: String? {
            switch self {
            case .missingConfiguration:
                return "Invalid AI configuration: configuration file not found."
            case .invalidConfiguration(let reason):
                return "Invalid AI configuration: \(reason)"
            }
        }
    }

    private let endpoint: URL
    private let apiKey: String?
    private let model: String
    private let temperature: Double
    private let stream: Bool
    
    init() throws {
        guard let aiCfg = try AiCfgManager.readAiCfg() else {
            throw LLMClientError.missingConfiguration
        }

        guard let endpoint = aiCfg.endpoint, !endpoint.isEmpty else {
            throw LLMClientError.invalidConfiguration("endpoint is missing.")
        }
        guard let endpointURL = URL(string: endpoint) else {
            throw LLMClientError.invalidConfiguration("endpoint is invalid.")
        }
        guard let model = aiCfg.model, !model.isEmpty else {
            throw LLMClientError.invalidConfiguration("model is missing.")
        }
        guard let temperature = aiCfg.temperature else {
            throw LLMClientError.invalidConfiguration("temperature is missing.")
        }

        self.endpoint = endpointURL
        self.model = model
        self.temperature = temperature
        self.apiKey = aiCfg.apiKey
        self.stream = false
    }
    
    func sendPrompt(prompt: String) async throws -> String {
        let enhancedPrompt = buildCommandPrompt(userInput: prompt)
        let requestBody = LLMRequest(model: model, temperature: temperature, stream: stream, prompt: enhancedPrompt)
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let apiKey = apiKey {
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "LLMClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])
        }
        
        let decoded = try JSONDecoder().decode(LLMResponse.self, from: data)
        
        if let output = decoded.response {
            return output
        } else {
            throw NSError(domain: "LLMClient", code: -2, userInfo: [NSLocalizedDescriptionKey: decoded.error ?? "Unknown error"])
        }
    }

    func buildCommandPrompt(userInput: String) -> String {
        let osName = currentOSName()

        return """
        You are an expert command-line assistant.
        The user is running on \(osName).
        
        Your task: Generate the correct command that executes what the user requests.
        
        Requirements:
        - Respond ONLY in strict JSON format.
        - JSON schema: {"command": "<the command to run>"}
        - Do NOT include explanations, markdown, or additional text — only valid JSON.
        
        User request:
        "\(userInput)"
        """
    }
}
