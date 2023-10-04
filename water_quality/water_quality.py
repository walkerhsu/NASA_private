from pydap.client import open_url
import os
import netCDF4
import pandas as pd
# Open the dataset
if __name__ == "__main__":
    LAT_STEP = 40
    LON_STEP = 40
    TIME_IDX = 24
    # time : 2018 / 9 / 25 
    # lat start from 37 to -37
    # lon start from 0 to 360 
    LON = [i for i in range(0,360,int(LON_STEP/4))]
    LAT = [i for i in range(37,-37,-int(LAT_STEP/4))]
    LON.append(360)
    print(LON)
    print(LAT)
    cwd = os.getcwd()
    file2read = netCDF4.Dataset(cwd+'/water_quality.nc','r')
    print(file2read.variables.keys())
    MP_concentration = file2read.variables['MP_concentration'][TIME_IDX,:,:]
    stdev_MP_samples = file2read.variables['stdev_MP_samples']
    num_MP_samples = file2read.variables['num_MP_samples']

    # print(stdev_MP_samples)
    # print(num_MP_samples)

    MP_concentration_conpressed = []
    for lon in range(int(297/LAT_STEP)+1):
        MP_concentration_conpressed.append([])
        lon_idx = lon*LAT_STEP if lon*LAT_STEP < 297 else 296
        # print(f"lon_idx : {lon_idx}")

        for lat in range(int(1440/LON_STEP)+1):
            lat_idx = lat*LON_STEP if lat*LON_STEP < 1440 else 1439
            # print(f"lat_idx : {lat_idx}")
            # print(MP_concentration[lon_idx][lat_idx])
            MP_concentration_conpressed[lon].append(MP_concentration[lon_idx][lat_idx])

    print(len(MP_concentration_conpressed), len(MP_concentration_conpressed[0]))
    assert len(MP_concentration_conpressed) == len(LAT)
    assert len(MP_concentration_conpressed[0]) == len(LON)

    df = pd.DataFrame(MP_concentration_conpressed, index=LAT, columns=LON)
    df.to_csv('water_quality.csv')

    # print(time)
    # print()
    # print(MP_concentration)
    # print()
    # print(stdev_MP_samples)
    # print()
    # print(num_MP_samples)