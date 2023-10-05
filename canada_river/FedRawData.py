import pandas as pd
import json

tags = [
    0, 2, 3, 4, 7, 8, 17, 18, 20, 26, 28, 30, 32
    # PROV_TERR
    # SITE_NAME_NOM
    # DATE
    # VARIABLE
    # VALUE_VALEUR
    # UNIT_UNITE
    # LATITUDE
    # LONGITUDE
    # LAND USE
    # REGION
    # DRAINAGE_REGION
    # OCEAN_DRAINAGE_AREA
    # ECOZONE
]

if __name__ == '__main__':
    df = pd.read_csv('./FedRawData.csv', encoding='Windows 1252', usecols=tags, keep_default_na=False)
    site_names = df['SITE_NAME_NOM'].unique()
    regions = df['REGION'].unique()
    drainage_regions = df['DRAINAGE_REGION'].unique()
    ocean_drainage_areas = df['OCEAN_DRAINAGE_AREA'].unique()
    ecozones = df['ECOZONE'].unique()
    data = dict()
    # print(regions, drainage_regions, ocean_drainage_areas, ecozones, sep = '\n')
    for site_name in site_names:
        selected_rows = df.loc[df['SITE_NAME_NOM'].isin([site_name])]
        data_site = dict()
        data_site['PROV_TERR'] = selected_rows.iloc[0]['PROV_TERR']
        data_site['LATITUDE'] = selected_rows.iloc[0]['LATITUDE']
        data_site['LONGITUDE'] = selected_rows.iloc[0]['LONGITUDE']
        data_site['LAND USE'] = selected_rows.iloc[0]['LAND USE']
        if(selected_rows.iloc[0]['REGION'] == ""): data_site['REGION'] = 0
        else: data_site['REGION'] = selected_rows.iloc[0]['REGION']
        data_site['DRAINAGE_REGION'] = selected_rows.iloc[0]['DRAINAGE_REGION']
        data_site['OCEAN_DRAINAGE_AREA'] = selected_rows.iloc[0]['OCEAN_DRAINAGE_AREA']
        data_site['ECOZONE'] = selected_rows.iloc[0]['ECOZONE']
        data_site['EVENTS'] = []
        dates = {}
        for index, value in selected_rows.iterrows():
            # print(value)
            date = 0
            variable = {}
            for i, j in value.items():
                val = j
                if(j == ""): val = 0
                if i == 'DATE':
                    date = j
                    if j not in dates.keys(): 
                        dates[j] = {"VARIABLES": []}
                elif i == 'VARIABLE': variable['VARIABLE'] = val
                elif i == 'VALUE_VALEUR': variable['VALUE'] = val
                elif "UNIT" in i: variable['UNIT'] = val
                # elif i != 'SITE_NAME_NOM': data_site[i] = j
            dates[date]["VARIABLES"].append(variable)
                
            # data[site_name].append(data_site)
            # break

        for i, j in dates.items():
            data_site['EVENTS'].append({
                "DATE": i,
                "VARIABLES": j["VARIABLES"]
            })
        # print(data_site)
        data[site_name] = data_site
        # break
        # print(data_site)
        # print(selected_rows)
    # print(data)
    # json_object = json.dumps(data, indent = 2) 
    # print(json_object)
    with open("CleanData.json", "w") as outfile:
        json.dump(data, outfile)
    
    