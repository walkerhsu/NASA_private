from pydap.client import open_url
import os
import netCDF4
import pandas as pd
import math
# Open the dataset
if __name__ == "__main__":
    RATIO = 0.2
    LAT_STEP = 10
    LON_STEP = 10
    TIME_IDX = -1
    # # time : 2018 / 9 / 25 
    # # lat start from 37 to -37
    # # lon start from 0 to 360 
    LON = [x+0.5 for x in range(0,360,LON_STEP)]
    LAT = []
    THETA_ANGLE = []
    PHI_ANGLE = []
    # LON.append(360)
    # print(LON)
    # print(LAT)
    cwd = os.getcwd()
    file2read = netCDF4.Dataset(cwd+'/ocean_current.nc','r')
    # print(file2read)
    # print(file2read.variables.keys())
    latitude = file2read.variables['latitude'][:]
    longitude = file2read.variables['longitude'][:]
    time = file2read.variables['time'][:]
    date = file2read.variables['date'][:]
    depth = file2read.variables['depth'][:]
    mask = file2read.variables['mask'][:]
    u = file2read.variables['u'][TIME_IDX][0]
    v = file2read.variables['v'][TIME_IDX][0]
    uf = file2read.variables['uf'][TIME_IDX][0]
    vf = file2read.variables['vf'][TIME_IDX][0]
    # print(latitude.shape)
    # print(longitude.shape)
    # print(time)
    # print(date)
    # print(depth)
    # print(mask.shape)
    # print(u.shape)
    # print(v.shape)
    # print(uf.shape)
    # print(type(uf[0][0]))
    
    # print(type(u[0][0]))
    for lat in range(len(u)):
        THETA_ANGLE.append([])
        PHI_ANGLE.append([])
        # RATIO = RATIO * math.cos(latitude[lat]*math.pi/180)
        circumference = 2 * math.pi * RATIO * math.cos(latitude[lat]*math.pi/180)
        for long in range(len(u[0])):
            # if v[lat][long] and u[lat][long]:
                PHI_ANGLE[-1].append(u[lat][long]/circumference)
                THETA_ANGLE[-1].append(v[lat][long]/(2 * math.pi * RATIO))
        # if lat % LAT_STEP == 0:
        #     LAT.append(lat)

    df = pd.DataFrame(PHI_ANGLE, index=latitude, columns=longitude)
    df.to_csv('ocean_current_phi_angle.csv')
    df = pd.DataFrame(THETA_ANGLE, index=latitude, columns=longitude)
    df.to_csv('ocean_current_theta_angle.csv')
    
    # print(time)
    # print()
    # print(MP_concentration)
    # print()
    # print(stdev_MP_samples)
    # print()
    # print(num_MP_samples)