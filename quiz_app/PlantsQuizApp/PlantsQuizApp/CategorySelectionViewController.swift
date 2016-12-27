//
//  ViewController.swift
//  PlantsQuizApp
//
//  Created by Pranav Tomar on 08/11/14.
//
//

import UIKit
import AVFoundation

enum Tags: Int {
    case topic1 = 1
    case topic2 = 2
    case topic3 = 3
    case topic4 = 4
    case category1 = 5
    case category2 = 6
    case category3 = 7
    case category4 = 8
    case category5 = 9
    case category6 = 10
    case category7 = 11
    case category8 = 12
    case category9 = 13
    case category10 = 14
    case category11 = 15
    case category12 = 16
}

class CategorySelectionViewController: UIViewController {

    var recognition: Bool?
    var usage: Bool?
    var exam: Bool?
    var selectedTopic: Int?
    var selectedCategories = [Int]()
    var difficulty: Int = 1
    var categoryUILabelsArray: [UILabel]?
    var categoryUIImagesArray: [UIImageView]?
    var topicUILabelsArray: [UILabel]?
    var topicUIImagesArray: [UIImageView]?
    var questionsArray = [Question]()
    var filteredQuestionsArray = [Question]()
    var totalQuestionsArray = [Question]()
    var questionStatsArray = [QuestionStats]()
    var topicArray = [Topic]()
    var round: Round?
    
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var topicHeadingLabel: UILabel!
    @IBOutlet weak var categoryHeadingLabel: UILabel!
    @IBOutlet weak var difficultyHeadingLabel: UILabel!
    
    // MARK:- IBOutlets for labels and images
    @IBOutlet weak var topic1Image: UIImageView!
    @IBOutlet weak var topic2Image: UIImageView!
    @IBOutlet weak var topic3Image: UIImageView!
    @IBOutlet weak var topic4Image: UIImageView!
    @IBOutlet weak var topic1Label: UILabel!
    @IBOutlet weak var topic2Label: UILabel!
    @IBOutlet weak var topic3Label: UILabel!
    @IBOutlet weak var topic4Label: UILabel!
    @IBOutlet weak var category1Image: UIImageView!
    @IBOutlet weak var category2Image: UIImageView!
    @IBOutlet weak var category3Image: UIImageView!
    @IBOutlet weak var category4Image: UIImageView!
    @IBOutlet weak var category5Image: UIImageView!
    @IBOutlet weak var category6Image: UIImageView!
    @IBOutlet weak var category7Image: UIImageView!
    @IBOutlet weak var category8Image: UIImageView!
    @IBOutlet weak var category9Image: UIImageView!
    @IBOutlet weak var category10Image: UIImageView!
    @IBOutlet weak var category11Image: UIImageView!
    @IBOutlet weak var category12Image: UIImageView!
    @IBOutlet weak var category1Label: UILabel!
    @IBOutlet weak var category2Label: UILabel!
    @IBOutlet weak var category3Label: UILabel!
    @IBOutlet weak var category4Label: UILabel!
    @IBOutlet weak var category5Label: UILabel!
    @IBOutlet weak var category6Label: UILabel!
    @IBOutlet weak var category7Label: UILabel!
    @IBOutlet weak var category8Label: UILabel!
    @IBOutlet weak var category9Label: UILabel!
    @IBOutlet weak var category10Label: UILabel!
    @IBOutlet weak var category11Label: UILabel!
    @IBOutlet weak var category12Label: UILabel!
    @IBOutlet weak var mainTopicLabel: UILabel!
    @IBOutlet weak var mainCategoryLabel: UILabel!
    @IBOutlet weak var mainDifficultyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeLabelsAndButtonsFontColorAndSize()
        
        categoryUILabelsArray = [category1Label, category2Label, category3Label, category4Label,category5Label, category6Label, category7Label, category8Label, category9Label,category10Label, category11Label, category12Label ]
        categoryUIImagesArray = [category1Image, category2Image, category3Image, category4Image,category5Image, category6Image, category7Image, category8Image, category9Image,category10Image, category11Image, category12Image ]
        topicUIImagesArray = [topic1Image, topic2Image, topic3Image, topic4Image ]
        topicUILabelsArray = [topic1Label, topic2Label, topic3Label, topic4Label ]

