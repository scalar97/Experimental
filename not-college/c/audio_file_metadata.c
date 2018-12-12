// Author : Tatiana Zihindula
// Mars 2017

#include <stdio.h>

//Struct for the MP3 file
typedef struct MP3
{
    char title[30];
    char artist[30];
    char album[30];
    char year[4];
    char comment[30];
    int genre[1];
}MP3;


int main(int argc, char* argv[])
{
    FILE *fp;

    if (argc < 2)
    {
        fprintf(stderr, "Error no mp3 file given.\n");
    }
    else if ( (fp = fopen(argv[1], "rb")) == NULL) /* opening the file if it exists*/
    {
        perror("Error "); /* Usualy no such file or directory */
    }
    else /* the file exists and has been opened in then else if above*/
    {
        /* struct variable */
        MP3 file;
        char buffer[3];

        printf("MP3 file found\n\n");

        /* Seeking at the end of files, 128 bytes away from the EOF */
        fseek(fp, -128, SEEK_END);

        /*reading the next 3 bytes*/
        fread(buffer, 1, sizeof(buffer), fp);

        /*Validating audio tag*/
        if (buffer[0] != 'T' && buffer[1] != 'A' && buffer[2] != 'G')
        {
            printf("Error: The file does not contain a valid audio tag.\n");
            return 0;
        }

        /*correct audio tag is present in MP3*/
        else
        {
            /*Will access the next 30 bytes after the audio
            tag and put them into the 'title' struct member*/
            fread(file.title, 1, 30, fp);
            file.title[29]=0;
            printf("Title: %s\n", file.title);


            /*next 30 bytes into the 'artist' struct member*/
            fread(file.artist, 1, 30, fp);
            file.artist[29]=0;
            printf("Artist: %s\n", file.artist);


            /*next 30 bytes into the 'Album' struct member*/
            fread(file.album, 1, 30, fp);
            file.album[29]=0;
            printf("Album: %s\n", file.album);


            /*next 4 bytes into the 'Album' struct member*/
            fread(file.year, 1, 4, fp);
            file.year[4]=0;
            printf("Year: %s\n", file.year);

            /*next 30 bytes into the 'comment' struct member*/
            fread(file.comment, 1, 30, fp);
            file.comment[29]=0;
            printf("Comment: %s\n", file.comment);


            /*the last byte into the 'genre' struct member*/
            fread(file.genre, 1, 1, fp);
            if (*file.genre < 0 || *file.genre > 80)
                printf("Genre: Unknown\n");
            else
                printf("Genre: %d\n", *file.genre);
        }
        fclose(fp);
    }
    return 0;
}
