import media
import movie_website

toy_story= media.Movie('Toy Story', storyline='A toy story',
					   image='https://en.wikipedia.org/wiki/File:Toy_Story.jpg',
					   trailer='https://www.youtube.com/watch?v=KYz2wyBy3kc')

avatar   = media.Movie('Avatar', storyline='Awesome movie',
					   image='https://en.wikipedia.org/wiki/File:Avatar-Teaser-Poster.jpg',
					   trailer='https://www.youtube.com/watch?v=cRdxXPV9GNQ')

the_matrix = media.Movie('The Matrix', storyline='Is our world is similation?',
					   image='https://en.wikipedia.org/wiki/File:The_Matrix_Poster.jpg',
					   trailer='https://www.youtube.com/watch?v=vKQi3bBA1y8')

casino_royale= media.Movie('Casino royale', storyline='James Bond Movie',
					   image='https://en.wikipedia.org/wiki/File:Casino_Royale_2_-_UK_cinema_poster.jpg',
					   trailer='https://www.youtube.com/watch?v=fl5WHj0bZ2Q')

movie_website.open_movies_page([casino_royale, the_matrix, avatar,toy_story])
