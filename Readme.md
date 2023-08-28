# Weather Forecast App

This weather app shows you the current weather for the day and predicts the weather for the next five days. It's all on one easy-to-use page, and it's made using SwiftUI and Combine, which are tools for creating great user interfaces and managing data. The important behind-the-scenes parts have been tested to make sure they work correctly.

## Code Quality 
Quality was my priority while building this application, so used MVVM architecture. As this is a single page application created one view model and injected network manager and location manager. Moved all the business logic into Models and View Model. Test coverage was done for View Model and models. Implemented proper error handling and localization. 

## UI/UX
I chose simple and familiar colors that are commonly used on iOS, and the images in the app come from the OpenWeatherMap API. I followed Apple's guidelines for design and used SF Symbols, which are standard icons that are easy to recognize. The app looks good in both light and dark modes.

To make the user experience even better, I added some subtle animations to make things more engaging. I used straightforward images that are easy to understand, so users can quickly grasp the information. 

## Networking & Data Parsing:
I employed generics within Combine to create a flexible system for making API calls that works for different types of data. I also utilized enums to effectively manage various error scenarios, providing clear error messages for each situation.

However, there is substantial room for improvement. In the current state of the app, security and environmental considerations were not given priority. To make the app suitable for production, we can address these concerns. For instance, we can develop considering different environments such as QA, staging, and production, ensuring that the app behaves consistently across these contexts. Moreover, we can implement better security practices by securely hiding sensitive information like API keys. Exploring techniques like SSL pinning and adhering to app transport security guidelines will further enhance the app's security posture. These improvements will help make the app robust and ready for real-world deployment.

## Functionality:

Displaying screenshots to explain the functionality.

![Location Request](https://github.com/rajusmail444/Weather/blob/main/Images%20for%20Readme/Location.png){ width=50% }

I made the app request location information every time it's launched. Since the main focus of the app is weather, I didn't extensively explore advanced location features and how to manage them in-depth.


![Home](https://github.com/rajusmail444/Weather/blob/main/Images%20for%20Readme/Weather.gif)

The app requests your current location and uses it to show you the weather on the Home screen. This includes the current weather conditions as well as the forecasted weather for the upcoming days. This way, you can quickly see the weather information you need right when you open the app.

![]





