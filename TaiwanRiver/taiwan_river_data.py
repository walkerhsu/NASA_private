import json
import pandas as pd

taiwanRiverNames = [
    "Huang River",
    "Danshuei River",
    "Nankan River",
    "Laojiie River",
    "Shezih River",
    "Fusing River",
    "Sinfong River",
    "Fongshan River",
    "Toucian River",
    "Keya River",
    "Yangang River",
    "Jhonggang River",
    "Houlong River",
    "Sihu River",
    "Da-an River",
    "Dajia River",
    "Wu River",
    "Jhuoshuei River",
    "Sin Huwei River",
    "Beigang River",
    "Puzih River",
    "Bajhang River",
    "Jishuei River",
    "Zengwun River",
    "Yanshuei River",
    "Erren River",
    "Agongdian River",
    "Gaoping River",
    "Donggang River",
    "Linbian River",
    "Shuaimang River",
    "Fangshan River",
    "Fonggang River",
    "Sihchong River",
    "Baoli River",
    "Gangkou River",
    "Jhihben River",
    "Lijiia River",
    "Tai Pingsi",
    "Beinan River",
    "Siouguluan River",
    "Hualien River",
    "Jian River",
    "Meilun River",
    "Sanjhan River",
    "Liwu River",
    "Heping River",
    "Nan-ao River",
    "Su-ao River",
    "Sincheng River",
    "Dongshan River",
    "Lanyang River",
    "Dezihkou River",
    "Shuangsi",
  ]

waterData = [
  "RPI",
  "DO(Electrode)",
  "BOD5",
  "SS",
  "NH3-N",
  "pH",
  "temperature",
]

if __name__ == "__main__":
    # Read the data from the json file
    with open("Taiwan_stations.json", "r") as f:
        data = json.load(f)
    
    river_df = pd.DataFrame(columns=["station", "latitude", "longitude", "river", "RPI", "DO(Electrode)", "BOD5", "SS", "NH3-N", "pH", "temperature"])
    
    for river in taiwanRiverNames:
        for station in data[river]:
            # Check if the station is in the river
            stations_name = station["station_name"]
            stations_latitude = station["latitude"]
            stations_longitude = station["longitude"]
            stations_river = station["water_area"]
            stations_RPI = 0
            stations_DO = 0
            stations_BOD5 = 0
            stations_SS = 0
            stations_NH3N = 0
            stations_pH = 0
            stations_temperature = 0
            for i in range(len(station["water"])):
                if station["water"][i]['name'] == "RPI":
                    stations_RPI = station["water"][i]['value']
                    stations_RPI_unit = station["water"][i]['unit']
                if station["water"][i]['name'] == "DO(Electrode)":
                    stations_DO = station["water"][i]['value']
                    stations_DO_unit = station["water"][i]['unit']
                if station["water"][i]['name'] == "BOD5":
                    stations_BOD5 = station["water"][i]['value']
                    stations_BOD5_unit = station["water"][i]['unit']
                if station["water"][i]['name'] == "SS":
                    stations_SS = station["water"][i]['value']
                    stations_SS_unit = station["water"][i]['unit']
                if station["water"][i]['name'] == "NH3-N":
                    stations_NH3N = station["water"][i]['value']
                    stations_NH3N_unit = station["water"][i]['unit']
                if station["water"][i]['name'] == "pH":
                    stations_pH = station["water"][i]['value']
                    stations_pH_unit = station["water"][i]['unit']
                if station["water"][i]['name'] == "Water Temp.":
                    stations_temperature = station["water"][i]['value']
                    stations_temperature_unit = station["water"][i]['unit']
            print(stations_name, stations_latitude, stations_longitude, stations_river, stations_RPI, stations_DO, stations_BOD5, stations_SS, stations_NH3N, stations_pH, stations_temperature)

            river_df = river_df._append({
                "station": stations_name,
                "latitude": stations_latitude, 
                "longitude": stations_longitude, 
                "river": stations_river, 
                "RPI": stations_RPI, 
                "DO(Electrode)": stations_DO, 
                "BOD5": stations_BOD5, 
                "SS": stations_SS, 
                "NH3-N": stations_NH3N, 
                "pH": stations_pH, 
                "temperature": stations_temperature,
                "RPI_unit": stations_RPI_unit,
                "DO(Electrode)_unit": stations_DO_unit,
                "BOD5_unit": stations_BOD5_unit,
                "SS_unit": stations_SS_unit,
                "NH3-N_unit":stations_NH3N_unit,
                "pH_unit": stations_pH_unit,
                "temperature_unit": stations_temperature_unit,
            }, ignore_index=True)

        # Save the dataframe to a csv file
        river_df.to_csv("Taiwan_river_data.csv", index=False)
        