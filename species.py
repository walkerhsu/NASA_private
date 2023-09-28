import os

if __name__ == "__main__":
    if not os.path.exists("gbif-observations-dwca.zip"):
        os.system(f"wget http://www.inaturalist.org/observations/gbif-observations-dwca.zip -O gbif-observations-dwca.zip")
    os.system(f"unzip gbif-observations-dwca.zip && rm -rf gbif-observations-dwca.zip")