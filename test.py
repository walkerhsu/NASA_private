import pandas as pd
import numpy as np

if __name__ == "__main__":
    # dataframe add three columns
    df = pd.read_csv("America_river_data.csv")
    
    # df = pd.concat([df1, df2.reindex(df1.index)],  axis=1)
    # print(df)


    # species1 = df2["species1"].copy()
    # species2 = df2["species2"].copy()
    # species3 = df2["species3"].copy()

    df1["species1"] = df2["species1"].to_numpy()
    df1["species2"] = df2["species2"].to_numpy()
    df1["species3"] = df2["species3"].to_numpy()
    df1.to_csv("America_river_data.csv")

