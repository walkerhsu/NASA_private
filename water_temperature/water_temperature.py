from pydap.client import open_url
import os
import netCDF4
import pandas as pd
# Open the dataset
if __name__ == "__main__":
    # LAT_STEP = 10
    # LON_STEP = 10
    # TIME_IDX = -1
    # # # time : 2018 / 9 / 25 
    # # # lat start from 37 to -37
    # # # lon start from 0 to 360 
    # LON = [x+0.5 for x in range(0,360,LON_STEP)]
    # LAT = []
    # LON.append(360)
    # print(LON)
    # print(LAT)
    cwd = os.getcwd()
    file2read = netCDF4.Dataset(cwd+'/water_temperature.nc','r')
    # print(file2read)
    # print(file2read.variables.keys())
    latitude = file2read.variables['lat'][:]
    level = file2read.variables['lev'][:]
    longitude = file2read.variables['lon'][:]
    sst = file2read.variables['sst'][0][0]
    time = file2read.variables['time'][:]
    ssta = file2read.variables['ssta'][0][0]
    
    df = pd.DataFrame(sst, index=list(latitude), columns=list(longitude))
    df.to_csv('water_temperature.csv')
    # print(latitude)
    # print(level)
    # print(longitude)
    # print(sst.shape)
    # print(time)