        selectedTopic = 1
        difficulty = 1
        topicArray = topicArray as Array
        setGestures()
        setInitialVisibilitySettings()
        setTopicsOnScreen()
        
        if self.exam == true {
            easyButton.enabled = false
            hardButton.enabled = false
            easyButton.hidden = true
            hardButton.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "textQuestionIdentifier" {
            let destinationVC = segue.destinationViewController as TextAnswerViewController
            destinationVC.round = round
            if self.exam == true {
                destinationVC.isExam = true
            }
            else {
                destinationVC.isExam = false
            }
            AudioManagerHelper.sharedAudioManagerHelper.audioPlayer?.stop()
        } 
        AudioManagerHelper.sharedAudioManagerHelper.playBackgroundMusic("During the game 2")
    }
    
    func changeLabelsAndButtonsFontColorAndSize() {
        FontHelper.sharedFontHelper.changeButtonFont(easyButton, fontSize: 22, fontColor: Colors.yellow.rawValue)
        FontHelper.sharedFontHelper.changeButtonFont(hardButton, fontSize: 22, fontColor: Colors.yellow.rawValue)
        FontHelper.sharedFontHelper.changeLabelFont(topicHeadingLabel, fontSize: 36, fontColor: Colors.yellow.rawValue)
        FontHelper.sharedFontHelper.changeLabelFont(categoryHeadingLabel, fontSize: 36, fontColor: Colors.yellow.rawValue)
        FontHelper.sharedFontHelper.changeLabelFont(difficultyHeadingLabel, fontSize: 36, fontColor: Colors.yellow.rawValue)
    }
    
    func setTopicsOnScreen() {
        var labelsArray = topicUILabelsArray! as Array
        for var index = 0; index < topicArray.count; ++index {
            labelsArray[index].text = topicArray[index].topicName
            FontHelper.sharedFontHelper.changeLabelFont(labelsArray[index], fontSize: 20, fontColor: Colors.darkGreen.rawValue)
        }
    }
    
    // Filtering questions for the quiz screen
    func filterQuestionArray() {
        var questionType: Int?
        if recognition == true {
            questionType = 1  // 1 for recognition questions
        }
        else {
            if usage == true {
                questionType = 2  // 2 for usage questions
            }
            else {
                questionType = 3  // 3 for exam questions
            }
        }
        
        if selectedCategories.count == 0 { //if user doesnt select category, category1 is default.
            selectedCategories.append(1)
        }
        
        if questionType == 3 {  // if it is exam, just topic is filtered
            totalQuestionsArray = questionsArray.filter{ $0.topicID == self.selectedTopic}
        }
        else { // if it is other than exam, filter according to the all settings
            for selectedCat in selectedCategories {
                filteredQuestionsArray = questionsArray.filter {
                    $0.questionType == questionType && $0.topicID == self.selectedTopic && $0.difficulty == self.difficulty && $0.categoryID == selectedCat
                }
                totalQuestionsArray = totalQuestionsArray + filteredQuestionsArray
            }
        }
        println("#>Number of filtered questions is: \(totalQuestionsArray.count)")
        
        //create the random questions list for a round
        //var roundQuestions = getRoundQuestions(totalQuestionsArray)
        var roundQuestions = getRoundQuestions(totalQuestionsArray)
        
        matchStatsToQuestions(questionStatsArray, questions: totalQuestionsArray)
        println("#>Number of round questions is: \(totalQuestionsArray.count)")
        round = Round(roundID: 1, questionsList: roundQuestions, topicID: selectedTopic!, categoriesID: selectedCategories, language: "DE")
    }
    
    func getRoundQuestions(questions: [Question]) -> [Question] {
        let maximumIndex = questions.count
        var roundQuestions = [Question]()
        
        var roundSize = GameConfiguration.roundSize()
        if self.exam == true {
           roundSize = GameConfiguration.examRoundSize()
        }
        
        while roundQuestions.count < roundSize {
            let selectedIndex = Int(arc4random_uniform(maximumIndex+0))
            let selectedQuestion = questions[selectedIndex]
            if !contains(roundQuestions, selectedQuestion) {
                roundQuestions += [selectedQuestion]
            }
        }
        return roundQuestions
    }
     
