import pandas as pd
if __name__ == "__main__":
    # dataframe drop late column
    df = pd.read_csv("America_species.csv")
    df = df.drop(['place_guess'], axis = 1)
    df.to_csv("America_species.csv", index = False)

