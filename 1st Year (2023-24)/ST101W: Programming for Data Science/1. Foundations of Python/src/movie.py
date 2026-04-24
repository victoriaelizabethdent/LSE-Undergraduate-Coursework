import csv
import util
import time

# ----- Q2 PART 1 ----- #

movie_data = []

with open('../data/movies.csv', 'r') as file:
    csv_reader = csv.reader(file)
    next(csv_reader) # skips the header row of the csv file
    for row in csv_reader:
        movie_info = {'actor': row[0], 'movie': row[-2]}
        movie_data.append(movie_info)

# ----- Q2 PART 2: (a) ----- #
start_2a = time.time() 

actors_to_movies = {}

with open ('../data/movies.csv', 'r') as file:
    movies_dictionary = csv.DictReader(file)
    for row in movies_dictionary:
        if row['name'] not in actors_to_movies:
            actors_to_movies[row['name']] = [row['movie_title']]
        else:
            actors_to_movies[row['name']].extend([row['movie_title']])

end_2a = time.time() 
run_time_2a = end_2a - start_2a
print(f'The total runtime for Q2 PART 2: (a) was {run_time_2a} seconds')
            
# ----- Q2 PART 2: (b) ----- #
start_2b = time.time() 

actor_ids = []
movie_titles = []

with open('../data/movies.csv', 'r') as file:
    csv_reader = csv.reader(file)
    next(csv_reader) # # skips the header row of the csv file
    for row in csv_reader:
        if row[0] not in actor_ids:
            actor_ids.append(row[0])
            movie_titles.append([])
        for i in range(len(actor_ids)):
            if row[0] == actor_ids[i]:
                movie_titles[i].append(row[-1])

actor_to_movies_list = [actor_ids, movie_titles]

end_2b = time.time() 
run_time_2b = end_2b - start_2b
print(f'The total runtime for Q2 PART 2: (b) was {run_time_2b} seconds')

# ----- Q3 PART 1 ----- #

# STEP 1
actor_to_movie_count = util.count_items_per_key(actors_to_movies)

# STEP 2
actor_movie_count = util.filter_with_values_gt(actor_to_movie_count, 0)
movie_count_to_num_actors = util.get_occurences_per_value(actor_movie_count)

# STEP 3
ascending_tuples = sorted(movie_count_to_num_actors.items(), key=lambda movie:movie[0])
for key,value in ascending_tuples:
    print(f'{key}: {value}')

# ----- Q3 PART 2 ----- #
over_ten_movies = {}
    
# new dictionary with actors in over 10 movies
for actor, movies in actors_to_movies.items():
    if len(movies) > 10:
        over_ten_movies[actor] = movies

for actor1, movies1 in over_ten_movies.items():
    for actor2, movies2 in over_ten_movies.items(): 
        common_movies=[]
        if actor1 < actor2:
            for movie1 in movies1:
                for movie2 in movies2:
                    if movie1==movie2:
                        if movie1 not in common_movies:
                            common_movies.append(movie1)
        if len(common_movies) > 10:
            print(f"{actor1} and {actor2} have worked in {len(common_movies)} of the same movies.")

