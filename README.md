# Famous Speeches
Famous Speeches, an iOS app aims to give the user access to the Famous speeches in history. The speech along with it's text is associated with basic information:
-	Name
- Date
-	Speaker
-	Words of speech: Representing the most used word in the speech!

# Data Classes
- **Speech**: Hold information regarding the speech (name, date, speaker, image, text file). This class is being used throughout the App to get the speeches information
- **DatabaseManager**: Nothing fancy, mainly loading a json file containing all the speeches information

# UI Classes
- **SpeechesCollectionViewController**: Our landing page, contains summaries of the speeches along with an image
  - **SpeechCollectionViewCell**: The collection view cell structure
  - **PhotoCollectionViewLayout**: Custom layout used for displaying the speech summaries in waterfall flow **written in SwifT**
- **SpeechDetailTableViewController**: Shows detailed information for the selected speech
  - **SpeechDetailAnimator**: Provide a custom animation for the transition between SpeechesCollectionViewController & SpeechDetailTableViewController
- **DismissSegue**: Seque extension that implement

# Utility Classes
**MaxCountWordFinder**: Given a text, it scans it looking for the most used word. The implementation make use of Apple's NSLinguisticTagger

# Installation
The Code is known to work best with iOS 9.0 on iPhone & iPad devices, it haven't been tested on earlier iOS versions

# TODO
- Unit Test & UI Test
- The search button in SpeechesCollectionViewController is not functioning
- Adding icon, loading screen to make things more fancy
- Saving the user state, like the last search filter for better usability
- Adding images in different resolutions 1x , 2x & 3x
- The transition animation between the view controllers isn't perfect! could be enhanced to be more smooth

# ISSUES
- **Happens in simulator only!** Text in UITextView is hidden with long speeches. Exactly if it's height exceed 8192.0. I didn't have time to fix this bug. More about the bug is here http://stackoverflow.com/questions/23582497/uitextview-text-becomes-invisible-after-height-reaches-8192-0


