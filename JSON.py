import json

a = {
    "pic" : 
    [
        "https://t3.ftcdn.net/jpg/01/13/46/78/360_F_113467839_JA7ZqfYTcIFQWAkwMf3mVmhqXr7ZOgEX.jpg",
        "https://images.unsplash.com/photo-1437482078695-73f5ca6c96e2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cml2ZXJ8ZW58MHx8MHx8fDA%3D&w=1000&q=80",
        "https://upload.wikimedia.org/wikipedia/commons/d/de/Elwha_River_-_Humes_Ranch_Area2.JPG",
        "https://smartwatermagazine.com/sites/default/files/styles/thumbnail-830x455/public/what_is_a_river.jpg?itok=7SHK_wQm",
        "https://img.traveltriangle.com/blog/wp-content/uploads/2018/09/cover30.jpg",
        "https://cdn.britannica.com/97/158797-050-ABECB32F/North-Cascades-National-Park-Lake-Ann-park.jpg?w=400&h=300&c=crop",
        "https://media.istockphoto.com/id/1069539210/photo/fantastic-autumn-sunset-of-hintersee-lake.jpg?s=612x612&w=0&k=20&c=oqKJzUgnjNQi-nSJpAxouNli_Xl6nY7KwLBjArXr_GE=",
        "https://www.sciencenews.org/wp-content/uploads/2022/09/092822_js_fewer-blue-lakes_feat.jpg",
        "https://www.sciencenews.org/article/climate-change-lake-color-blue-green-brown",
        "https://d3qvqlc701gzhm.cloudfront.net/thumbs/daf73532a7b2c2653b9475a031c5e142d1d1eab2ff6fbedcc55af10aacc7dbc5-750.jpg"
    ]
}
with open("station_picurl.json" ,"w") as f:
    json.dump(a, f)