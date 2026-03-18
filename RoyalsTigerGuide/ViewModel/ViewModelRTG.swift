import Foundation
import Observation
import SwiftUI
import SwiftData

@Observable
final class ViewModelRTG {

    var articles: [ArticleModelRTG] = []
    var tasks: [TaskModelRTG] = []
    var tigerSpecies: [TigerSpeciesModelRTG] = []
    var quizQuestions: [QuizQuestionModelRTG] = []

    var currentQuizIndex: Int = 0
    var quizScore: Int = 0
    var quizAnswered: Bool = false
    var quizSelectedIndex: Int? = nil
    var quizFinished: Bool = false
    var quizTimeRemaining: Int = 20
    var quizTimerActive: Bool = false

    var currentTaskStepIndex: Int = 0
    var activeTask: TaskModelRTG? = nil

    var navigationRootRevision: Int = 0
    private(set) var shouldSelectHomeTabAfterNavReset: Bool = false

    var searchText: String = ""

    var selectedSpeciesForCompare: [TigerSpeciesModelRTG] = []
    var showCompareMode: Bool = false

    var simulatorPrey: String = "Deer"
    var simulatorTerrain: String = "Dense Forest"
    var simulatorTimeOfDay: String = "Dawn"
    var simulatorSelectedSpecies: TigerSpeciesModelRTG? = nil
    var simulatorResult: SimulatorResultRTG? = nil
    var simulatorAnimating: Bool = false

    var labTemperature: Double = 25.0
    var labPreyDensity: Double = 50.0
    var labTerritorySize: Double = 100.0
    var labHumanActivity: Double = 20.0

    var conservationSupports: [String: Int] = [:]

    init() {
        loadAllData()
    }

    func loadAllData() {
        articles = JSONLoaderRTG.load("articlesRTG")
        tasks = JSONLoaderRTG.load("tasksRTG")
        tigerSpecies = JSONLoaderRTG.load("tigerSpeciesRTG")
        quizQuestions = JSONLoaderRTG.load("quizQuestionsRTG")

        if let saved = UserDefaults.standard.dictionary(forKey: "conservationSupportsRTG") as? [String: Int] {
            conservationSupports = saved
        }
    }

