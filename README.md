# NASA_hackthon
## Main functions (App instructions):
1. On our BlueVista homepage, you can either choose to "Log in" for personalized usage or "Sign in as guests" for judging and testing.
2. On the map page, you can click on markers to navigate to the waterbody you are interested in. You can also use the Search bar on the top to directly get to any specific aquatic ecosystem in our database. (Of course, you can move the map by swiping the screen.)
3. Clicking on the placement card below, the information page will be displayed, and detailed information about the waterbody will be shown on it, containing "Water source", "Introduction", and "awareness of conservation".
4. On the information page, several species tags will also be shown at the bottom. Clicking on them, the exclusive page for that species will pop out, showing the "ranking", "Introduction", "Fun fact", and "3 tips for conserving" for that specific species. The ranking is designed for collection in the personal illustration book, and others are added to enrich our application with interesting facts and practical knowledge. Furthermore, since our app leverages powerful generative AI, this information will change every time you reload to the same page!

5. Back to the map, a function that is not yet mentioned is that the endangered species will pop out on the map as you approach! By clicking on the species, you can take pictures with it and collect it into your personal illustration book. Scrolling up and down in the illustration book, you can see all the endangered species you have currently met! If you complete the species collection in our database, never hesitate to share it proudly with your friends!

Thanks for listening and that's all for our instruction! Enjoy your time playing around with BlueVista.

## Benefits to users:

1. This app can satisfy users' scientific curiosity by providing them with various information on our waterbody page and species page.

2. This app can deal with users' practical concerns since it also displays the water quality on the water body page.

3. This app also provides users with useful tips about conserving the aquatic ecosystem and endangered species, which addresses users' ethical concerns.

4. Finally, our app also entertains the users by adding 3 additional functions. First, we add fun facts about species on the species page. (For example, Atlantic Salmon can leap up to 12 feet out of water!) Second, users can take pictures with endangered species when they are close to them and store these photos into their albums. Third, users can collect species in their illustration books, intriguing their desperation to finish the whole collection. Additionally, since we classify all species into different rarity ranks, the higher the rank of the species, the more users are inclined to include them in their collection.

## App developing details:

### Data collection and preprocessing

1. using python to process all CSV files

2. python web scraping/ automation

### Frontend Flutter Development

1. flutter SDK for the overall app

2. flutter_map package along with mapbox tiles for map displaying

3. flutter camera for camera controlling

### Backend Firebase/ Google Cloud Platform

1. firebase authentication for user login/logout

2. firebase storage for backend image saving

3. firebase hosting for web app deployment

4. GCP to save image while web app runs

### Version Control : git/ github

### AI tools: chatGPT for text generation / programming helper

## Small concerns: 

We only process water quality data for Taiwan and US, therefore, there wouldn't be detailed quality information in Canada datapoints.

Massive amounts of free and high-quality images for natural scenery are hard to obtain, therefore, we only use 10 - 20 images to represent all the rivers/creeks in each country.
## Datasets:
1. [Critical Habitat of Aquatic Species at Risk](https://mackenziedatastream.ca/en/download?fbclid=IwAR1mb0Xf0pI7jIKm5vQyTiOnD7VhfJw1iOO_zUUzEXEYI5steNQ3QEIK1Dk)
2. [Distribution FGP](https://open.canada.ca/data/en/dataset/e0fabad5-9379-4077-87b9-5705f28c490b)
3. [Water quality in Canadian rivers indicators](https://open.canada.ca/data/en/dataset/b1a61a9e-16ca-44a7-bf58-c9e4f4860884)
4. [Water data from Taiwan river observation station](https://wq.moenv.gov.tw/EWQP/en/EnvWaterMonitoring/River.aspx?fbclid=IwAR1xRbfgRkHeI61t3m2la2YRffZSVrD7U3RACuik6oVYpNgAWOmLuIJRL9Q)
5. [threatened species in Taiwan](https://www.inaturalist.org/observations?photos&place_id=7887&threatened&verifiable=any&view=species&iconic_taxa=Mollusca,Actinopterygii,unknown)