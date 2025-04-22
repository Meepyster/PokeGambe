# This is PokeGambe!
## Basic use of the app
https://streamable.com/3g7mgf?src=player-page-share

The JSON data comes from an API I created with FastAPI and launched CI/CD with OKD here:<br> 
https://poke-app-comp590-140-25sp-forian.apps.unc.edu/docs<br> 

# Features
The main feature app lets users pull cards from $35 packs. After the pack is received, there is the option to sell or save the card to your PokeDex. After, you can sell the cards you have obtained. However, there is a history dex that saved all previous cards even if sold.
The goal is to have the largest balance and dex value as possible.

# Obstacles
The level of complexity is very deceiving. It seemed very simple, but there are so many angles to look at elements in the app.
You need to code for all the different ways a user wants to interact with or exploit your app. I fixed at least 8 money generator bugs. Luckily, as I was going on, I started to think ahead of time and created enough @State vars I can have a good way of controling everything.
The hardest part was easily separating views. Because I wanted to develop as fast as possible, I forwent separating views in malpractice and kept going forward.

# Future Additions
- Add Funds
- Calculate score based on dex value, balance and maybe more values
- More options such as playing with real world values
- reset history
- Add sound effects
- Many More!

