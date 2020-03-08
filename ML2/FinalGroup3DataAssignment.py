from pyspark.sql import SparkSession
from pyspark.sql import Row
from pyspark.sql.functions import count, avg, col

def loadMovieNames():
    movieNames = {}
    with open("ml-100k/u.ITEM") as f:
        for line in f:
            fields = line.split('|')
            movieNames[int(fields[0])] = fields[1]
    return movieNames

# Create a SparkSession
spark = SparkSession.builder.config("spark.sql.warehouse.dir", "file:///C:/tmp").appName("BestMovies").getOrCreate()

# Load up our movie ID -> name dictionary
nameDict = loadMovieNames()

#Load the data
lines = spark.sparkContext.textFile("file:///SparkCourse/ml-100k/u.data")
#Convert to RDD with rows as objects
movies = lines.map(lambda x: Row(movieID =int(x.split()[1]),rating=x.split()[2]))

#Convert RDD above to a dataframe
movieDataset = spark.createDataFrame(movies)

#Group by movieID. Average ratings for each movie and count ratings per movie
bestMovieIDs = movieDataset.groupBy("movieID").agg(avg("rating").alias("avgRating"), count("movieID").alias("Ratings")).filter(col("Ratings")>=100)

orderedMovieIDs=bestMovieIDs.orderBy("avgRating", ascending=True).collect()

# Print the results
print('{:<40}{:>10}{:>10}'.format("Movie","Average","Ratings"))
for result in orderedMovieIDs:
    # Each row has movieID, count as above.
    print('{:<40}{:>10}{:>10}'.format(nameDict[result[0]][0:40], round(result[1],3), result[2]))

# Stop the session
spark.stop()

# !spark-submit Module6DataAssignment.py > Module6DataAssignmentOutput.txt