    func matchStatsToQuestions(stats: [QuestionStats], questions: [Question]) {
        var foundStat = false
        var createObject = false
        for question in questions {
            if stats.count == 0 {
                createObject = true
            }
            else {
                for stat in stats {
                    if stat.questionID == question.questionID {
                        question.questionStat = stat;
                        foundStat = true;
                    }
                }
            }
            
            if createObject == true || foundStat == false {
                var stat = QuestionStats(questionID: question.questionID, answeredCounts: 0, correctCounts: 0)
                question.questionStat = stat
            }
            foundStat = false
            createObject = false
        }
    }

    // Category related method
    func showCategories(categoriesArray: [Category]) {
        var labelsArray = categoryUILabelsArray! as Array
        var imagesArray = categoryUIImagesArray! as Array
        for var index = 0; index < categoriesArray.count; ++index {
            labelsArray[index].text = categoriesArray[index].categoryName
            labelsArray[index].hidden = false
            imagesArray[index].hidden = false
            FontHelper.sharedFontHelper.changeLabelFont(labelsArray[index], fontSize: 15, fontColor: Colors.darkGreen.rawValue)
        }
    }
    
    func updateSelectedCategoriesArray(categoryID: Int) {
        if selectedCategories.filter({ el in el == categoryID }).count == 0 {
            selectedCategories.append(categoryID)
        }
    }
    
    // Set initial settings for the screen
    func setInitialVisibilitySettings() {
        var labelsArray = categoryUILabelsArray! as Array
        var imagesArray = categoryUIImagesArray! as Array
        for var index = 0; index < labelsArray.count; ++index {
            labelsArray[index].hidden = true
            imagesArray[index].hidden = true
        }
    }
    
    func getTappedItem(sender: UITapGestureRecognizer) {
        let uiView = self.view.hitTest(sender.locationInView(self.view), withEvent: nil)
        let topicImageArray = topicUIImagesArray! as Array
        let categoryImageArray = categoryUIImagesArray! as Array
        
        if let tappedItem = uiView?.tag {
            var tapped = Tags(rawValue: tappedItem)?
            if tapped != nil {
                if (tappedItem < 5) { //If tapped tag is less than 5, then tapped item is topic
                    selectedTopic = tappedItem
                    var index = 1
                    for uiImageTopic in topicImageArray {
                        uiImageTopic.image = UIImage(named: "Topic\(index)")
                        index = index + 1
                    }
                    topicImageArray[tappedItem - 1].image = UIImage(named: "SelectedTopic\(tappedItem)White")
                    
                    setInitialVisibilitySettings()
                    var topicCategories = topicArray[tappedItem - 1].categories! as Array
                    self.showCategories(topicCategories)
                    selectedCategories.removeAll(keepCapacity: false)
                }
                if self.exam == false {
                    if (tappedItem > 4 && tappedItem < 17) { //Its means tapped item is category
                        var topicCategories = topicArray[selectedTopic! - 1].categories! as Array
                        categoryImageArray[tappedItem - 5].image = UIImage(named: "SelectedCategoryLeaf")
                        var topicCategoryID = topicCategories[tappedItem - 5].categoryID
                        self.updateSelectedCategoriesArray(topicCategoryID)
                    }
                }
            }
        }
    }
    
    func setGestures() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "getTappedItem:")
        self.view.addGestureRecognizer(gestureRecognizer)
    }

    // MARK:- IBActions:
    @IBAction func easyButtonClicked() {
        self.difficulty = 1
        println("Selected difficulty: \(self.difficulty)")
    }
    
    @IBAction func hardButtonClicked() {
        self.difficulty = 2
        println("Selected difficulty: \(self.difficulty)")
    }
    
    @IBAction func homeButtonClicked(sender: UIButton) {
    }

    @IBAction func startRoundAction(sender: AnyObject) {
        filterQuestionArray() // totalQuestionsArray is filled with filteredQuestions
        performSegueWithIdentifier("textQuestionIdentifier", sender: self)
    }
}