    var filteredArticles: [ArticleModelRTG] {
        if searchText.isEmpty { return articles }
        return articles.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    var filteredTasks: [TaskModelRTG] {
        if searchText.isEmpty { return tasks }
        return tasks.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    var filteredSpecies: [TigerSpeciesModelRTG] {
        if searchText.isEmpty { return tigerSpecies }
        return tigerSpecies.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    func article(byId id: String) -> ArticleModelRTG? {
        articles.first { $0.id == id }
    }

    func startTask(_ task: TaskModelRTG) {
        activeTask = task
        currentTaskStepIndex = 0
    }

    func nextTaskStep() {
        guard let task = activeTask else { return }
        if currentTaskStepIndex < task.steps.count - 1 {
            currentTaskStepIndex += 1
        }
    }

    func returnToHomeRootAfterTask() {
        activeTask = nil
        currentTaskStepIndex = 0
        navigationRootRevision += 1
        shouldSelectHomeTabAfterNavReset = true
    }

    func consumeHomeTabSelectionAfterNavReset() {
        shouldSelectHomeTabAfterNavReset = false
    }

    func resetQuiz() {
        currentQuizIndex = 0
        quizScore = 0
        quizAnswered = false
        quizSelectedIndex = nil
        quizFinished = false
        quizTimeRemaining = 20
    }

    func answerQuiz(_ index: Int) {
        guard !quizAnswered else { return }
        quizSelectedIndex = index
        quizAnswered = true
        if index == quizQuestions[currentQuizIndex].correctIndex {
            quizScore += 1
        }
    }

    func nextQuizQuestion() {
        if currentQuizIndex < quizQuestions.count - 1 {
            currentQuizIndex += 1
            quizAnswered = false
            quizSelectedIndex = nil
            quizTimeRemaining = 20
        } else {
            quizFinished = true
        }
    }

    func runSimulation() {
        guard let species = simulatorSelectedSpecies else { return }
        simulatorAnimating = true

        let terrainModifier: Double
        switch simulatorTerrain {
        case "Dense Forest": terrainModifier = 1.2
        case "Open Grassland": terrainModifier = 0.7
        case "Snowy Terrain": terrainModifier = 0.9
        case "Mangrove Swamp": terrainModifier = 1.0
        case "Rocky Mountain": terrainModifier = 0.8
        default: terrainModifier = 1.0
        }

        let timeModifier: Double
        switch simulatorTimeOfDay {
        case "Dawn": timeModifier = 1.3
        case "Day": timeModifier = 0.6
        case "Dusk": timeModifier = 1.4
        case "Night": timeModifier = 1.1
        default: timeModifier = 1.0
        }

        let preyDifficulty: Double
        switch simulatorPrey {
        case "Deer": preyDifficulty = 0.3
        case "Wild Boar": preyDifficulty = 0.5
        case "Gaur": preyDifficulty = 0.8
        case "Young Elephant": preyDifficulty = 0.95
        case "Fish": preyDifficulty = 0.15
        default: preyDifficulty = 0.5
        }

        let stealthScore = Double(species.traits.stealth) * terrainModifier
        let speedScore = Double(species.traits.speed) * timeModifier
        let strengthScore = Double(species.traits.strength)

        let baseSuccess = (stealthScore * 0.4 + speedScore * 0.3 + strengthScore * 0.3)
        let adjustedSuccess = min(98, max(5, baseSuccess * (1.0 - preyDifficulty * 0.6)))
        let successPercent = Int(adjustedSuccess)

        let energyCost = Int(preyDifficulty * 80 + (1.0 - terrainModifier) * 30 + 20)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.simulatorResult = SimulatorResultRTG(
                successChance: successPercent,
                energyCost: min(100, energyCost),
                stealthRating: Int(stealthScore),
                speedRating: Int(speedScore),
                strengthRating: Int(strengthScore),
                verdict: successPercent > 70 ? "High probability of a successful hunt" :
                         successPercent > 40 ? "Moderate chance, tiger may attempt" :
                         "Low probability, tiger would likely wait for better opportunity"
            )
            self?.simulatorAnimating = false
        }
    }

    var behaviorPrediction: BehaviorPredictionRTG {
        let activityLevel: String
        let huntingFrequency: String
        let socialBehavior: String
        let territoryPatrol: String

        if labTemperature < 10 {
            activityLevel = "Reduced activity, conserving energy in cold conditions"
            huntingFrequency = "Less frequent but targeting larger prey for efficiency"
        } else if labTemperature > 35 {
            activityLevel = "Primarily nocturnal, resting during extreme heat"
            huntingFrequency = "Concentrated at dawn and dusk near water sources"
        } else {
            activityLevel = "Optimal activity levels across dawn and dusk periods"
            huntingFrequency = "Regular hunting cycles every 3-5 days"
        }

        if labPreyDensity > 70 {
            socialBehavior = "Tolerant of nearby tigers, occasional shared kills"
        } else if labPreyDensity > 30 {
            socialBehavior = "Standard solitary behavior with clear territory boundaries"
        } else {
            socialBehavior = "Highly territorial, aggressive toward intruders"
        }

        if labTerritorySize > 200 {
            territoryPatrol = "Extended patrol routes, marking boundaries every 7-10 days"
        } else if labTerritorySize > 80 {
            territoryPatrol = "Regular patrol circuits completed every 3-5 days"
        } else {
            territoryPatrol = "Intensive daily patrols of compact territory"
        }

        let stressLevel = min(100, max(0, Int(labHumanActivity * 1.2 + (100 - labPreyDensity) * 0.3)))

        return BehaviorPredictionRTG(
            activityLevel: activityLevel,
            huntingFrequency: huntingFrequency,
            socialBehavior: socialBehavior,
            territoryPatrol: territoryPatrol,
            stressLevel: stressLevel
        )
    }

    func supportConservation(_ projectId: String) {
        conservationSupports[projectId, default: 0] += 1
        UserDefaults.standard.set(conservationSupports, forKey: "conservationSupportsRTG")
    }

    func conservationSupportCount(_ projectId: String) -> Int {
        conservationSupports[projectId, default: 0]
    }

    var totalConservationImpact: Int {
        conservationSupports.values.reduce(0, +)
    }
}

struct SimulatorResultRTG {
    let successChance: Int
    let energyCost: Int
    let stealthRating: Int
    let speedRating: Int
    let strengthRating: Int
    let verdict: String
}

struct BehaviorPredictionRTG {
    let activityLevel: String
    let huntingFrequency: String
    let socialBehavior: String
    let territoryPatrol: String
    let stressLevel: Int
}

struct ConservationProjectRTG: Identifiable {
    let id: String
    let name: String
    let region: String
    let goal: Int
    let iconName: String
    let description: String
}

let conservationProjectsRTG: [ConservationProjectRTG] = [
    ConservationProjectRTG(id: "proj_1", name: "Sundarbans Tiger Corridor", region: "India/Bangladesh", goal: 500, iconName: "iconOne", description: "Establishing protected corridors connecting fragmented tiger habitats in the Sundarbans mangrove delta"),
    ConservationProjectRTG(id: "proj_2", name: "Amur Tiger Patrol Network", region: "Russian Far East", goal: 400, iconName: "iconTwo", description: "Funding anti-poaching patrol teams across the Sikhote-Alin mountain range"),
    ConservationProjectRTG(id: "proj_3", name: "Sumatran Rainforest Shield", region: "Indonesia", goal: 600, iconName: "iconThree", description: "Protecting primary rainforest from palm oil plantation expansion in tiger habitat zones"),
    ConservationProjectRTG(id: "proj_4", name: "Nepal Community Guards", region: "Nepal", goal: 350, iconName: "iconFour", description: "Training local community members as wildlife guardians in buffer zone forests"),
    ConservationProjectRTG(id: "proj_5", name: "Camera Trap Expansion", region: "Southeast Asia", goal: 450, iconName: "iconFive", description: "Deploying 500 new camera traps across tiger habitats in Myanmar and Thailand"),
    ConservationProjectRTG(id: "proj_6", name: "Genetic Rescue Program", region: "Malaysia", goal: 300, iconName: "iconSix", description: "Facilitating gene flow between isolated Malayan tiger populations through managed corridors"),
    ConservationProjectRTG(id: "proj_7", name: "Prey Recovery Initiative", region: "India", goal: 550, iconName: "iconSeven", description: "Restoring deer and wild boar populations in depleted tiger reserves through habitat management"),
    ConservationProjectRTG(id: "proj_8", name: "Tiger Education Outreach", region: "Global", goal: 700, iconName: "iconEight", description: "Developing educational programs in schools near tiger habitats to build conservation awareness")
]
