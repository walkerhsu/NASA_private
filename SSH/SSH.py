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
    file2read = netCDF4.Dataset(cwd+'/SSH.nc','r')
    print(file2read)
    print(file2read.variables.keys())
    latitude = file2read.variables['Latitude'][:]
    longitude = file2read.variables['Longitude'][:]
    sla = file2read.variables['SLA'][0,:,:]
    
    df = pd.DataFrame(sla, index=list(latitude), columns=list(longitude))
    df.to_csv('SSH.csv')
    print(latitude)
    print(longitude)
    # print(sla[0])

