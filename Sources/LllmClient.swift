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
    private let baseURL: URL
    private let apiKey: String?
    private let model: String
    private let temperature: Double
    private let stream: Bool
    
    init() {
        guard let url = URL(string: "http://localhost:11434/api/generate") else {
            fatalError("Invalid base URL")
        }
        self.baseURL = url
        self.model = "qwen3"
        self.temperature = 0.2
        self.apiKey = nil
        self.stream = false
    }
    
    func sendPrompt(prompt: String) async throws -> String {
        let enhancedPrompt = buildCommandPrompt(userInput: prompt)
        let requestBody = LLMRequest(model: model, temperature: temperature, stream: stream, prompt: enhancedPrompt)
        
        var request = URLRequest(url: baseURL)
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
